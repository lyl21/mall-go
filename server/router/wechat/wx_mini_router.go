package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type WxMiniRouter struct{}

// InitWxMiniPublicRouter 注册小程序公开路由（不需要 JWT 认证）
func (r *WxMiniRouter) InitWxMiniPublicRouter(publicGroup *gin.RouterGroup) {
	// 小程序商城公开API
	maGroup := publicGroup.Group("mini")
	{
		// 用户登录（公开）
		maGroup.POST("login", miniWxUserApi.WxUserLogin)
		// 手机号获取（公开）
		maGroup.GET("phone", wxPhoneApi.GetPhone)
		// Banner
		maGroup.GET("banner/list", miniMallApi.GetBannerList)
		// 分类
		maGroup.GET("goodscategory/tree", miniMallApi.GetGoodsCategoryTree)
		// 商品
		maGroup.GET("goodsspu/page", miniMallApi.GetGoodsSpuPage)
		maGroup.GET("goodsspu/id", miniMallApi.GetGoodsSpuById)
		// 验光记录（公开）
		maGroup.GET("optometry/list", miniOptometryApi.GetOptometryListByOpenid)
		maGroup.GET("optometry/:optometryRecordsId", miniOptometryApi.GetOptometryDetail)
		maGroup.GET("optometry/data/list", miniOptometryApi.GetOptometryDataList)
		maGroup.GET("optometry/data/t2", miniOptometryApi.GetOptometryHead)
		maGroup.GET("optometry/data/t3", miniOptometryApi.GetOptometryFinal)
		maGroup.GET("optometry/vision", miniOptometryApi.GetOptometryByRecordsId)
		// 支付回调（公开）
		maGroup.POST("orderinfo/notify-order", miniPayApi.PayNotify)
		// 退款回调（公开）
		maGroup.POST("orderinfo/notify-refunds", miniPayApi.RefundNotify)
	}
}

// InitWxMiniRouter 注册小程序私有路由（需要小程序 JWT 认证）
func (r *WxMiniRouter) InitWxMiniRouter(publicGroup *gin.RouterGroup) {
	// 小程序私有API（需 JWT）
	maGroup := publicGroup.Group("mini").Use(middleware.MiniJWTAuth())
	{
		// 用户信息
		maGroup.GET("wxuser", miniWxUserApi.WxUserGet)
		maGroup.POST("wxuser", miniWxUserApi.WxUserSave)
		maGroup.POST("wxuser/logout", miniWxUserApi.WxUserLogout)
		// 绑定手机号
		maGroup.POST("bindPhone", wxMiniApi.BindPhone)
		// 我的验光记录
		maGroup.GET("myOptometryRecords", wxMiniApi.GetMyOptometryRecords)
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
		maGroup.GET("orderinfo/countAll", miniOrderApi.OrderCountAll)
		maGroup.GET("orderinfo/page", miniOrderApi.GetOrderPage)
		maGroup.GET("orderinfo/:id", miniOrderApi.GetOrderById)
		maGroup.POST("orderinfo", miniOrderApi.CreateOrder)
		maGroup.PUT("orderinfo/cancel/:id", miniOrderApi.CancelOrder)
		maGroup.PUT("orderinfo/receive/:id", miniOrderApi.ReceiveOrder)
		maGroup.DELETE("orderinfo/:id", miniOrderApi.DeleteOrder)
		// 支付
		maGroup.POST("orderinfo/unifiedOrder", miniPayApi.UnifiedOrder)
		maGroup.POST("orderinfo/refunds", miniPayApi.Refund)
		// 远程控制/开门
		maGroup.POST("remote/door/open", miniRemoteApi.RemoteDoorOpen)
		maGroup.POST("remote/control", miniRemoteApi.RemoteControl)
		maGroup.GET("remote/online-users", miniRemoteApi.GetOnlineUsers)
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
