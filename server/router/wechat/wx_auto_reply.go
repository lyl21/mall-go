package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type WxAutoReplyRouter struct{}

func (r *WxAutoReplyRouter) InitWxAutoReplyRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.POST("createWxAutoReply", wxAutoReplyApi.CreateWxAutoReply)
		withRecord.PUT("updateWxAutoReply", wxAutoReplyApi.UpdateWxAutoReply)
		withRecord.DELETE("deleteWxAutoReply", wxAutoReplyApi.DeleteWxAutoReply)
	}
	{
		noRecord.POST("getWxAutoReplyList", wxAutoReplyApi.GetWxAutoReplyList)
		noRecord.GET("getWxAutoReply", wxAutoReplyApi.GetWxAutoReply)
	}
}
