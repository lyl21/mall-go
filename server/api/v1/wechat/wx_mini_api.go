package wechat

import (
	"regexp"

	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
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

// MiniLogout 小程序退出登录
// @Tags      WxMini
// @Summary   微信小程序退出登录（清除JWT Token）
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{msg=string}  "退出成功"
// @Router    /mini/logout [post]
func (a *WxMiniApi) MiniLogout(c *gin.Context) {
	token := middleware.GetMiniToken(c)
	if token != "" {
		utils.ClearMiniToken(token)
	}
	response.OkWithMessage("退出成功", c)
}

// GetMyOptometryRecords 获取当前微信用户的验光记录（从JWT中获取openId）
// @Tags      WxMini
// @Summary   小程序获取我的验光记录
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200     {object}  response.Response{data=object}                     "获取成功"
// @Router    /mini/myOptometryRecords [get]
func (a *WxMiniApi) GetMyOptometryRecords(c *gin.Context) {
	openId, exists := c.Get("openId")
	if !exists {
		response.FailWithMessage("未获取到用户信息", c)
		return
	}
	openIdStr, ok := openId.(string)
	if !ok || openIdStr == "" {
		response.FailWithMessage("用户信息异常", c)
		return
	}
	records, err := wxMiniService.GetMyOptometryRecords(openIdStr)
	if err != nil {
		global.GVA_LOG.Error("获取验光记录失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithDetailed(gin.H{"list": records, "total": len(records)}, "获取成功", c)
}

// BindPhone 绑定手机号（从JWT中获取openId）
// @Tags      WxMini
// @Summary   小程序绑定手机号
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{phone=string}  true  "手机号"
// @Success   200   {object}  response.Response{msg=string}       "绑定成功"
// @Router    /mini/bindPhone [post]
func (a *WxMiniApi) BindPhone(c *gin.Context) {
	var req struct {
		Phone string `json:"phone" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 校验手机号格式（中国大陆手机号）
	mobileReg := regexp.MustCompile(`^1[3-9]\d{9}$`)
	if !mobileReg.MatchString(req.Phone) {
		response.FailWithMessage("手机号格式不正确", c)
		return
	}

	openId, exists := c.Get("openId")
	if !exists {
		response.FailWithMessage("未获取到用户信息", c)
		return
	}
	openIdStr, ok := openId.(string)
	if !ok || openIdStr == "" {
		response.FailWithMessage("用户信息异常", c)
		return
	}

	if err := wxMiniService.BindPhone(openIdStr, req.Phone); err != nil {
		global.GVA_LOG.Error("绑定手机号失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithMessage("绑定成功", c)
}
