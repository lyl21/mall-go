package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type WxMsgRouter struct{}

func (r *WxMsgRouter) InitWxMsgRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.DELETE("deleteWxMsg", wxMsgApi.DeleteWxMsg)
	}
	{
		noRecord.POST("getWxMsgList", wxMsgApi.GetWxMsgList)
		noRecord.GET("getWxMsg", wxMsgApi.GetWxMsg)
	}
}
