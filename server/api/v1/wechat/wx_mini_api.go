package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

type WxMiniApi struct{}

// MiniLogin 小程序登录
// @Tags      WxMini
// @Summary   微信小程序登录（code换取openid）
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{code=string}             true  "微信登录code"
// @Success   200   {object}  response.Response{data=object}  "登录成功，返回用户信息"
// @Router    /mini/login [post]
func (a *WxMiniApi) MiniLogin(c *gin.Context) {
	var req struct {
		Code string `json:"code" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}
	result, err := wxMiniService.MiniLogin(req.Code)
	if err != nil {
		global.GVA_LOG.Error("小程序登录失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithDetailed(result, "登录成功", c)
}

// GetMyOptometryRecords 获取当前微信用户的验光记录
// @Tags      WxMini
// @Summary   小程序获取我的验光记录
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     openId  query     string                                             true  "微信openId"
// @Success   200     {object}  response.Response{data=object}                     "获取成功"
// @Router    /mini/myOptometryRecords [get]
func (a *WxMiniApi) GetMyOptometryRecords(c *gin.Context) {
	openId := c.Query("openId")
	if openId == "" {
		response.FailWithMessage("openId不能为空", c)
		return
	}
	records, err := wxMiniService.GetMyOptometryRecords(openId)
	if err != nil {
		global.GVA_LOG.Error("获取验光记录失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithDetailed(gin.H{"list": records, "total": len(records)}, "获取成功", c)
}

// BindPhone 绑定手机号
// @Tags      WxMini
// @Summary   小程序绑定手机号
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{openId=string,phone=string}  true  "openId与手机号"
// @Success   200   {object}  response.Response{msg=string}       "绑定成功"
// @Router    /mini/bindPhone [post]
func (a *WxMiniApi) BindPhone(c *gin.Context) {
	var req struct {
		OpenId string `json:"openId" binding:"required"`
		Phone  string `json:"phone"  binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}
	if err := wxMiniService.BindPhone(req.OpenId, req.Phone); err != nil {
		global.GVA_LOG.Error("绑定手机号失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithMessage("绑定成功", c)
}
