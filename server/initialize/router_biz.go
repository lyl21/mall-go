package initialize

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/flipped-aurora/gin-vue-admin/server/router"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/flipped-aurora/gin-vue-admin/server/utils/ws"
	"github.com/flipped-aurora/gin-vue-admin/server/wsmanager"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
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

	// 初始化新版WebSocket管理器（支持完整远控流程）
	wsmanager.WSManager = ws.NewManager()
	wsmanager.WSManager.StartHeartbeatCheck()
	wsmanager.WSManager.StartSessionCleanup()

	// 注册设备WebSocket路由
	publicGroup.GET("/ws/device", func(c *gin.Context) {
		utils.DeviceWSManager.HandleDeviceWS(c.Writer, c.Request)
	})

	// 注册用户WebSocket路由（旧版，需要客户端发送JSON消息）- 使用新版Manager
	publicGroup.GET("/ws/user", func(c *gin.Context) {
		// 读取第一条消息获取用户信息（userId, userType, storeId）
		utils.UserWSManager.HandleUserWS(c.Writer, c.Request)
	})

	// 注册用户WebSocket路由（新版，从URL路径获取userId，自动查库获取门店信息）- 使用新版Manager
	publicGroup.GET("/ws/user/:userId", func(c *gin.Context) {
		userIdStr := c.Param("userId")

		// 自动从数据库查询用户门店信息
		userId, err := strconv.ParseInt(userIdStr, 10, 64)
		if err != nil {
			global.GVA_LOG.Error("解析userID失败", zap.String("userID", userIdStr), zap.Error(err))
			c.JSON(400, gin.H{"error": "invalid userId"})
			return
		}

		var storeId string
		var userType string

		var member storeModel.MxStoreMember
		if err := global.GVA_DB.Where("user_id = ? AND is_delete = ?", userId, 0).First(&member).Error; err == nil {
			storeId = strconv.FormatInt(member.StoreId, 10)
			switch member.Post {
			case 1:
				userType = "manager"
			case 2:
				userType = "optometrist"
			case 3:
				userType = "customer"
			default:
				userType = "customer"
			}
		} else {
			// 未找到门店成员记录，默认顾客
			userType = "customer"
			storeId = ""
			global.GVA_LOG.Warn("WebSocket连接用户未找到门店成员记录",
				zap.Int64("userId", userId),
				zap.Error(err))
		}

		wsmanager.WSManager.HandleWebSocketWithStrIDAndInfo(c.Writer, c.Request, userIdStr, userType, storeId)
	})

	// 初始化音视频WebSocket管理器
	utils.InitAgoraWSManager()

	// 注册音视频WebSocket路由
	publicGroup.GET("/ws/agora", func(c *gin.Context) {
		utils.AgoraWSManager.HandleAgoraWS(c.Writer, c.Request)
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
