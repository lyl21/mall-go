package wxPay

import (
	"context"
	"crypto/rsa"
	"fmt"
	"sync"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/wechatpay-apiv3/wechatpay-go/core"
	"github.com/wechatpay-apiv3/wechatpay-go/core/option"
	"github.com/wechatpay-apiv3/wechatpay-go/utils"
)

var (
	client     *core.Client
	clientOnce sync.Once
	clientErr  error
)

// GetClient 获取微信支付 V3 客户端（单例）
func GetClient() (*core.Client, error) {
	clientOnce.Do(func() {
		cfg := global.GVA_CONFIG.Wechat

		privateKey, err := utils.LoadPrivateKeyWithPath(cfg.MchPrivateKeyPath)
		if err != nil {
			clientErr = fmt.Errorf("加载商户私钥失败: %w", err)
			return
		}

		client, clientErr = core.NewClient(
			context.Background(),
			option.WithWechatPayAutoAuthCipher(
				cfg.MchID,
				cfg.MchCertificateSerialNumber,
				privateKey,
				cfg.MchAPIv3Key,
			),
		)
	})
	return client, clientErr
}

// GetPrivateKey 获取商户私钥（用于签名计算）
func GetPrivateKey() (*rsa.PrivateKey, error) {
	cfg := global.GVA_CONFIG.Wechat
	return utils.LoadPrivateKeyWithPath(cfg.MchPrivateKeyPath)
}

// IsV3Configured 检查 V3 支付是否已配置
func IsV3Configured() bool {
	cfg := global.GVA_CONFIG.Wechat
	return cfg.MchID != "" &&
		cfg.MchCertificateSerialNumber != "" &&
		cfg.MchPrivateKeyPath != "" &&
		cfg.MchAPIv3Key != ""
}
