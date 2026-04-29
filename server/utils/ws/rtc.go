package ws

import (
	"fmt"
	"time"

	"github.com/AgoraIO-Community/go-tokenbuilder/rtctokenbuilder"
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// RtcTokenGenerator RTC Token生成器
type RtcTokenGenerator struct {
	appID          string
	appCertificate string
	tokenExpireSeconds uint32
}

// NewRtcTokenGenerator 创建RTC Token生成器
func NewRtcTokenGenerator(appID, appCertificate string, tokenExpireSeconds uint32) *RtcTokenGenerator {
	return &RtcTokenGenerator{
		appID:          appID,
		appCertificate: appCertificate,
		tokenExpireSeconds: tokenExpireSeconds,
	}
}

// GenerateRtcToken 生成RTC Token
func (g *RtcTokenGenerator) GenerateRtcToken(channelName string, uid int) *RtcConfig {
	if g.appCertificate == "" {
		global.GVA_LOG.Warn("声网证书未配置，使用模拟Token")
		return g.generateMockToken(channelName, uid)
	}

	// 使用声网SDK生成真实Token
	return g.generateRealToken(channelName, uid)
}

// generateMockToken 生成模拟Token
func (g *RtcTokenGenerator) generateMockToken(channelName string, uid int) *RtcConfig {
	expireTimestamp := uint32(time.Now().Unix()) + g.tokenExpireSeconds
	token := fmt.Sprintf("mock_token_%s_%d_%d", channelName, uid, expireTimestamp)

	return &RtcConfig{
		AppID:           g.appID,
		ChannelName:     channelName,
		Token:           token,
		UID:             uid,
		TokenExpireTime: int(expireTimestamp),
	}
}

// generateRealToken 生成真实声网Token
func (g *RtcTokenGenerator) generateRealToken(channelName string, uid int) *RtcConfig {
	expireTimestamp := uint32(time.Now().Unix()) + g.tokenExpireSeconds

	// 使用声网SDK生成Token
	token, err := rtctokenbuilder.BuildTokenWithUID(
		g.appID,
		g.appCertificate,
		channelName,
		uint32(uid),
		rtctokenbuilder.RolePublisher,
		expireTimestamp,
	)

	if err != nil {
		global.GVA_LOG.Error("生成声网RTC Token失败",
			zap.String("channelName", channelName),
			zap.Int("uid", uid),
			zap.Error(err))
		return nil
	}

	global.GVA_LOG.Info("成功生成声网RTC Token",
		zap.String("channelName", channelName),
		zap.Int("uid", uid),
		zap.Uint32("expireTimestamp", expireTimestamp))

	return &RtcConfig{
		AppID:           g.appID,
		ChannelName:     channelName,
		Token:           token,
		UID:             uid,
		TokenExpireTime: int(expireTimestamp),
	}
}

// GetAppID 获取AppID
func (g *RtcTokenGenerator) GetAppID() string {
	return g.appID
}

// IsConfigured 检查是否已配置证书
func (g *RtcTokenGenerator) IsConfigured() bool {
	return g.appCertificate != ""
}
