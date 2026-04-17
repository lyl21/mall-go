package initialize

import (
	"github.com/flipped-aurora/gin-vue-admin/server/router"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
)

func holder(routers ...*gin.RouterGroup) {
	_ = routers
	_ = router.RouterGroupApp
}

func initBizRouter(routers ...*gin.RouterGroup) {
	privateGroup := routers[0]
	publicGroup := routers[1]

	holder(publicGroup, privateGroup)

	// 初始化设备WebSocket管理器
	utils.InitDeviceWSManager()

	// 初始化用户WebSocket管理器
	utils.InitUserWSManager()

	// 初始化订单超时管理器
	utils.InitOrderTimeoutManager()

	// 注册设备WebSocket路由
	publicGroup.GET("/ws/device", func(c *gin.Context) {
		utils.DeviceWSManager.HandleDeviceWS(c.Writer, c.Request)
	})

	// 注册用户WebSocket路由
	publicGroup.GET("/ws/user", func(c *gin.Context) {
		utils.UserWSManager.HandleUserWS(c.Writer, c.Request)
	})

	// 初始化音视频WebSocket管理器
	utils.InitAgoraWSManager()

	// 注册音视频WebSocket路由
	publicGroup.GET("/ws/agora", func(c *gin.Context) {
		utils.AgoraWSManager.HandleAgoraWS(c.Writer, c.Request)
	})

	// 初始化远程验光WebSocket管理器
	utils.InitRemoteOptometryManager()

	// 注册远程验光WebSocket路由
	publicGroup.GET("/ws/remote-optometry/:userId", func(c *gin.Context) {
		utils.RemoteOptometryManager.HandleRemoteOptometryWS(c.Writer, c.Request)
	})

	// 门店管理路由
	router.RouterGroupApp.Store.InitMxStoreRouter(privateGroup)
	router.RouterGroupApp.Store.InitMxStoreMemberRouter(privateGroup)
	router.RouterGroupApp.Store.InitMxUserRouter(privateGroup)
	router.RouterGroupApp.Store.InitMxUserFlowRouter(privateGroup)
	router.RouterGroupApp.Store.InitMxActivationCodeRouter(privateGroup)
	router.RouterGroupApp.Store.InitMxPictureRouter(privateGroup)
	router.RouterGroupApp.Store.InitInstallingPackageRouter(privateGroup)

	// 远程验光管理路由
	storeGroup := privateGroup.Group("store")
	router.RouterGroupApp.Store.InitRemoteOptometryAdminRouter(storeGroup)

	// 验光管理路由
	optometryGroup := privateGroup.Group("optometry")
	router.RouterGroupApp.Optometry.InitOptometryRecordRouter(optometryGroup)
	router.RouterGroupApp.Optometry.InitOptometryDataRouter(optometryGroup)
	router.RouterGroupApp.Optometry.InitVisionTestResultRouter(optometryGroup)
	router.RouterGroupApp.Optometry.InitTryOptometryRouter(optometryGroup)

	// 商城管理路由
	router.RouterGroupApp.Mall.InitGoodsCategoryRouter(privateGroup)
	router.RouterGroupApp.Mall.InitGoodsSpuRouter(privateGroup)
	router.RouterGroupApp.Mall.InitGoodsSpuBannerRouter(privateGroup)
	router.RouterGroupApp.Mall.InitSpuTryOnImgUrlRouter(privateGroup)
	router.RouterGroupApp.Mall.InitTryOnGlassImgUrlRouter(privateGroup)
	router.RouterGroupApp.Mall.InitOrderInfoRouter(privateGroup)
	router.RouterGroupApp.Mall.InitOrderItemRouter(privateGroup)
	router.RouterGroupApp.Mall.InitOrderLogisticsRouter(privateGroup)
	router.RouterGroupApp.Mall.InitDoorLockRouter(privateGroup)
	router.RouterGroupApp.Mall.InitDoorLockHistoryRouter(privateGroup)

	// 微信管理路由
	wechatGroup := privateGroup.Group("wechat")
	router.RouterGroupApp.Wechat.InitWxUserRouter(wechatGroup)
	router.RouterGroupApp.Wechat.InitWxMsgRouter(wechatGroup)
	router.RouterGroupApp.Wechat.InitWxMenuRouter(wechatGroup)
	router.RouterGroupApp.Wechat.InitWxAutoReplyRouter(wechatGroup)
	router.RouterGroupApp.Wechat.InitWxMiniRouter(wechatGroup)

	// 小程序公开路由（无需 JWT）
	router.RouterGroupApp.Wechat.InitWxMiniPublicRouter(publicGroup)

	// 客户端设备API（无需 JWT）
	router.RouterGroupApp.Client.InitClientPublicRouter(publicGroup)
}
