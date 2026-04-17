package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type WxUserRouter struct{}

func (r *WxUserRouter) InitWxUserRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.PUT("updateWxUser", wxUserApi.UpdateWxUser)
		withRecord.DELETE("deleteWxUser", wxUserApi.DeleteWxUser)
	}
	{
		noRecord.POST("getWxUserList", wxUserApi.GetWxUserList)
		noRecord.GET("getWxUser", wxUserApi.GetWxUser)
	}
}
