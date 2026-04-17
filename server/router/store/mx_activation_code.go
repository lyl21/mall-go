package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type ActivationCodeRouter struct{}

func (a *ActivationCodeRouter) InitMxActivationCodeRouter(Router *gin.RouterGroup) {
	codeRouter := Router.Group("store").Use(middleware.OperationRecord())
	codeRouterWithoutRecord := Router.Group("store")
	{
		codeRouter.POST("mxActivationCode", mxActivationCodeApi.CreateMxActivationCode)   // 创建激活码
		codeRouter.PUT("mxActivationCode", mxActivationCodeApi.UpdateMxActivationCode)    // 更新激活码
		codeRouter.DELETE("mxActivationCode", mxActivationCodeApi.DeleteMxActivationCode) // 删除激活码
		codeRouter.POST("mxActivationCode/generate", mxActivationCodeApi.GenerateActivationCode) // 生成激活码
	}
	{
		codeRouterWithoutRecord.GET("mxActivationCode", mxActivationCodeApi.GetMxActivationCode)         // 获取激活码
		codeRouterWithoutRecord.GET("mxActivationCodeList", mxActivationCodeApi.GetMxActivationCodeList) // 获取激活码列表
	}
}
