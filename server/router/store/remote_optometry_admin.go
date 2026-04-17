package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type RemoteOptometryAdminRouter struct{}

func (r *RemoteOptometryAdminRouter) InitRemoteOptometryAdminRouter(Router *gin.RouterGroup) {
	remoteOptometryRouter := Router.Group("remoteOptometry").Use(middleware.OperationRecord())
	remoteOptometryApi := v1.ApiGroupApp.StoreApiGroup.RemoteOptometryAdminApi
	{
		// 获取远程验光实时状态列表
		remoteOptometryRouter.GET("statusList", remoteOptometryApi.GetRemoteOptometryStatusList)
		// 获取远程验光日志列表
		remoteOptometryRouter.GET("logList", remoteOptometryApi.GetRemoteOptometryLogList)
		// 获取远程验光会话详情
		remoteOptometryRouter.GET("detail", remoteOptometryApi.GetRemoteOptometryDetail)
		// 获取牛头设备状态
		remoteOptometryRouter.GET("deviceStatus", remoteOptometryApi.GetNiuTouDeviceStatus)
		// 获取牛头设备列表（带远控状态）
		remoteOptometryRouter.GET("deviceList", remoteOptometryApi.GetNiuTouDeviceList)
	}
}
