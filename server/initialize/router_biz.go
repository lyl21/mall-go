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

	// 注册设备WebSocket路由,后台用
	publicGroup.GET("/ws/device", func(c *gin.Context) {
		// TODO: 增加后台管理 JWT 认证，防止未授权访问
		utils.DeviceWSManager.HandleDeviceWS(c.Writer, c.Request)
	})

	// 验光仪设备WebSocket: ws://IP:PORT/equipment/设备ID
	publicGroup.GET("/equipment/:equipmentId", func(c *gin.Context) {
		equipmentId := c.Param("equipmentId")
		// TODO: 增加设备认证（如设备密钥），防止未授权设备连接
		utils.DeviceWSManager.HandleDeviceWSByPath(c.Writer, c.Request, equipmentId, "验光仪")
	})

	// 牛头APP WebSocket（远控通信 + 设备在线状态同步）
	// 注意：此路由在 publicGroup 中，需要通过 query 参数 token 进行身份校验
	publicGroup.GET("/ws/user/:userId", func(c *gin.Context) {
		userIdStr := c.Param("userId")

		// 从 query 参数获取 token 进行身份校验
		tokenStr := c.Query("token")
		if tokenStr == "" {
			global.GVA_LOG.Warn("WebSocket连接缺少token参数", zap.String("userID", userIdStr))
			c.JSON(401, gin.H{"error": "missing token"})
			return
		}

		// 校验 token 有效性
		valid, claims := utils.ValidateClientToken(tokenStr)
		if !valid || claims == nil {
			global.GVA_LOG.Warn("WebSocket连接token无效", zap.String("userID", userIdStr))
			c.JSON(401, gin.H{"error": "invalid token"})
			return
		}

		// 校验 URL 中的 userId 与 token 中的 userId 一致
		if strconv.FormatInt(claims.UserId, 10) != userIdStr {
			global.GVA_LOG.Warn("WebSocket连接userId与token不匹配",
				zap.String("urlUserId", userIdStr),
				zap.Int64("tokenUserId", claims.UserId))
			c.JSON(403, gin.H{"error": "userId mismatch"})
			return
		}

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
			userType = "customer"
			storeId = ""
			global.GVA_LOG.Warn("WebSocket连接用户未找到门店成员记录",
				zap.Int64("userId", userId),
				zap.Error(err))
		}

		// 牛头APP（验光师）：同步设备在线状态
		if userType == "optometrist" {
			utils.EnsureDeviceRecord(userIdStr, "牛头control", member.Username)
			utils.SyncDeviceStatus(userIdStr, 1)
			go func() {
				wsmanager.WSManager.HandleWebSocketWithStrIDAndInfo(c.Writer, c.Request, userIdStr, userType, storeId)
				utils.SyncDeviceStatus(userIdStr, 0)
			}()
			return
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
	router.RouterGroupApp.Optometry.InitErrorReportLogRouter(optometryGroup)

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

	// 小程序私有路由（JWT 认证，放在 publicGroup + MiniJWTAuth 中间件）
	router.RouterGroupApp.Wechat.InitWxMiniRouter(publicGroup)

	// 小程序公开路由（无需 JWT）
	router.RouterGroupApp.Wechat.InitWxMiniPublicRouter(publicGroup)

	// 客户端设备API（无需 JWT）
	router.RouterGroupApp.Client.InitClientPublicRouter(publicGroup)

	// 大模型聊天桥接API（无需 JWT，供 Control App 调用）
	router.RouterGroupApp.Chat.InitChatPublicRouter(publicGroup)
}
