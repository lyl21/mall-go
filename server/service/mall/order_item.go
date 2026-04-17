package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type OrderItemService struct{}

var OrderItemServiceApp = new(OrderItemService)

func (s *OrderItemService) CreateOrderItem(item mallModel.OrderItem) (err error) {
	err = global.GVA_DB.Create(&item).Error
	return err
}

func (s *OrderItemService) DeleteOrderItem(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderItem{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *OrderItemService) UpdateOrderItem(item mallModel.OrderItem) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderItem{}).Where("id = ?", item.Id).Updates(&item).Error
	return err
}

func (s *OrderItemService) GetOrderItem(id string) (item mallModel.OrderItem, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&item).Error
	return
}

func (s *OrderItemService) GetOrderItemList(info request.PageInfo, orderId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.OrderItem{}).Where("del_flag = ?", "0")
	if orderId != "" {
		db = db.Where("order_id = ?", orderId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var itemList []mallModel.OrderItem
	err = db.Limit(limit).Offset(offset).Find(&itemList).Error
	return itemList, total, err
}
