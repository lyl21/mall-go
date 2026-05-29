package wechat

import (
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"encoding/json"
	"encoding/xml"
	"io"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/flipped-aurora/gin-vue-admin/server/wxPay"
	"github.com/gin-gonic/gin"
	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// MiniPayApi 小程序支付API
type MiniPayApi struct{}

// UnifiedOrderRequest 统一下单请求
type UnifiedOrderRequest struct {
	OrderId string `json:"orderId" binding:"required"`
	Type    int    `json:"type"` // 0小程序 1Web
}

// UnifiedOrder 微信支付下单（V3 JSAPI）
// @Tags      MiniPay
// @Summary   小程序微信支付统一下单
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      UnifiedOrderRequest  true  "订单信息"
// @Success   200   {object}  response.Response{data=wxPay.PrepayResponse}  "下单成功"
// @Router    /weixin/api/ma/orderinfo/unifiedOrder [post]
func (a *MiniPayApi) UnifiedOrder(c *gin.Context) {
	var req UnifiedOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 获取订单信息
	var order mall.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", req.OrderId, "0").First(&order).Error; err != nil {
		response.FailWithMessage("订单不存在", c)
		return
	}

	// 校验订单归属
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}
	if order.UserId != userId {
		response.FailWithMessage("无权操作此订单", c)
		return
	}

	// 只有未支付订单能发起支付
	if order.IsPay != "0" {
		response.FailWithMessage("订单已支付", c)
		return
	}

	// 0元订单直接支付成功
	if order.PaymentPrice == 0 {
		a.notifyOrder(&order)
		response.OkWithData(gin.H{"paid": true}, c)
		return
	}

	// 获取用户OpenId
	var wxUser wechatModel.WxUser
	if err := global.GVA_DB.Where("id = ?", order.UserId).First(&wxUser).Error; err != nil {
		response.FailWithMessage("用户不存在", c)
		return
	}

	// 检查 V3 支付配置
	if !wxPay.IsV3Configured() {
		// 降级到 V2 支付
		a.unifiedOrderV2(c, &order, wxUser.OpenId)
		return
	}

	// V3 支付下单
	desc := "商品购买"
	if order.Name != nil && *order.Name != "" {
		desc = *order.Name
		if len(desc) > 40 {
			desc = desc[:40]
		}
	}

	payResp, err := wxPay.MiniPayPrepay(wxPay.PrepayRequest{
		OrderNo:     order.OrderNo,
		Description: desc,
		Amount:      int64(order.PaymentPrice * 100),
		OpenId:      wxUser.OpenId,
		Attach:      req.OrderId,
	})
	if err != nil {
		global.GVA_LOG.Error("微信支付 V3 下单失败", zap.Error(err))
		response.FailWithMessage("支付下单失败: "+err.Error(), c)
		return
	}

	response.OkWithData(payResp, c)
}

// unifiedOrderV2 V2 支付降级方案（保留 gopay 兼容）
func (a *MiniPayApi) unifiedOrderV2(c *gin.Context, order *mall.OrderInfo, openId string) {
	appId := global.GVA_CONFIG.Wechat.MiniAppID
	mchId := global.GVA_CONFIG.Wechat.MchID
	apiKey := global.GVA_CONFIG.Wechat.APIKey
	notifyUrl := global.GVA_CONFIG.Wechat.NotifyURL
	if notifyUrl == "" {
		notifyUrl = "https://" + c.Request.Host + "/weixin/api/ma/orderinfo/notify-order"
	}

	client := wechat.NewClient(appId, mchId, apiKey, false)

	body := order.Name
	if body == nil || *body == "" {
		defaultBody := "商品购买"
		body = &defaultBody
	}
	if len(*body) > 40 {
		s := (*body)[:40]
		body = &s
	}

	bm := make(gopay.BodyMap)
	bm.Set("body", *body)
	bm.Set("out_trade_no", order.OrderNo)
	bm.Set("total_fee", int64(order.PaymentPrice*100))
	bm.Set("spbill_create_ip", c.ClientIP())
	bm.Set("notify_url", notifyUrl)
	bm.Set("trade_type", wechat.TradeType_Mini)
	bm.Set("openid", openId)

	wxRsp, err := client.UnifiedOrder(c, bm)
	if err != nil {
		global.GVA_LOG.Error("微信支付 V2 统一下单失败", zap.Error(err))
		response.FailWithMessage("支付下单失败", c)
		return
	}

	if wxRsp.ReturnCode != gopay.SUCCESS {
		global.GVA_LOG.Error("微信支付 V2 返回失败", zap.String("return_msg", wxRsp.ReturnMsg))
		response.FailWithMessage(wxRsp.ReturnMsg, c)
		return
	}

	timeStamp := time.Now().Format("20060102150405")
	paySign := wechat.GetMiniPaySign(appId, wxRsp.NonceStr, wxRsp.PrepayId, wechat.SignType_MD5, timeStamp, apiKey)

	payParams := map[string]string{
		"appId":     appId,
		"timeStamp": timeStamp,
		"nonceStr":  wxRsp.NonceStr,
		"package":   "prepay_id=" + wxRsp.PrepayId,
		"signType":  "MD5",
		"paySign":   paySign,
	}

	response.OkWithData(payParams, c)
}

// PayNotify 微信支付回调
// @Tags      MiniPay
// @Summary   微信支付回调通知（V3 JSON 格式）
// @Accept    application/xml
// @Produce   application/xml
// @Success   200  {string}  string  "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>"
// @Router    /weixin/api/ma/orderinfo/notify-order [post]
func (a *MiniPayApi) PayNotify(c *gin.Context) {
	if wxPay.IsV3Configured() {
		a.payNotifyV3(c)
		return
	}
	a.payNotifyV2(c)
}

// payNotifyV3 V3 支付回调处理（AES-256-GCM 解密 + 处理订单）
func (a *MiniPayApi) payNotifyV3(c *gin.Context) {
	body, err := io.ReadAll(c.Request.Body)
	if err != nil {
		global.GVA_LOG.Error("V3回调-读取Body失败", zap.Error(err))
		c.JSON(500, gin.H{"code": "FAIL", "message": "读取数据失败"})
		return
	}

	var notify struct {
		Resource struct {
			Ciphertext     string `json:"ciphertext"`
			Nonce          string `json:"nonce"`
			AssociatedData string `json:"associated_data"`
		} `json:"resource"`
	}
	if err := json.Unmarshal(body, &notify); err != nil {
		global.GVA_LOG.Error("V3回调-解析JSON失败", zap.Error(err))
		c.JSON(400, gin.H{"code": "FAIL", "message": "参数错误"})
		return
	}

	// AES-256-GCM 解密
	plainText, err := aesGCMDecrypt(
		notify.Resource.Ciphertext,
		notify.Resource.Nonce,
		notify.Resource.AssociatedData,
		global.GVA_CONFIG.Wechat.MchAPIv3Key,
	)
	if err != nil {
		global.GVA_LOG.Error("V3回调-解密失败", zap.Error(err))
		c.JSON(500, gin.H{"code": "FAIL", "message": "解密失败"})
		return
	}

	var transaction struct {
		OutTradeNo string `json:"out_trade_no"`
		TradeState string `json:"trade_state"`
	}
	if err := json.Unmarshal([]byte(plainText), &transaction); err != nil {
		global.GVA_LOG.Error("V3回调-解析交易数据失败", zap.Error(err))
		c.JSON(200, gin.H{"code": "SUCCESS", "message": "OK"})
		return
	}

	global.GVA_LOG.Info("V3支付回调", zap.String("outTradeNo", transaction.OutTradeNo))

	if transaction.TradeState != "SUCCESS" {
		c.JSON(200, gin.H{"code": "SUCCESS", "message": "OK"})
		return
	}

	var order mall.OrderInfo
	if err := global.GVA_DB.Where("order_no = ? AND del_flag = ?", transaction.OutTradeNo, "0").First(&order).Error; err != nil {
		global.GVA_LOG.Error("V3回调-订单不存在", zap.String("outTradeNo", transaction.OutTradeNo))
		c.JSON(200, gin.H{"code": "SUCCESS", "message": "OK"})
		return
	}

	a.notifyOrder(&order)
	c.JSON(200, gin.H{"code": "SUCCESS", "message": "OK"})
}

// aesGCMDecrypt 微信支付 V3 回调 AES-256-GCM 解密
func aesGCMDecrypt(ciphertext, nonce, associatedData, apiV3Key string) (string, error) {
	cipherBytes, err := base64.StdEncoding.DecodeString(ciphertext)
	if err != nil {
		return "", err
	}

	block, err := aes.NewCipher([]byte(apiV3Key))
	if err != nil {
		return "", err
	}

	aesGCM, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}

	nonceBytes := []byte(nonce)
	plainBytes, err := aesGCM.Open(nil, nonceBytes, cipherBytes, []byte(associatedData))
	if err != nil {
		return "", err
	}

	return string(plainBytes), nil
}

// payNotifyV2 V2 支付回调处理（XML 格式，保留兼容）
func (a *MiniPayApi) payNotifyV2(c *gin.Context) {
	body, err := io.ReadAll(c.Request.Body)
	if err != nil {
		global.GVA_LOG.Error("读取支付回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "读取数据失败"})
		return
	}

	var notifyReq wechat.NotifyRequest
	if err := xml.Unmarshal(body, &notifyReq); err != nil {
		global.GVA_LOG.Error("解析支付回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "解析数据失败"})
		return
	}

	apiKey := global.GVA_CONFIG.Wechat.APIKey
	ok, err := wechat.VerifySign(apiKey, wechat.SignType_MD5, notifyReq)
	if err != nil || !ok {
		global.GVA_LOG.Error("验证支付回调签名失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "签名验证失败"})
		return
	}

	if notifyReq.ReturnCode == gopay.SUCCESS && notifyReq.ResultCode == gopay.SUCCESS {
		var order mall.OrderInfo
		if err := global.GVA_DB.Where("order_no = ? AND del_flag = ?", notifyReq.OutTradeNo, "0").First(&order).Error; err == nil {
			a.notifyOrder(&order)
		}
	}

	c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.SUCCESS, ReturnMsg: "OK"})
}

// notifyOrder 订单支付成功处理（SQL乐观锁防并发重复处理）
func (a *MiniPayApi) notifyOrder(order *mall.OrderInfo) {
	// 先尝试原子更新 is_pay，如果有并发回调，只有一个能更新成功
	result := global.GVA_DB.Model(&mall.OrderInfo{}).
		Where("id = ? AND is_pay = ?", order.Id, "0").
		Update("is_pay", "1")
	if result.Error != nil || result.RowsAffected == 0 {
		return
	}

	tx := global.GVA_DB.Begin()

	now := time.Now()
	status := "1"

	if err := tx.Model(order).Updates(map[string]interface{}{
		"is_pay":       "1",
		"status":       &status,
		"payment_time": &now,
	}).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("更新订单支付状态失败", zap.Error(err))
		return
	}

	var orderItems []mall.OrderItem
	if err := tx.Where("order_id = ?", order.Id).Find(&orderItems).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("查询订单商品失败", zap.Error(err))
		return
	}

	for _, item := range orderItems {
		if err := tx.Model(&mall.GoodsSpu{}).Where("id = ?", item.SpuId).UpdateColumn("sales_num", gorm.Expr("sales_num + ?", item.Quantity)).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("更新商品销量失败", zap.Error(err))
			return
		}
	}

	if err := tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交支付通知事务失败", zap.Error(err))
		return
	}

	if err := utils.CancelOrderTimeout(order.Id); err != nil {
		global.GVA_LOG.Error("取消订单超时失败", zap.Error(err))
	}
}

// RefundRequest 退款请求
type RefundRequest struct {
	OrderId    string  `json:"orderId" binding:"required"`
	RefundFee  float64 `json:"refundFee"`
	RefundDesc string  `json:"refundDesc"`
}

// Refund 订单退款
// @Tags      MiniPay
// @Summary   小程序订单退款
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      RefundRequest  true  "退款信息"
// @Success   200   {object}  response.Response{msg=string}  "退款申请成功"
// @Router    /weixin/api/ma/orderinfo/refunds [post]
func (a *MiniPayApi) Refund(c *gin.Context) {
	var req RefundRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	var order mall.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", req.OrderId, "0").First(&order).Error; err != nil {
		response.FailWithMessage("订单不存在", c)
		return
	}

	// 校验订单归属
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}
	if order.UserId != userId {
		response.FailWithMessage("无权操作此订单", c)
		return
	}

	if order.IsPay != "1" {
		response.FailWithMessage("订单未支付", c)
		return
	}

	// V2 退款（后续可升级为 V3）
	appId := global.GVA_CONFIG.Wechat.MiniAppID
	mchId := global.GVA_CONFIG.Wechat.MchID
	apiKey := global.GVA_CONFIG.Wechat.APIKey

	client := wechat.NewClient(appId, mchId, apiKey, false)

	refundFee := req.RefundFee
	if refundFee == 0 {
		refundFee = order.PaymentPrice
	}

	refundNo := utils.GenerateOrderNo()

	bm := make(gopay.BodyMap)
	bm.Set("out_trade_no", order.OrderNo)
	bm.Set("out_refund_no", refundNo)
	bm.Set("total_fee", int64(order.PaymentPrice*100))
	bm.Set("refund_fee", int64(refundFee*100))
	bm.Set("refund_desc", req.RefundDesc)

	wxRsp, _, err := client.Refund(c, bm)
	if err != nil {
		global.GVA_LOG.Error("微信退款失败", zap.Error(err))
		response.FailWithMessage("退款申请失败", c)
		return
	}

	if wxRsp.ReturnCode != gopay.SUCCESS {
		global.GVA_LOG.Error("微信退款返回失败", zap.String("return_msg", wxRsp.ReturnMsg))
		response.FailWithMessage(wxRsp.ReturnMsg, c)
		return
	}

	status := "5"
	global.GVA_DB.Model(&order).Updates(map[string]interface{}{
		"status":    &status,
		"is_refund": "1",
	})

	response.OkWithMessage("退款申请成功", c)
}

// RefundNotify 微信退款回调
// @Tags      MiniPay
// @Summary   微信退款回调通知
// @Accept    application/xml
// @Produce   application/xml
// @Success   200  {string}  string  "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>"
// @Router    /weixin/api/ma/orderinfo/notify-refunds [post]
func (a *MiniPayApi) RefundNotify(c *gin.Context) {
	body, err := io.ReadAll(c.Request.Body)
	if err != nil {
		global.GVA_LOG.Error("读取退款回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "读取数据失败"})
		return
	}

	var notifyReq wechat.NotifyRequest
	if err := xml.Unmarshal(body, &notifyReq); err != nil {
		global.GVA_LOG.Error("解析退款回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "解析数据失败"})
		return
	}

	apiKey := global.GVA_CONFIG.Wechat.APIKey
	ok, err := wechat.VerifySign(apiKey, wechat.SignType_MD5, notifyReq)
	if err != nil || !ok {
		global.GVA_LOG.Error("验证退款回调签名失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "签名验证失败"})
		return
	}

	c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.SUCCESS, ReturnMsg: "OK"})
}
