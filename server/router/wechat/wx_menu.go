package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type WxMenuRouter struct{}

func (r *WxMenuRouter) InitWxMenuRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.POST("createWxMenu", wxMenuApi.CreateWxMenu)
		withRecord.PUT("updateWxMenu", wxMenuApi.UpdateWxMenu)
		withRecord.DELETE("deleteWxMenu", wxMenuApi.DeleteWxMenu)
	}
	{
		noRecord.POST("getWxMenuList", wxMenuApi.GetWxMenuList)
		noRecord.GET("getWxMenu", wxMenuApi.GetWxMenu)
		noRecord.GET("getWxMenuTree", wxMenuApi.GetWxMenuTree)
	}
}
