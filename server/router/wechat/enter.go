package wechat

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	WxUserRouter
	WxMsgRouter
	WxMenuRouter
	WxAutoReplyRouter
	WxMiniRouter
}

var (
	wxUserApi       = api.ApiGroupApp.WechatApiGroup.WxUserApi
	wxMsgApi        = api.ApiGroupApp.WechatApiGroup.WxMsgApi
	wxMenuApi       = api.ApiGroupApp.WechatApiGroup.WxMenuApi
	wxAutoReplyApi  = api.ApiGroupApp.WechatApiGroup.WxAutoReplyApi
	wxMiniApi       = api.ApiGroupApp.WechatApiGroup.WxMiniApi
	miniMallApi     = api.ApiGroupApp.WechatApiGroup.MiniMallApi
	miniCartApi     = api.ApiGroupApp.WechatApiGroup.MiniCartApi
	miniAddressApi  = api.ApiGroupApp.WechatApiGroup.MiniAddressApi
	miniOrderApi    = api.ApiGroupApp.WechatApiGroup.MiniOrderApi
	miniPayApi      = api.ApiGroupApp.WechatApiGroup.MiniPayApi
	miniRemoteApi   = api.ApiGroupApp.WechatApiGroup.MiniRemoteApi
	miniAgoraApi    = api.ApiGroupApp.WechatApiGroup.MiniAgoraApi
)
