package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type OrderInfoRouter struct{}

func (r *OrderInfoRouter) InitOrderInfoRouter(Router *gin.RouterGroup) {
	orderRouter := Router.Group("mall").Use(middleware.OperationRecord())
	orderRouterWithoutRecord := Router.Group("mall")
	{
		orderRouter.POST("orderInfo", orderInfoApi.CreateOrder)            // 创建订单
		orderRouter.PUT("orderInfo", orderInfoApi.UpdateOrderInfo)         // 更新订单
		orderRouter.DELETE("orderInfo", orderInfoApi.DeleteOrderInfo)      // 删除订单
		orderRouter.PUT("orderStatus", orderInfoApi.UpdateOrderStatus)     // 更新订单状态
		orderRouter.PUT("cancelOrder", orderInfoApi.CancelOrder)           // 取消订单
		orderRouter.POST("refundOrder", orderInfoApi.RefundOrder)          // 订单退款
		orderRouter.POST("shipOrder", orderInfoApi.ShipOrder)              // 订单发货
	}
	{
		orderRouterWithoutRecord.GET("orderInfo", orderInfoApi.GetOrderInfo)         // 获取订单信息
		orderRouterWithoutRecord.GET("orderInfoList", orderInfoApi.GetOrderInfoList) // 获取订单列表
	}
}
