package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
)

type MiniWxUserApi struct{}

// WxUserLogin 小程序登录（code换取openid）
// @Tags      MiniWxUser
// @Summary   小程序登录
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{code=string}             true  "微信登录code"
// @Success   200   {object}  response.Response{data=object}  "登录成功，返回用户信息"
// @Router    /weixin/api/ma/wxuser/login [post]
func (a *MiniWxUserApi) WxUserLogin(c *gin.Context) {
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

// WxUserGet 获取当前微信用户信息（从JWT中获取wxUserId）
// @Tags      MiniWxUser
// @Summary   获取微信用户信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200   {object}  response.Response{data=object}  "获取成功"
// @Router    /weixin/api/ma/wxuser [get]
func (a *MiniWxUserApi) WxUserGet(c *gin.Context) {
	wxUserId, exists := c.Get("wxUserId")
	if !exists {
		response.FailWithMessage("未获取到用户信息", c)
		return
	}
	wxUserIdStr, ok := wxUserId.(string)
	if !ok || wxUserIdStr == "" {
		response.FailWithMessage("用户信息异常", c)
		return
	}

	user, err := wxUserService.GetWxUser(wxUserIdStr)
	if err != nil {
		global.GVA_LOG.Error("获取用户信息失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithDetailed(user, "获取成功", c)
}

// WxUserSave 保存/更新微信用户信息
// @Tags      MiniWxUser
// @Summary   保存微信用户信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechat.WxUser  true  "微信用户信息"
// @Success   200   {object}  response.Response{msg=string}  "保存成功"
// @Router    /weixin/api/ma/wxuser [post]
func (a *MiniWxUserApi) WxUserSave(c *gin.Context) {
	var req wechat.WxUser
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 获取当前登录用户的 wxUserId
	wxUserId, exists := c.Get("wxUserId")
	if !exists {
		response.FailWithMessage("未获取到用户信息", c)
		return
	}
	wxUserIdStr, ok := wxUserId.(string)
	if !ok || wxUserIdStr == "" {
		response.FailWithMessage("用户信息异常", c)
		return
	}

	// 设置用户Id
	req.Id = wxUserIdStr

	if err := wxUserService.UpdateWxUser(req); err != nil {
		global.GVA_LOG.Error("保存用户信息失败", zap.Error(err))
		response.FailWithMessage(err.Error(), c)
		return
	}
	response.OkWithMessage("保存成功", c)
}

// WxUserLogout 小程序退出登录
// @Tags      MiniWxUser
// @Summary   小程序退出登录
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{msg=string}  "退出成功"
// @Router    /weixin/api/ma/wxuser/logout [post]
func (a *MiniWxUserApi) WxUserLogout(c *gin.Context) {
	token := middleware.GetMiniToken(c)
	if token != "" {
		utils.ClearMiniToken(token)
	}
	response.OkWithMessage("退出成功", c)
}
