package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type OrderItemRouter struct{}

func (r *OrderItemRouter) InitOrderItemRouter(Router *gin.RouterGroup) {
	itemRouter := Router.Group("mall").Use(middleware.OperationRecord())
	itemRouterWithoutRecord := Router.Group("mall")
	{
		itemRouter.POST("orderItem", orderItemApi.CreateOrderItem)   // 创建订单项
		itemRouter.PUT("orderItem", orderItemApi.UpdateOrderItem)    // 更新订单项
		itemRouter.DELETE("orderItem", orderItemApi.DeleteOrderItem) // 删除订单项
	}
	{
		itemRouterWithoutRecord.GET("orderItem", orderItemApi.GetOrderItem)         // 获取订单项信息
		itemRouterWithoutRecord.GET("orderItemList", orderItemApi.GetOrderItemList) // 获取订单项列表
	}
}
