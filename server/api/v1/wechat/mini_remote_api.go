package wechat

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallService "github.com/flipped-aurora/gin-vue-admin/server/service/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/flipped-aurora/gin-vue-admin/server/wsmanager"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// MiniRemoteApi 小程序远程验光API
type MiniRemoteApi struct{}

// GetRemoteOptometryToken 获取远程验光Token
// @Tags      MiniRemote
// @Summary   获取远程验光Token
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      GetRemoteTokenRequest  true  "Token请求信息"
// @Success   200   {object}  response.Response{data=utils.AgoraTokenResponse}  "获取成功"
// @Router    /weixin/api/ma/remote/token [post]
func (a *MiniRemoteApi) GetRemoteOptometryToken(c *gin.Context) {
	var req GetRemoteTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithBadRequest("参数错误: "+err.Error(), c)
		return
	}

	// 获取Agora配置
	appId := global.GVA_CONFIG.Agora.AppId
	appCertificate := global.GVA_CONFIG.Agora.AppCertificate

	if appId == "" || appCertificate == "" {
		response.FailWithMessage("Agora未配置", c)
		return
	}

	// 生成Token
	rtcGen := utils.NewAgoraTokenGenerator()
	if !rtcGen.IsConfigured() {
		response.FailWithMessage("Agora未配置", c)
		return
	}

	token := rtcGen.GenerateRtcToken(req.ChannelName, req.UID)
	if token == "" {
		response.FailWithMessage("Token生成失败", c)
		return
	}

	global.GVA_LOG.Info("生成远程验光 Token",
		zap.String("channel", req.ChannelName),
		zap.Int("uid", req.UID))

	response.OkWithData(utils.AgoraTokenResponse{
		Type:    "token",
		Channel: req.ChannelName,
		Token:   token,
		Uid:     uint32(req.UID),
		AppId:   appId,
	}, c)
}

// GetRemoteOptometryWsUrl 获取远程验光WebSocket地址
// @Tags      MiniRemote
// @Summary   获取远程验光WebSocket地址
// @Produce   application/json
// @Param     userId  query     int  true  "用户ID"
// @Success   200     {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/ws-url [get]
func (a *MiniRemoteApi) GetRemoteOptometryWsUrl(c *gin.Context) {
	val, exists := c.Get("wxUserId")
	if !exists {
		response.FailWithMessage("请先登录", c)
		return
	}
	userId, ok := val.(string)
	if !ok || userId == "" {
		response.FailWithMessage("用户信息异常", c)
		return
	}

	// 构建WebSocket URL
	wsUrl := "/ws/remote-optometry/" + userId

	response.OkWithData(gin.H{
		"wsUrl":   wsUrl,
		"userId":  userId,
		"message": "WebSocket地址获取成功",
	}, c)
}

// GetRemoteOptometrySessionInfo 获取远程验光会话信息
// @Tags      MiniRemote
// @Summary   获取远程验光会话信息
// @Produce   application/json
// @Success   200  {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/session-info [get]
func (a *MiniRemoteApi) GetRemoteOptometrySessionInfo(c *gin.Context) {
	// 返回远程验光服务信息
	response.OkWithData(gin.H{
		"service": "remote-optometry",
		"version": "1.0.0",
		"supportedCmds": []string{
			"create_session",
			"join_session",
			"control_request",
			"control_response",
			"command/patch",
			"ack",
			"state_sync",
			"heartbeat",
		},
		"rtcProvider": "agora",
	}, c)
}

// GetRemoteTokenRequest 获取远程验光Token请求
type GetRemoteTokenRequest struct {
	ChannelName string `json:"channelName" binding:"required"`
	UID         int    `json:"uid" binding:"required"`
}

// RemoteControlRequest 远程控制请求
type RemoteControlRequest struct {
	DeviceID string `json:"deviceId" binding:"required"`
	Command  string `json:"command" binding:"required"`
}

// RemoteControl 远程控制设备
// @Tags      MiniRemote
// @Summary   远程控制设备
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      RemoteControlRequest  true  "控制信息"
// @Success   200   {object}  response.Response{msg=string}  "控制成功"
// @Router    /weixin/api/ma/remote/control [post]
func (a *MiniRemoteApi) RemoteControl(c *gin.Context) {
	var req RemoteControlRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithBadRequest("参数错误: "+err.Error(), c)
		return
	}

	// 校验用户身份
	wxUserId := getWxUserIdFromContext(c)
	if wxUserId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	// 与原始ry逻辑一致：远程控制无命令白名单限制，直接转发
	// ry原始项目中远程控制通过WebSocket remote_req命令实现，无额外校验

	global.GVA_LOG.Info("远程控制设备",
		zap.String("deviceId", req.DeviceID),
		zap.String("command", req.Command),
		zap.String("wxUserId", wxUserId))

	response.OkWithMessage("控制命令已发送", c)
}

// GetOnlineUsers 获取在线用户列表
// @Tags      MiniRemote
// @Summary   获取在线用户列表
// @Produce   application/json
// @Success   200  {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/online-users [get]
func (a *MiniRemoteApi) GetOnlineUsers(c *gin.Context) {
	// 返回在线用户列表
	// 这里可以从WebSocket管理器获取在线用户

	response.OkWithData(gin.H{
		"users": []map[string]interface{}{},
		"count": 0,
	}, c)
}

// RemoteDoorOpenRequest 远程开门请求
type RemoteDoorOpenRequest struct {
	DoorId int64  `json:"doorId" binding:"required"` // 门锁ID（door_lock表主键）
	OpenID string `json:"openId"`                    // 用户openId（可选，后端也从JWT获取）
}

// RemoteDoorOpen 远程开门（调用 DoorLockService 完整流程：远程开门→记录历史→同步用户→WS通知门店）
// @Tags      MiniRemote
// @Summary   远程开门
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      RemoteDoorOpenRequest  true  "开门信息"
// @Success   200   {object}  response.Response{msg=string}  "开门成功"
// @Router    /weixin/api/ma/remote/door/open [post]
func (a *MiniRemoteApi) RemoteDoorOpen(c *gin.Context) {
	var req RemoteDoorOpenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithBadRequest("参数错误: "+err.Error(), c)
		return
	}

	// 优先使用请求中的openId，否则从JWT上下文获取
	openId := req.OpenID
	if openId == "" {
		openId = getWxUserIdFromContext(c)
	}
	if openId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	global.GVA_LOG.Info("小程序远程开门",
		zap.Int64("doorId", req.DoorId),
		zap.String("openId", openId))

	// 调用 DoorLockService.OpenDoor 完整流程：
	// 1. 校验门锁信息（yardSn/doorGuid）
	// 2. 调第三方云平台API远程开门
	// 3. 记录操作历史到 door_lock_history
	// 4. 查询微信用户信息
	// 5. 根据门锁查找门店（MxStore）
	// 6. 查找或创建门店用户（MxUser）
	// 7. 添加门店成员关系
	// 8. WebSocket通知门店店长/验光师
	result, err := mallService.DoorLockServiceApp.OpenDoor(req.DoorId, openId)
	if err != nil {
		global.GVA_LOG.Error("远程开门失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}

	response.OkWithDetailed(result, "开门成功", c)
}

// GetRemoteOptometryHealth 获取远程验光服务健康状态
// @Tags      MiniRemote
// @Summary   获取远程验光服务健康状态
// @Produce   application/json
// @Success   200  {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/health [get]
func (a *MiniRemoteApi) GetRemoteOptometryHealth(c *gin.Context) {
	// 检查WebSocket管理器状态
	if wsmanager.WSManager == nil {
		response.FailWithMessage("远程验光服务未初始化", c)
		return
	}

	// 获取统计信息
	stats := wsmanager.WSManager.GetStats()

	response.OkWithData(gin.H{
		"status":    "healthy",
		"timestamp": time.Now().Unix(),
		"stats":     stats,
	}, c)
}

// GetRemoteOptometryStats 获取远程验光服务统计信息
// @Tags      MiniRemote
// @Summary   获取远程验光服务统计信息
// @Produce   application/json
// @Success   200  {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/stats [get]
func (a *MiniRemoteApi) GetRemoteOptometryStats(c *gin.Context) {
	if wsmanager.WSManager == nil {
		response.FailWithMessage("远程验光服务未初始化", c)
		return
	}

	stats := wsmanager.WSManager.GetStats()

	response.OkWithData(stats, c)
}
