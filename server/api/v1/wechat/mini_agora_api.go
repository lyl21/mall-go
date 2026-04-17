package wechat

import (
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

	// 获取Agora配置
	appId := global.GVA_CONFIG.Agora.AppId
	appCertificate := global.GVA_CONFIG.Agora.AppCertificate

	if appId == "" || appCertificate == "" {
		response.FailWithMessage("Agora未配置", c)
		return
	}

	// 生成Channel名称
	channelName := "channel_" + req.RoomId

	// 生成UID（使用用户ID的哈希值）
	uid := hashStringToUint32(req.UserId)

	// 生成Token（简化版，实际应该使用Agora SDK）
	// 这里返回模拟数据，实际使用时需要集成Agora SDK
	token := generateMockToken(appId, channelName, req.UserId)

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
			"roomId":      req.RoomId,
			"role":        req.Role,
			"existing":    true,
			"roomInfo":    roomInfo,
			"wsUrl":       "/ws/agora",
			"message":     "房间已存在，将加入现有房间",
		}, c)
	} else {
		response.OkWithData(gin.H{
			"roomId":      req.RoomId,
			"role":        req.Role,
			"existing":    false,
			"wsUrl":       "/ws/agora",
			"message":     "创建新房间",
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

	// 发送离开消息给WebSocket
	// 实际离开操作由WebSocket处理

	global.GVA_LOG.Info("用户离开音视频房间",
		zap.String("roomId", req.RoomId),
		zap.String("clientId", req.ClientId))

	response.OkWithMessage("已发送离开请求", c)
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

// hashStringToUint32 将字符串哈希为uint32
func hashStringToUint32(s string) uint32 {
	var hash uint32 = 5381
	for i := 0; i < len(s); i++ {
		hash = ((hash << 5) + hash) + uint32(s[i])
	}
	return hash % 1000000000 // 限制在合理范围内
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
