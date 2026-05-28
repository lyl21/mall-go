package wxPay

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/wechatpay-apiv3/wechatpay-go/core"
	"github.com/wechatpay-apiv3/wechatpay-go/core/auth/signers"
	"github.com/wechatpay-apiv3/wechatpay-go/services/payments"
	"github.com/wechatpay-apiv3/wechatpay-go/services/payments/jsapi"
	"go.uber.org/zap"
)

// PrepayRequest 小程序 JSAPI 下单请求
type PrepayRequest struct {
	OrderNo     string
	Description string
	Amount      int64 // 金额，单位：分
	OpenId      string
	Attach      string // 附加数据
}

// PrepayResponse 小程序 JSAPI 下单响应（给前端调起支付）
type PrepayResponse struct {
	PrepayId  string `json:"prepayId"`
	Package   string `json:"package"`
	NonceStr  string `json:"nonceStr"`
	TimeStamp string `json:"timeStamp"`
	SignType  string `json:"signType"`
	PaySign   string `json:"paySign"`
}

// MiniPayPrepay 小程序 JSAPI 下单（V3）
func MiniPayPrepay(req PrepayRequest) (*PrepayResponse, error) {
	client, err := GetClient()
	if err != nil {
		return nil, fmt.Errorf("获取支付客户端失败: %w", err)
	}

	cfg := global.GVA_CONFIG.Wechat

	svc := jsapi.JsapiApiService{Client: client}

	resp, _, err := svc.Prepay(context.Background(), jsapi.PrepayRequest{
		Appid:       core.String(cfg.MiniAppID),
		Mchid:       core.String(cfg.MchID),
		Description: core.String(req.Description),
		OutTradeNo:  core.String(req.OrderNo),
		Attach:      core.String(req.Attach),
		NotifyUrl:   core.String(cfg.NotifyURL),
		Amount: &jsapi.Amount{
			Total: core.Int64(req.Amount),
		},
		Payer: &jsapi.Payer{
			Openid: core.String(req.OpenId),
		},
	})
	if err != nil {
		global.GVA_LOG.Error("微信支付 JSAPI 下单失败", zap.Error(err))
		return nil, fmt.Errorf("微信支付下单失败: %w", err)
	}

	if resp.PrepayId == nil || *resp.PrepayId == "" {
		return nil, fmt.Errorf("获取 prepay_id 失败")
	}

	// 生成小程序调起支付所需的签名
	paySign, nonce, timestamp, err := generateMiniPaySign(*resp.PrepayId, cfg.MiniAppID)
	if err != nil {
		return nil, fmt.Errorf("生成支付签名失败: %w", err)
	}

	return &PrepayResponse{
		PrepayId:  *resp.PrepayId,
		Package:   "prepay_id=" + *resp.PrepayId,
		NonceStr:  nonce,
		TimeStamp: timestamp,
		SignType:  "RSA",
		PaySign:   paySign,
	}, nil
}

// generateMiniPaySign 生成小程序调起支付签名
// 签名格式: appId + timestamp + nonceStr + prepay_id
func generateMiniPaySign(prepayId, appId string) (sign, nonce, timestamp string, err error) {
	now := time.Now().Unix()
	timestamp = strconv.FormatInt(now, 10)
	nonce = fmt.Sprintf("wx%x", now)[:16]

	// 构建签名串
	signStr := appId + "\n" + timestamp + "\n" + nonce + "\n" + "prepay_id=" + prepayId + "\n"

	privateKey, err := GetPrivateKey()
	if err != nil {
		return "", "", "", err
	}

	cfg := global.GVA_CONFIG.Wechat
	signer := &signers.SHA256WithRSASigner{
		MchID:               cfg.MchID,
		CertificateSerialNo: cfg.MchCertificateSerialNumber,
		PrivateKey:          privateKey,
	}

	result, err := signer.Sign(context.Background(), signStr)
	if err != nil {
		return "", "", "", err
	}

	return result.Signature, nonce, timestamp, nil
}

// MiniPayQuery 查询订单支付状态
func MiniPayQuery(outTradeNo string) (*payments.Transaction, error) {
	client, err := GetClient()
	if err != nil {
		return nil, fmt.Errorf("获取支付客户端失败: %w", err)
	}

	cfg := global.GVA_CONFIG.Wechat
	svc := jsapi.JsapiApiService{Client: client}
	resp, _, err := svc.QueryOrderByOutTradeNo(context.Background(), jsapi.QueryOrderByOutTradeNoRequest{
		Mchid:      core.String(cfg.MchID),
		OutTradeNo: core.String(outTradeNo),
	})
	if err != nil {
		return nil, fmt.Errorf("查询订单失败: %w", err)
	}

	return resp, nil
}
