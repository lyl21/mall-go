package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type UserRouter struct{}

func (u *UserRouter) InitMxUserRouter(Router *gin.RouterGroup) {
	userRouter := Router.Group("store").Use(middleware.OperationRecord())
	userRouterWithoutRecord := Router.Group("store")
	{
		userRouter.POST("mxUser", mxUserApi.CreateMxUser)   // 创建用户
		userRouter.PUT("mxUser", mxUserApi.UpdateMxUser)    // 更新用户
		userRouter.DELETE("mxUser", mxUserApi.DeleteMxUser) // 删除用户
	}
	{
		userRouterWithoutRecord.GET("mxUser", mxUserApi.GetMxUser)         // 获取用户信息
		userRouterWithoutRecord.GET("mxUserList", mxUserApi.GetMxUserList) // 获取用户列表
	}
}
