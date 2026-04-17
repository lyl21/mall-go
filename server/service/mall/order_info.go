package mall

import (
	"errors"
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// 订单状态常量（与Java原实现一致）
// 0、待付款 1、待发货 2、待收货 3、已完成 5、已关闭
const (
	OrderStatusUnpaid    = "0" // 待付款
	OrderStatusPaid      = "1" // 待发货（已支付）
	OrderStatusShipped   = "2" // 待收货
	OrderStatusCompleted = "3" // 已完成
	OrderStatusClosed    = "5" // 已关闭/已取消
)

// 状态流转规则
var validTransitions = map[string][]string{
	OrderStatusUnpaid:    {OrderStatusPaid, OrderStatusClosed},     // 待付款 -> 待发货/已关闭
	OrderStatusPaid:      {OrderStatusShipped, OrderStatusClosed},  // 待发货 -> 待收货/已关闭
	OrderStatusShipped:   {OrderStatusCompleted, OrderStatusClosed}, // 待收货 -> 已完成/已关闭
	OrderStatusCompleted: {},                                       // 已完成（终态）
	OrderStatusClosed:    {},                                       // 已关闭（终态）
}

type OrderInfoService struct{}

var OrderInfoServiceApp = new(OrderInfoService)

func (s *OrderInfoService) CreateOrderInfo(order mallModel.OrderInfo) (err error) {
	err = global.GVA_DB.Create(&order).Error
	return err
}

func (s *OrderInfoService) CreateOrder(order mallModel.OrderInfo, items []mallModel.OrderItem) error {
	return global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		// Generate order number using Snowflake
		order.OrderNo = utils.GenerateOrderNo()
		order.DelFlag = "0"

		// Create order
		if err := tx.Create(&order).Error; err != nil {
			return err
		}

		// Create order items
		for i := range items {
			items[i].OrderId = order.Id
			items[i].DelFlag = "0"
			if err := tx.Create(&items[i]).Error; err != nil {
				return err
			}
		}

		return nil
	})
}

func (s *OrderInfoService) DeleteOrderInfo(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *OrderInfoService) DeleteOrderInfoByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *OrderInfoService) UpdateOrderInfo(order mallModel.OrderInfo) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id = ?", order.Id).Updates(&order).Error
	return err
}

func (s *OrderInfoService) GetOrderInfo(id string) (order mallModel.OrderInfo, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").Preload("OrderItems").First(&order).Error
	if err != nil {
		return
	}
	// 加载物流信息
	var logistics mallModel.OrderLogistics
	if err2 := global.GVA_DB.Where("id = ?", order.LogisticsId).First(&logistics).Error; err2 == nil {
		order.Logistics = &logistics
	}
	return
}

func (s *OrderInfoService) GetOrderInfoList(info request.PageInfo, userId string, status string, orderNo string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("del_flag = ?", "0")
	if userId != "" {
		db = db.Where("user_id = ?", userId)
	}
	if status != "" {
		db = db.Where("status = ?", status)
	}
	if orderNo != "" {
		db = db.Where("order_no LIKE ?", "%"+orderNo+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var orderList []mallModel.OrderInfo
	err = db.Limit(limit).Offset(offset).Preload("OrderItems").Order("create_time DESC").Find(&orderList).Error
	return orderList, total, err
}

func (s *OrderInfoService) UpdateOrderStatus(id string, newStatus string) error {
	var order mallModel.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&order).Error; err != nil {
		return err
	}

	currentStatus := OrderStatusUnpaid
	if order.Status != nil {
		currentStatus = *order.Status
	}

	allowed, ok := validTransitions[currentStatus]
	if !ok {
		return fmt.Errorf("当前状态[%s]不允许状态变更", currentStatus)
	}

	valid := false
	for _, s := range allowed {
		if s == newStatus {
			valid = true
			break
		}
	}
	if !valid {
		return fmt.Errorf("不允许从[%s]变更为[%s]", currentStatus, newStatus)
	}

	if err := global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id = ?", id).Update("status", newStatus).Error; err != nil {
		return err
	}

	// If status is paid, update is_pay
	if newStatus == OrderStatusPaid {
		now := time.Now()
		global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id = ?", id).Updates(map[string]interface{}{
			"is_pay":       "1",
			"payment_time": &now,
		})
	}

	return nil
}

func (s *OrderInfoService) CancelOrder(id string) error {
	var order mallModel.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&order).Error; err != nil {
		return err
	}

	currentStatus := OrderStatusUnpaid
	if order.Status != nil {
		currentStatus = *order.Status
	}
	if currentStatus != OrderStatusUnpaid {
		return errors.New("只有未支付的订单可以取消")
	}

	now := time.Now()
	return global.GVA_DB.Model(&mallModel.OrderInfo{}).Where("id = ?", id).Updates(map[string]interface{}{
		"status":       OrderStatusClosed,
		"closing_time": &now,
	}).Error
}

// RefundOrder 订单退款
func (s *OrderInfoService) RefundOrder(id string, refundFee float64, refundDesc string) error {
	var order mallModel.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&order).Error; err != nil {
		return err
	}

	// 只有已支付订单能退款
	if order.IsPay != "1" {
		return errors.New("订单未支付")
	}

	// 更新订单状态为已关闭（退款）
	status := OrderStatusClosed
	return global.GVA_DB.Model(&order).Updates(map[string]interface{}{
		"status":    &status,
		"is_refund": "1",
	}).Error
}

// ShipOrder 订单发货
func (s *OrderInfoService) ShipOrder(id string, logistics string, logisticsNo string) error {
	var order mallModel.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&order).Error; err != nil {
		return err
	}

	// 只有待发货订单能发货
	currentStatus := OrderStatusPaid
	if order.Status != nil {
		currentStatus = *order.Status
	}
	if currentStatus != OrderStatusPaid {
		return errors.New("订单状态不正确，无法发货")
	}

	// 创建物流记录
	logisticsId := utils.GenerateSnowflakeId()
	now := time.Now()
	logisticsRecord := mallModel.OrderLogistics{
		Id:          logisticsId,
		DelFlag:     "0",
		Logistics:   &logistics,
		LogisticsNo: &logisticsNo,
		Status:      strPtr("0"), // 运输中
	}
	if err := global.GVA_DB.Create(&logisticsRecord).Error; err != nil {
		return err
	}

	// 更新订单状态为待收货
	status := OrderStatusShipped
	return global.GVA_DB.Model(&order).Updates(map[string]interface{}{
		"status":       &status,
		"logistics_id": &logisticsId,
		"delivery_time": &now,
	}).Error
}

func strPtr(s string) *string {
	return &s
}
