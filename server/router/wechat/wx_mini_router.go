package wechat

import (
	"github.com/gin-gonic/gin"
)

type WxMiniRouter struct{}

// InitWxMiniPublicRouter 注册小程序公开路由（不需要 JWT 认证）
func (r *WxMiniRouter) InitWxMiniPublicRouter(publicGroup *gin.RouterGroup) {
	miniGroup := publicGroup.Group("mini")
	{
		miniGroup.POST("login", wxMiniApi.MiniLogin)
	}

	// 小程序商城公开API
	maGroup := publicGroup.Group("weixin/api/ma")
	{
		// Banner
		maGroup.GET("banner/list", miniMallApi.GetBannerList)
		// 分类
		maGroup.GET("goodscategory/tree", miniMallApi.GetGoodsCategoryTree)
		// 商品
		maGroup.GET("goodsspu/page", miniMallApi.GetGoodsSpuPage)
		maGroup.GET("goodsspu/id", miniMallApi.GetGoodsSpuById)
		// 支付回调（公开）
		maGroup.POST("orderinfo/notify-order", miniPayApi.PayNotify)
		// 退款回调（公开）
		maGroup.POST("orderinfo/notify-refunds", miniPayApi.RefundNotify)
	}
}

// InitWxMiniRouter 注册小程序私有路由（需要 JWT 认证）
func (r *WxMiniRouter) InitWxMiniRouter(privateGroup *gin.RouterGroup) {
	miniGroup := privateGroup.Group("mini")
	{
		miniGroup.GET("myOptometryRecords", wxMiniApi.GetMyOptometryRecords)
		miniGroup.POST("bindPhone", wxMiniApi.BindPhone)
	}

	// 小程序商城私有API
	maGroup := privateGroup.Group("weixin/api/ma")
	{
		// 购物车
		maGroup.GET("shoppingcart/page", miniCartApi.GetCartPage)
		maGroup.GET("shoppingcart/count", miniCartApi.GetCartCount)
		maGroup.POST("shoppingcart", miniCartApi.AddCart)
		maGroup.PUT("shoppingcart", miniCartApi.UpdateCart)
		maGroup.POST("shoppingcart/del", miniCartApi.DeleteCart)
		// 地址
		maGroup.GET("useraddress/page", miniAddressApi.GetAddressPage)
		maGroup.POST("useraddress", miniAddressApi.AddAddress)
		maGroup.PUT("useraddress", miniAddressApi.UpdateAddress)
		maGroup.DELETE("useraddress/:id", miniAddressApi.DeleteAddress)
		// 订单
		maGroup.GET("orderinfo/page", miniOrderApi.GetOrderPage)
		maGroup.GET("orderinfo/:id", miniOrderApi.GetOrderById)
		maGroup.POST("orderinfo", miniOrderApi.CreateOrder)
		maGroup.PUT("orderinfo/cancel/:id", miniOrderApi.CancelOrder)
		maGroup.PUT("orderinfo/receive/:id", miniOrderApi.ReceiveOrder)
		// 支付
		maGroup.POST("orderinfo/unifiedOrder", miniPayApi.UnifiedOrder)
		maGroup.POST("orderinfo/refunds", miniPayApi.Refund)
		// 远程控制
		maGroup.POST("remote/control", miniRemoteApi.RemoteControl)
		maGroup.GET("remote/online-users", miniRemoteApi.GetOnlineUsers)
		maGroup.POST("remote/door/open", miniRemoteApi.RemoteDoorOpen)
		// 远程验光
		maGroup.POST("remote/token", miniRemoteApi.GetRemoteOptometryToken)
		maGroup.GET("remote/ws-url", miniRemoteApi.GetRemoteOptometryWsUrl)
		maGroup.GET("remote/session-info", miniRemoteApi.GetRemoteOptometrySessionInfo)
		maGroup.GET("remote/health", miniRemoteApi.GetRemoteOptometryHealth)
		maGroup.GET("remote/stats", miniRemoteApi.GetRemoteOptometryStats)
		// 音视频
		maGroup.POST("agora/token", miniAgoraApi.GetAgoraToken)
		maGroup.POST("agora/join", miniAgoraApi.JoinRoom)
		maGroup.POST("agora/leave", miniAgoraApi.LeaveRoom)
		maGroup.GET("agora/room", miniAgoraApi.GetRoomInfo)
		maGroup.GET("agora/rooms", miniAgoraApi.GetRoomList)
	}
}
