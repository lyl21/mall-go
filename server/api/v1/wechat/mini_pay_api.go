package wechat

import (
	"encoding/xml"
	"fmt"
	"io"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
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

// UnifiedOrder 微信支付统一下单
// @Tags      MiniPay
// @Summary   小程序微信支付统一下单
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      UnifiedOrderRequest  true  "订单信息"
// @Success   200   {object}  response.Response{data=map[string]interface{}}  "下单成功"
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

	// 获取微信支付配置
	appId := global.GVA_CONFIG.Wechat.MiniAppID
	mchId := global.GVA_CONFIG.Wechat.MchID
	apiKey := global.GVA_CONFIG.Wechat.APIKey
	notifyUrl := global.GVA_CONFIG.Wechat.NotifyURL
	if notifyUrl == "" {
		notifyUrl = "https://" + c.Request.Host + "/weixin/api/ma/orderinfo/notify-order"
	}

	// 获取用户OpenId
	var wxUser wechatModel.WxUser
	if err := global.GVA_DB.Where("id = ?", order.UserId).First(&wxUser).Error; err != nil {
		response.FailWithMessage("用户不存在", c)
		return
	}

	// 创建微信支付客户端
	client := wechat.NewClient(appId, mchId, apiKey, false)

	// 构建统一下单参数
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
	bm.Set("total_fee", int64(order.PaymentPrice*100)) // 转为分
	bm.Set("spbill_create_ip", c.ClientIP())
	bm.Set("notify_url", notifyUrl)
	bm.Set("trade_type", wechat.TradeType_Mini)
	bm.Set("openid", wxUser.OpenId)

	// 调用统一下单
	wxRsp, err := client.UnifiedOrder(c, bm)
	if err != nil {
		global.GVA_LOG.Error("微信支付统一下单失败", zap.Error(err))
		response.FailWithMessage("支付下单失败", c)
		return
	}

	if wxRsp.ReturnCode != gopay.SUCCESS {
		global.GVA_LOG.Error("微信支付返回失败", zap.String("return_msg", wxRsp.ReturnMsg))
		response.FailWithMessage(wxRsp.ReturnMsg, c)
		return
	}

	// 生成小程序调起支付参数
	timeStamp := fmt.Sprintf("%d", time.Now().Unix())
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
// @Summary   微信支付回调通知
// @Accept    application/xml
// @Produce   application/xml
// @Success   200  {string}  string  "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>"
// @Router    /weixin/api/ma/orderinfo/notify-order [post]
func (a *MiniPayApi) PayNotify(c *gin.Context) {
	body, err := io.ReadAll(c.Request.Body)
	if err != nil {
		global.GVA_LOG.Error("读取支付回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "读取数据失败"})
		return
	}

	// 解析回调数据
	var notifyReq wechat.NotifyRequest
	if err := xml.Unmarshal(body, &notifyReq); err != nil {
		global.GVA_LOG.Error("解析支付回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "解析数据失败"})
		return
	}

	// 验证签名
	apiKey := global.GVA_CONFIG.Wechat.APIKey
	ok, err := wechat.VerifySign(apiKey, wechat.SignType_MD5, notifyReq)
	if err != nil || !ok {
		global.GVA_LOG.Error("验证支付回调签名失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "签名验证失败"})
		return
	}

	// 处理支付成功逻辑
	if notifyReq.ReturnCode == gopay.SUCCESS && notifyReq.ResultCode == gopay.SUCCESS {
		// 查询订单
		var order mall.OrderInfo
		if err := global.GVA_DB.Where("order_no = ? AND del_flag = ?", notifyReq.OutTradeNo, "0").First(&order).Error; err == nil {
			a.notifyOrder(&order)
		}
	}

	c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.SUCCESS, ReturnMsg: "OK"})
}

// notifyOrder 订单支付成功处理
func (a *MiniPayApi) notifyOrder(order *mall.OrderInfo) {
	if order.IsPay != "0" {
		return
	}

	// 使用事务处理
	tx := global.GVA_DB.Begin()

	now := time.Now()
	status := "1" // 待发货

	// 更新订单状态
	if err := tx.Model(order).Updates(map[string]interface{}{
		"is_pay":       "1",
		"status":       &status,
		"payment_time": &now,
	}).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("更新订单支付状态失败", zap.Error(err))
		return
	}

	// 更新商品销量
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

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交支付通知事务失败", zap.Error(err))
		return
	}

	// 取消订单超时
	if err := utils.CancelOrderTimeout(order.Id); err != nil {
		global.GVA_LOG.Error("取消订单超时失败", zap.Error(err))
	}
}

// RefundRequest 退款请求
type RefundRequest struct {
	OrderId     string  `json:"orderId" binding:"required"`
	RefundFee   float64 `json:"refundFee"`
	RefundDesc  string  `json:"refundDesc"`
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

	// 获取订单信息
	var order mall.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", req.OrderId, "0").First(&order).Error; err != nil {
		response.FailWithMessage("订单不存在", c)
		return
	}

	// 只有已支付订单能退款
	if order.IsPay != "1" {
		response.FailWithMessage("订单未支付", c)
		return
	}

	// 获取微信支付配置
	appId := global.GVA_CONFIG.Wechat.MiniAppID
	mchId := global.GVA_CONFIG.Wechat.MchID
	apiKey := global.GVA_CONFIG.Wechat.APIKey

	// 创建微信支付客户端
	client := wechat.NewClient(appId, mchId, apiKey, false)

	// 退款金额
	refundFee := req.RefundFee
	if refundFee == 0 {
		refundFee = order.PaymentPrice
	}

	// 生成退款单号
	refundNo := utils.GenerateOrderNo()

	bm := make(gopay.BodyMap)
	bm.Set("out_trade_no", order.OrderNo)
	bm.Set("out_refund_no", refundNo)
	bm.Set("total_fee", int64(order.PaymentPrice*100))
	bm.Set("refund_fee", int64(refundFee*100))
	bm.Set("refund_desc", req.RefundDesc)

	// 调用退款接口
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

	// 更新订单状态为退款中
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

	// 解析退款回调数据
	var notifyReq wechat.NotifyRequest
	if err := xml.Unmarshal(body, &notifyReq); err != nil {
		global.GVA_LOG.Error("解析退款回调数据失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "解析数据失败"})
		return
	}

	// 验证签名
	apiKey := global.GVA_CONFIG.Wechat.APIKey
	ok, err := wechat.VerifySign(apiKey, wechat.SignType_MD5, notifyReq)
	if err != nil || !ok {
		global.GVA_LOG.Error("验证退款回调签名失败", zap.Error(err))
		c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.FAIL, ReturnMsg: "签名验证失败"})
		return
	}

	// 处理退款成功逻辑
	if notifyReq.ReturnCode == gopay.SUCCESS {
		// 查询订单
		var order mall.OrderInfo
		if err := global.GVA_DB.Where("order_no = ? AND del_flag = ?", notifyReq.OutTradeNo, "0").First(&order).Error; err == nil {
			// 更新订单项退款状态
			var orderItems []mall.OrderItem
			global.GVA_DB.Where("order_id = ?", order.Id).Find(&orderItems)
			for _, item := range orderItems {
				global.GVA_DB.Model(&item).Updates(map[string]interface{}{
					"status":    "3", // 同意退款
					"is_refund": "1",
				})
			}
		}
	}

	c.XML(200, wechat.NotifyResponse{ReturnCode: gopay.SUCCESS, ReturnMsg: "OK"})
}
