package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type StoreMemberRouter struct{}

func (s *StoreMemberRouter) InitMxStoreMemberRouter(Router *gin.RouterGroup) {
	memberRouter := Router.Group("store").Use(middleware.OperationRecord())
	memberRouterWithoutRecord := Router.Group("store")
	{
		memberRouter.POST("mxStoreMember", mxStoreMemberApi.CreateMxStoreMember)   // 添加门店成员
		memberRouter.PUT("mxStoreMember", mxStoreMemberApi.UpdateMxStoreMember)    // 更新门店成员
		memberRouter.DELETE("mxStoreMember", mxStoreMemberApi.DeleteMxStoreMember) // 删除门店成员
	}
	{
		memberRouterWithoutRecord.GET("mxStoreMember", mxStoreMemberApi.GetMxStoreMember)         // 获取门店成员
		memberRouterWithoutRecord.GET("mxStoreMemberList", mxStoreMemberApi.GetMxStoreMemberList) // 获取成员列表
	}
}
