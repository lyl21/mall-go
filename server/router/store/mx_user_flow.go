package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type UserFlowRouter struct{}

func (u *UserFlowRouter) InitMxUserFlowRouter(Router *gin.RouterGroup) {
	flowRouter := Router.Group("store").Use(middleware.OperationRecord())
	flowRouterWithoutRecord := Router.Group("store")
	{
		flowRouter.POST("mxUserFlow", mxUserFlowApi.CreateMxUserFlow)   // 创建用户流程
		flowRouter.PUT("mxUserFlow", mxUserFlowApi.UpdateMxUserFlow)    // 更新用户流程
		flowRouter.DELETE("mxUserFlow", mxUserFlowApi.DeleteMxUserFlow) // 删除用户流程
		flowRouter.POST("mxUserFlow/upsert", mxUserFlowApi.UpsertMxUserFlow) // 创建或更新用户流程
	}
	{
		flowRouterWithoutRecord.GET("mxUserFlow", mxUserFlowApi.GetMxUserFlow)         // 获取用户流程
		flowRouterWithoutRecord.GET("mxUserFlowList", mxUserFlowApi.GetMxUserFlowList) // 获取流程列表
	}
}
