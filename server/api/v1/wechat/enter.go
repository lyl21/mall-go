package wechat

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	WxUserApi
	WxMsgApi
	WxMenuApi
	WxAutoReplyApi
	WxMiniApi
	MiniMallApi
	MiniCartApi
	MiniAddressApi
	MiniOrderApi
	MiniPayApi
	MiniRemoteApi
	MiniAgoraApi
}

var (
	wxUserService      = service.ServiceGroupApp.WechatServiceGroup.WxUserService
	wxMsgService       = service.ServiceGroupApp.WechatServiceGroup.WxMsgService
	wxMenuService      = service.ServiceGroupApp.WechatServiceGroup.WxMenuService
	wxAutoReplyService = service.ServiceGroupApp.WechatServiceGroup.WxAutoReplyService
	wxMiniService      = service.ServiceGroupApp.WechatServiceGroup.WxMiniService
)
