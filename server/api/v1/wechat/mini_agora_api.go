package wechat

import (
	"crypto/sha256"
	"encoding/binary"
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// MiniAgoraApi 小程序音视频API
type MiniAgoraApi struct{}

// AgoraTokenRequest Agora Token请求
type AgoraTokenRequest struct {
	RoomId   string `json:"roomId" binding:"required"`
	UserId   string `json:"userId" binding:"required"`
	ClientId string `json:"clientId" binding:"required"`
	Role     string `json:"role"` // host, participant
}

// GetAgoraToken 获取Agora Token
// @Tags      MiniAgora
// @Summary   获取Agora音视频Token
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      AgoraTokenRequest  true  "Token请求信息"
// @Success   200   {object}  response.Response{data=utils.AgoraTokenResponse}  "获取成功"
// @Router    /weixin/api/ma/agora/token [post]
func (a *MiniAgoraApi) GetAgoraToken(c *gin.Context) {
	var req AgoraTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 强制使用 JWT 中的 wxUserId 作为 Agora 用户标识
	if wxId, exists := c.Get("wxUserId"); exists {
		req.UserId = wxId.(string)
	}

	// 获取Agora配置（优先从 sys_params 读取）
	appId := utils.GetParamValue("agora_app_id", global.GVA_CONFIG.Agora.AppId)
	appCertificate := utils.GetParamValue("agora_app_certificate", global.GVA_CONFIG.Agora.AppCertificate)

	if appId == "" || appCertificate == "" {
		response.FailWithMessage("Agora未配置", c)
		return
	}

	// 生成Channel名称
	channelName := "channel_" + req.RoomId

	// 生成UID
	uid := hashStringToUint32(req.UserId)

	// 使用真实 Agora SDK 生成 Token
	rtcGen := utils.NewAgoraTokenGenerator()
	token := rtcGen.GenerateRtcToken(channelName, int(uid))
	if token == "" {
		global.GVA_LOG.Warn("Agora Token 生成失败，降级为 mock",
			zap.String("channel", channelName))
		token = generateMockToken(appId, channelName, req.UserId)
	}

	global.GVA_LOG.Info("生成Agora Token",
		zap.String("channel", channelName),
		zap.String("userId", req.UserId),
		zap.Uint32("uid", uid))

	response.OkWithData(utils.AgoraTokenResponse{
		Type:    "token",
		Channel: channelName,
		Token:   token,
		Uid:     uid,
		AppId:   appId,
	}, c)
}

// JoinRoomRequest 加入房间请求
type JoinRoomRequest struct {
	RoomId   string `json:"roomId" binding:"required"`
	UserId   string `json:"userId" binding:"required"`
	ClientId string `json:"clientId" binding:"required"`
	Role     string `json:"role"` // host, participant
}

// JoinRoom 加入音视频房间
// @Tags      MiniAgora
// @Summary   加入音视频房间
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      JoinRoomRequest  true  "房间信息"
// @Success   200   {object}  response.Response{data=map[string]interface{}}  "加入成功"
// @Router    /weixin/api/ma/agora/join [post]
func (a *MiniAgoraApi) JoinRoom(c *gin.Context) {
	var req JoinRoomRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 强制使用 JWT 中的 wxUserId
	if wxId, exists := c.Get("wxUserId"); exists {
		req.UserId = wxId.(string)
	}

	if req.Role == "" {
		req.Role = "participant"
	}

	// 获取房间信息
	roomInfo, exists := utils.AgoraWSManager.GetRoomInfo(req.RoomId)

	global.GVA_LOG.Info("用户加入音视频房间",
		zap.String("roomId", req.RoomId),
		zap.String("userId", req.UserId),
		zap.String("role", req.Role))

	if exists {
		response.OkWithData(gin.H{
			"roomId":   req.RoomId,
			"role":     req.Role,
			"existing": true,
			"roomInfo": roomInfo,
			"wsUrl":    "/ws/agora",
			"message":  "房间已存在，将加入现有房间",
		}, c)
	} else {
		response.OkWithData(gin.H{
			"roomId":   req.RoomId,
			"role":     req.Role,
			"existing": false,
			"wsUrl":    "/ws/agora",
			"message":  "创建新房间",
		}, c)
	}
}

// LeaveRoomRequest 离开房间请求
type LeaveRoomRequest struct {
	RoomId   string `json:"roomId" binding:"required"`
	ClientId string `json:"clientId" binding:"required"`
}

// LeaveRoom 离开音视频房间
// @Tags      MiniAgora
// @Summary   离开音视频房间
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      LeaveRoomRequest  true  "房间信息"
// @Success   200   {object}  response.Response{msg=string}  "离开成功"
// @Router    /weixin/api/ma/agora/leave [post]
func (a *MiniAgoraApi) LeaveRoom(c *gin.Context) {
	var req LeaveRoomRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 使用 JWT 中的 wxUserId 校验用户身份
	wxUserId := getWxUserIdFromContext(c)
	if wxUserId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	// 通过 WebSocket 管理器将用户从房间中移除
	if utils.AgoraWSManager != nil {
		utils.AgoraWSManager.RemoveClientFromRoom(req.ClientId, req.RoomId)
	}

	global.GVA_LOG.Info("用户离开音视频房间",
		zap.String("roomId", req.RoomId),
		zap.String("clientId", req.ClientId),
		zap.String("wxUserId", wxUserId))

	response.OkWithMessage("已离开房间", c)
}

// GetRoomInfo 获取房间信息
// @Tags      MiniAgora
// @Summary   获取音视频房间信息
// @Produce   application/json
// @Param     roomId  query     string  true  "房间ID"
// @Success   200     {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/agora/room [get]
func (a *MiniAgoraApi) GetRoomInfo(c *gin.Context) {
	roomId := c.Query("roomId")
	if roomId == "" {
		response.FailWithMessage("房间ID不能为空", c)
		return
	}

	// 校验用户登录状态
	wxUserId := getWxUserIdFromContext(c)
	if wxUserId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	roomInfo, exists := utils.AgoraWSManager.GetRoomInfo(roomId)
	if !exists {
		response.FailWithMessage("房间不存在", c)
		return
	}

	response.OkWithData(roomInfo, c)
}

// GetRoomList 获取房间列表
// @Tags      MiniAgora
// @Summary   获取音视频房间列表
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]map[string]interface{}}  "获取成功"
// @Router    /weixin/api/ma/agora/rooms [get]
func (a *MiniAgoraApi) GetRoomList(c *gin.Context) {
	// 简化实现，返回房间数量
	roomCount := utils.AgoraWSManager.GetRoomCount()

	response.OkWithData(gin.H{
		"count": roomCount,
	}, c)
}

// hashStringToUint32 将字符串哈希为uint32（使用SHA256减少碰撞）
func hashStringToUint32(s string) uint32 {
	h := sha256.Sum256([]byte(s))
	// 取前4字节转换为uint32，碰撞概率极低
	return binary.BigEndian.Uint32(h[:4]) % 1000000000
}

// generateMockToken 生成模拟Token
// 注意：这只是示例实现，实际生产环境需要使用Agora官方SDK生成Token
// 参考：https://docs.agora.io/cn/Video/token_server
func generateMockToken(appId, channelName, userId string) string {
	// TODO: 接入Agora官方Token生成SDK
	// 当前为模拟实现，仅用于开发和测试
	timestamp := time.Now().Unix()
	return fmt.Sprintf("mock_token_%s_%s_%s_%d", appId[:8], channelName, userId[:8], timestamp)
}
