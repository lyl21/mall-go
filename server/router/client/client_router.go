package client

import (
	"github.com/gin-gonic/gin"
)

type ClientRouter struct{}

// InitClientPublicRouter 注册客户端公开路由（不需要 JWT 认证）
func (r *ClientRouter) InitClientPublicRouter(publicGroup *gin.RouterGroup) {
	clientGroup := publicGroup.Group("client")
	{
		// 设备管理
		codeGroup := clientGroup.Group("code")
		{
			codeGroup.GET("app", clientDeviceApi.GetAppVersion)
			codeGroup.GET("keyboard", clientDeviceApi.GetKeyboardVersion)
			codeGroup.GET("app/optometer", clientDeviceApi.GetOptometerVersion)
			codeGroup.GET("app/optometer/manual", clientDeviceApi.GetOptometerManualVersion)
			codeGroup.POST("equipment", clientDeviceApi.RegisterDevice)
			codeGroup.POST("upload", clientDeviceApi.UploadErrorLog)
		}
	}
}
