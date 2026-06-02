package wechat

import (
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
	"gorm.io/gorm"
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
		response.FailWithBadRequest("参数错误", c)
		return
	}

	// 查找或注册用户
	wxUser, regErr := findOrCreateWxUser(openid)
	if regErr != nil {
		global.GVA_LOG.Error("查找或注册用户失败", zap.String("openid", openid), zap.Error(regErr))
		response.FailWithMessage("用户注册失败", c)
		return
	}

	// 如果用户已有手机号，直接返回
	if wxUser.Phone != nil && *wxUser.Phone != "" {
		response.OkWithDetailed(gin.H{"phone": *wxUser.Phone}, "获取成功", c)
		return
	}

	// 调用微信API获取手机号
	phone, phoneErr := wxMiniService.GetPhoneNumber(code)
	if phoneErr != nil {
		global.GVA_LOG.Error("微信获取手机号失败", zap.String("openid", openid), zap.Error(phoneErr))
		response.FailWithBadRequest("获取手机号失败，请重试", c)
		return
	}

	// 将手机号关联到用户
	if phone != "" {
		if updateErr := global.GVA_DB.Model(&wechat.WxUser{}).Where("open_id = ?", openid).Update("phone", phone).Error; updateErr != nil {
			global.GVA_LOG.Error("更新用户手机号失败", zap.String("openid", openid), zap.Error(updateErr))
		}
	}

	response.OkWithDetailed(gin.H{"phone": phone}, "获取成功", c)
}

// findOrCreateWxUser 查找用户，不存在则自动注册
func findOrCreateWxUser(openid string) (wxUser wechat.WxUser, err error) {
	dbErr := global.GVA_DB.Where("open_id = ? AND del_flag = '0'", openid).First(&wxUser).Error
	if dbErr != nil && !isRecordNotFound(dbErr) {
		err = dbErr
		return
	}

	if isRecordNotFound(dbErr) {
		// 新用户，自动注册
		now := time.Now()
		appType := "1"
		subscribe := "0"
		wxUser = wechat.WxUser{
			Id:            newUserID(),
			OpenId:        openid,
			AppType:       &appType,
			Subscribe:     &subscribe,
			SubscribeTime: &now,
		}
		if createErr := global.GVA_DB.Create(&wxUser).Error; createErr != nil {
			err = createErr
			return
		}
		global.GVA_LOG.Info("自动注册新用户", zap.String("openid", openid), zap.String("userId", wxUser.Id))
	}

	return
}

// isRecordNotFound 判断是否为记录不存在错误
func isRecordNotFound(err error) bool {
	return err != nil && err == gorm.ErrRecordNotFound
}

// newUserID 生成唯一用户ID（UUID，去掉连字符共32字符）
func newUserID() string {
	return fmt.Sprintf("%x", [16]byte(uuid.New()))
}
