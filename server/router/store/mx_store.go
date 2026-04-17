package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type StoreRouter struct{}

func (s *StoreRouter) InitMxStoreRouter(Router *gin.RouterGroup) {
	storeRouter := Router.Group("store").Use(middleware.OperationRecord())
	storeRouterWithoutRecord := Router.Group("store")
	{
		storeRouter.POST("mxStore", mxStoreApi.CreateMxStore)   // 创建门店
		storeRouter.PUT("mxStore", mxStoreApi.UpdateMxStore)    // 更新门店
		storeRouter.DELETE("mxStore", mxStoreApi.DeleteMxStore) // 删除门店
	}
	{
		storeRouterWithoutRecord.GET("mxStore", mxStoreApi.GetMxStore)         // 获取门店信息
		storeRouterWithoutRecord.GET("mxStoreList", mxStoreApi.GetMxStoreList) // 获取门店列表
	}
}
