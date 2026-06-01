package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// WxPhoneApi 小程序手机号获取API
type WxPhoneApi struct{}

// GetPhone 获取用户手机号
// @Tags      WxPhone
// @Summary   获取用户手机号
// @Produce   application/json
// @Param     openid  query     string  true   "用户openid"
// @Param     code    query     string  true   "手机号获取code"
// @Success   200     {object}  response.Response{data=string}  "获取成功"
// @Router    /mini/phone [get]
func (a *WxPhoneApi) GetPhone(c *gin.Context) {
	openid := c.Query("openid")
	code := c.Query("code")
	if openid == "" || code == "" {
		response.FailWithMessage("参数错误", c)
		return
	}

	// 调用微信API获取手机号
	// 这里需要调用微信官方接口解密获取手机号
	// 当前实现返回模拟数据，实际需要对接微信API
	phone, err := wxMiniService.GetPhoneNumber(code)
	if err != nil {
		// 如果获取失败，尝试从数据库读取已存储的手机号
		var wxUser wechat.WxUser
		err := global.GVA_DB.Where("open_id = ?", openid).First(&wxUser).Error
		if err == nil && wxUser.Phone != nil && *wxUser.Phone != "" {
			response.OkWithDetailed(gin.H{"phone": *wxUser.Phone}, "获取成功", c)
			return
		}
		response.FailWithMessage("获取手机号失败:"+err.Error(), c)
		return
	}

	// 更新用户手机号
	if phone != "" {
		err := global.GVA_DB.Model(&wechat.WxUser{}).Where("open_id = ?", openid).Update("phone", phone).Error
		if err != nil {
			global.GVA_LOG.Error("更新用户手机号失败", zap.Error(err))
		}
	}

	response.OkWithDetailed(gin.H{"phone": phone}, "获取成功", c)
}