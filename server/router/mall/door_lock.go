package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type DoorLockRouter struct{}

func (r *DoorLockRouter) InitDoorLockRouter(Router *gin.RouterGroup) {
	lockRouter := Router.Group("mall").Use(middleware.OperationRecord())
	lockRouterWithoutRecord := Router.Group("mall")
	{
		lockRouter.POST("doorLock", doorLockApi.CreateDoorLock)       // 创建门锁
		lockRouter.PUT("doorLock", doorLockApi.UpdateDoorLock)        // 更新门锁
		lockRouter.DELETE("doorLock", doorLockApi.DeleteDoorLock)     // 删除门锁
		lockRouter.POST("doorLock/open", doorLockApi.OpenDoor)        // 远程开门
	}
	{
		lockRouterWithoutRecord.GET("doorLock", doorLockApi.GetDoorLock)         // 获取门锁信息
		lockRouterWithoutRecord.GET("doorLockList", doorLockApi.GetDoorLockList) // 获取门锁列表
	}
}
