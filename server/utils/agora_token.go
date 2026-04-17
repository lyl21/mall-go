package utils

import (
	"time"

	"github.com/AgoraIO-Community/go-tokenbuilder/rtctokenbuilder"
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// AgoraTokenGenerator 声网 Token 生成器
type AgoraTokenGenerator struct {
	appID              string
	appCertificate     string
	tokenExpireSeconds uint32
}

// NewAgoraTokenGenerator 创建声网 Token 生成器
func NewAgoraTokenGenerator() *AgoraTokenGenerator {
	return &AgoraTokenGenerator{
		appID:              global.GVA_CONFIG.Agora.AppId,
		appCertificate:     global.GVA_CONFIG.Agora.AppCertificate,
		tokenExpireSeconds: 86400, // 默认24小时
	}
}

// GenerateRtcToken 生成 RTC Token
func (g *AgoraTokenGenerator) GenerateRtcToken(channelName string, uid int) string {
	if g.appCertificate == "" {
		global.GVA_LOG.Warn("声网证书未配置，无法生成 Token")
		return ""
	}

	// 计算过期时间戳
	expireTimestamp := uint32(time.Now().Unix()) + g.tokenExpireSeconds

	// 使用官方 Token Builder 生成 Token
	token, err := rtctokenbuilder.BuildTokenWithUID(
		g.appID,
		g.appCertificate,
		channelName,
		uint32(uid),
		rtctokenbuilder.RolePublisher,
		expireTimestamp,
	)
	if err != nil {
		global.GVA_LOG.Error("生成 RTC Token 失败", 
			zap.String("channelName", channelName), 
			zap.Int("uid", uid), 
			zap.Error(err))
		return ""
	}

	global.GVA_LOG.Info("生成 RTC Token 成功", 
		zap.String("channelName", channelName), 
		zap.Int("uid", uid), 
		zap.Uint32("expireTimestamp", expireTimestamp))
	return token
}

// GenerateRtcTokenWithAccount 生成 RTC Token（使用字符串 uid）
func (g *AgoraTokenGenerator) GenerateRtcTokenWithAccount(channelName string, account string) string {
	if g.appCertificate == "" {
		global.GVA_LOG.Warn("声网证书未配置，无法生成 Token")
		return ""
	}

	expireTimestamp := uint32(time.Now().Unix()) + g.tokenExpireSeconds

	token, err := rtctokenbuilder.BuildTokenWithUserAccount(
		g.appID,
		g.appCertificate,
		channelName,
		account,
		rtctokenbuilder.RolePublisher,
		expireTimestamp,
	)
	if err != nil {
		global.GVA_LOG.Error("生成 RTC Token 失败", 
			zap.String("channelName", channelName), 
			zap.String("account", account), 
			zap.Error(err))
		return ""
	}

	global.GVA_LOG.Info("生成 RTC Token 成功", 
		zap.String("channelName", channelName), 
		zap.String("account", account), 
		zap.Uint32("expireTimestamp", expireTimestamp))
	return token
}

// GetAppID 获取 App ID
func (g *AgoraTokenGenerator) GetAppID() string {
	return g.appID
}

// IsConfigured 检查是否已配置证书
func (g *AgoraTokenGenerator) IsConfigured() bool {
	return g.appCertificate != ""
}

// GenerateRtcConfig 生成 RTC 配置
func (g *AgoraTokenGenerator) GenerateRtcConfig(sessionID string, roleSuffix string) *AgoraTokenResponse {
	if !g.IsConfigured() {
		return nil
	}

	// 根据角色生成不同的 uid
	baseUID := int(time.Now().UnixMilli() % 1000000)
	var uid int
	if roleSuffix == "main_control" {
		uid = baseUID | 1 // 确保是奇数
	} else {
		uid = baseUID & -2 // 确保是偶数
	}

	token := g.GenerateRtcToken(sessionID, uid)

	return &AgoraTokenResponse{
		Type:    "token",
		Channel: sessionID,
		Token:   token,
		Uid:     uint32(uid),
		AppId:   g.appID,
	}
}
