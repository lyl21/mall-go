package wechat

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
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
		response.FailWithMessage("参数错误: "+err.Error(), c)
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
	userId := c.Query("userId")
	if userId == "" {
		response.FailWithMessage("用户ID不能为空", c)
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
		"service":      "remote-optometry",
		"version":      "1.0.0",
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
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	global.GVA_LOG.Info("远程控制设备",
		zap.String("deviceId", req.DeviceID),
		zap.String("command", req.Command))

	// 这里可以实现具体的远程控制逻辑
	// 例如通过WebSocket发送控制命令给设备

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
	DeviceID string `json:"deviceId" binding:"required"`
	Duration int    `json:"duration"` // 开门持续时间（秒）
}

// RemoteDoorOpen 远程开门
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
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	if req.Duration <= 0 {
		req.Duration = 5 // 默认5秒
	}

	global.GVA_LOG.Info("远程开门",
		zap.String("deviceId", req.DeviceID),
		zap.Int("duration", req.Duration))

	// 这里可以实现具体的远程开门逻辑

	response.OkWithMessage("开门命令已发送", c)
}

// GetRemoteOptometryHealth 获取远程验光服务健康状态
// @Tags      MiniRemote
// @Summary   获取远程验光服务健康状态
// @Produce   application/json
// @Success   200  {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/remote/health [get]
func (a *MiniRemoteApi) GetRemoteOptometryHealth(c *gin.Context) {
	// 检查WebSocket管理器状态
	if utils.RemoteOptometryManager == nil {
		response.FailWithMessage("远程验光服务未初始化", c)
		return
	}

	// 获取统计信息
	stats := utils.RemoteOptometryManager.GetStats()

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
	if utils.RemoteOptometryManager == nil {
		response.FailWithMessage("远程验光服务未初始化", c)
		return
	}

	stats := utils.RemoteOptometryManager.GetStats()

	response.OkWithData(stats, c)
}
