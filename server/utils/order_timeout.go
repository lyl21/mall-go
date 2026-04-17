package utils

import (
	"context"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

const (
	// OrderTimeoutKeyPrefix Redis key前缀
	OrderTimeoutKeyPrefix = "order:timeout:"
	// OrderTimeoutDuration 订单超时时间（30分钟）
	OrderTimeoutDuration = 30 * time.Minute
)

// OrderTimeoutManager 订单超时管理器
type OrderTimeoutManager struct {
	ctx    context.Context
	cancel context.CancelFunc
}

var (
	orderTimeoutMgr *OrderTimeoutManager
)

// InitOrderTimeoutManager 初始化订单超时管理器
func InitOrderTimeoutManager() {
	ctx, cancel := context.WithCancel(context.Background())
	orderTimeoutMgr = &OrderTimeoutManager{
		ctx:    ctx,
		cancel: cancel,
	}
	// 启动监听
	go orderTimeoutMgr.startListener()
}

// SetOrderTimeout 设置订单超时
func SetOrderTimeout(orderId string, orderNo string) error {
	if global.GVA_REDIS == nil {
		return nil // Redis未初始化，直接返回
	}
	key := OrderTimeoutKeyPrefix + orderId
	// 存储订单号，30分钟后过期
	return global.GVA_REDIS.Set(orderTimeoutMgr.ctx, key, orderNo, OrderTimeoutDuration).Err()
}

// CancelOrderTimeout 取消订单超时
func CancelOrderTimeout(orderId string) error {
	if global.GVA_REDIS == nil {
		return nil // Redis未初始化，直接返回
	}
	key := OrderTimeoutKeyPrefix + orderId
	return global.GVA_REDIS.Del(orderTimeoutMgr.ctx, key).Err()
}

// startListener 启动Redis过期监听
func (m *OrderTimeoutManager) startListener() {
	// 使用定时轮询检查过期订单
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-m.ctx.Done():
			return
		case <-ticker.C:
			m.checkAndCancelTimeoutOrders()
		}
	}
}

// checkAndCancelTimeoutOrders 检查并取消超时订单
func (m *OrderTimeoutManager) checkAndCancelTimeoutOrders() {
	// 检查Redis是否可用
	if global.GVA_REDIS == nil {
		global.GVA_LOG.Warn("Redis未初始化，跳过订单超时检查")
		return
	}

	// 查询所有未支付且创建时间超过30分钟的订单
	deadline := time.Now().Add(-OrderTimeoutDuration)

	var orders []mall.OrderInfo
	err := global.GVA_DB.Where("is_pay = ? AND del_flag = ? AND create_time < ?", "0", "0", deadline).Find(&orders).Error
	if err != nil {
		global.GVA_LOG.Error("查询超时订单失败", zap.Error(err))
		return
	}

	for _, order := range orders {
		// 检查Redis中是否还有超时标记（防止重复处理）
		key := OrderTimeoutKeyPrefix + order.Id
		exists, err := global.GVA_REDIS.Exists(m.ctx, key).Result()
		if err != nil {
			global.GVA_LOG.Error("检查Redis订单超时标记失败", zap.Error(err))
			continue
		}

		// 如果Redis中没有标记，说明已经处理过或不是通过本系统创建的订单
		if exists == 0 {
			continue
		}

		// 取消订单
		if err := cancelOrder(&order); err != nil {
			global.GVA_LOG.Error("自动取消超时订单失败",
				zap.String("orderId", order.Id),
				zap.Error(err))
			continue
		}

		// 删除Redis标记
		global.GVA_REDIS.Del(m.ctx, key)

		global.GVA_LOG.Info("自动取消超时订单成功",
			zap.String("orderId", order.Id),
			zap.String("orderNo", order.OrderNo))
	}
}

// cancelOrder 取消订单（恢复库存）
func cancelOrder(order *mall.OrderInfo) error {
	tx := global.GVA_DB.Begin()

	// 查询订单商品
	var orderItems []mall.OrderItem
	if err := tx.Where("order_id = ?", order.Id).Find(&orderItems).Error; err != nil {
		tx.Rollback()
		return err
	}

	// 恢复库存
	for _, item := range orderItems {
		if err := tx.Model(&mall.GoodsSpu{}).Where("id = ?", item.SpuId).UpdateColumn("stock", gorm.Expr("stock + ?", item.Quantity)).Error; err != nil {
			tx.Rollback()
			return err
		}
	}

	// 更新订单状态为已关闭
	status := "5"
	if err := tx.Model(order).Updates(map[string]interface{}{
		"status": &status,
	}).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

// OrderTimeoutInfo 订单超时信息
type OrderTimeoutInfo struct {
	OrderId   string    `json:"orderId"`
	OrderNo   string    `json:"orderNo"`
	ExpireAt  time.Time `json:"expireAt"`
}

// GetOrderTimeoutInfo 获取订单超时信息
func GetOrderTimeoutInfo(orderId string) (*OrderTimeoutInfo, error) {
	if global.GVA_REDIS == nil {
		return nil, nil // Redis未初始化，直接返回
	}
	key := OrderTimeoutKeyPrefix + orderId
	ttl, err := global.GVA_REDIS.TTL(orderTimeoutMgr.ctx, key).Result()
	if err != nil {
		return nil, err
	}

	if ttl < 0 {
		return nil, nil // 不存在或已过期
	}

	orderNo, err := global.GVA_REDIS.Get(orderTimeoutMgr.ctx, key).Result()
	if err != nil {
		return nil, err
	}

	return &OrderTimeoutInfo{
		OrderId:  orderId,
		OrderNo:  orderNo,
		ExpireAt: time.Now().Add(ttl),
	}, nil
}
