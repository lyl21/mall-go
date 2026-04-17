package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type DoorLockHistoryRouter struct{}

func (r *DoorLockHistoryRouter) InitDoorLockHistoryRouter(Router *gin.RouterGroup) {
	historyRouter := Router.Group("mall").Use(middleware.OperationRecord())
	historyRouterWithoutRecord := Router.Group("mall")
	{
		historyRouter.POST("doorLockHistory", doorLockHistoryApi.CreateDoorLockHistory)   // 创建门锁操作历史
		historyRouter.PUT("doorLockHistory", doorLockHistoryApi.UpdateDoorLockHistory)    // 更新门锁操作历史
		historyRouter.DELETE("doorLockHistory", doorLockHistoryApi.DeleteDoorLockHistory) // 删除门锁操作历史
	}
	{
		historyRouterWithoutRecord.GET("doorLockHistory", doorLockHistoryApi.GetDoorLockHistory)         // 获取门锁操作历史信息
		historyRouterWithoutRecord.GET("doorLockHistoryList", doorLockHistoryApi.GetDoorLockHistoryList) // 获取门锁操作历史列表
	}
}
