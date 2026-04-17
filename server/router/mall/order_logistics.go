package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type OrderLogisticsRouter struct{}

func (r *OrderLogisticsRouter) InitOrderLogisticsRouter(Router *gin.RouterGroup) {
	logisticsRouter := Router.Group("mall").Use(middleware.OperationRecord())
	logisticsRouterWithoutRecord := Router.Group("mall")
	{
		logisticsRouter.POST("orderLogistics", orderLogisticsApi.CreateOrderLogistics)   // 创建订单物流
		logisticsRouter.PUT("orderLogistics", orderLogisticsApi.UpdateOrderLogistics)    // 更新订单物流
		logisticsRouter.DELETE("orderLogistics", orderLogisticsApi.DeleteOrderLogistics) // 删除订单物流
	}
	{
		logisticsRouterWithoutRecord.GET("orderLogistics", orderLogisticsApi.GetOrderLogistics)         // 获取订单物流信息
		logisticsRouterWithoutRecord.GET("orderLogisticsList", orderLogisticsApi.GetOrderLogisticsList) // 获取订单物流列表
	}
}
