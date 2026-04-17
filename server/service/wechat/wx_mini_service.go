package wechat

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/google/uuid"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
)

type WxMiniService struct{}

var WxMiniServiceApp = new(WxMiniService)

// wxCode2SessionResp 微信 jscode2session 响应
type wxCode2SessionResp struct {
	OpenID     string `json:"openid"`
	SessionKey string `json:"session_key"`
	UnionID    string `json:"unionid"`
	ErrCode    int    `json:"errcode"`
	ErrMsg     string `json:"errmsg"`
}

// MiniLoginResult 小程序登录结果
type MiniLoginResult struct {
	WxUser    wechatModel.WxUser `json:"wxUser"`
	IsNewUser bool               `json:"isNewUser"`
}

// MiniLogin 小程序 code 换取 openid，找到或创建 WxUser
func (s *WxMiniService) MiniLogin(code string) (result MiniLoginResult, err error) {
	appID := global.GVA_CONFIG.WechatMiniProgram.AppID
	appSecret := global.GVA_CONFIG.WechatMiniProgram.AppSecret
	if appID == "" || appSecret == "" {
		err = errors.New("微信小程序 AppID/AppSecret 未配置，请在 config.yaml 中设置 wechat-mini-program")
		return
	}

	// 调用微信接口换取 openid
	url := fmt.Sprintf(
		"https://api.weixin.qq.com/sns/jscode2session?appid=%s&secret=%s&js_code=%s&grant_type=authorization_code",
		appID, appSecret, code,
	)
	resp, err := http.Get(url)
	if err != nil {
		err = fmt.Errorf("请求微信服务器失败: %w", err)
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		err = fmt.Errorf("读取微信响应失败: %w", err)
		return
	}

	var wxResp wxCode2SessionResp
	if err = json.Unmarshal(body, &wxResp); err != nil {
		err = fmt.Errorf("解析微信响应失败: %w", err)
		return
	}
	if wxResp.ErrCode != 0 {
		err = fmt.Errorf("微信接口错误 errcode=%d: %s", wxResp.ErrCode, wxResp.ErrMsg)
		return
	}

	// 查找或创建 WxUser
	var user wechatModel.WxUser
	dbErr := global.GVA_DB.Where("open_id = ? AND del_flag = '0'", wxResp.OpenID).First(&user).Error
	if dbErr != nil {
		// 新用户
		now := time.Now()
		appType := "1" // 小程序
		subscribe := "0"
		user = wechatModel.WxUser{
			Id:          newUserID(),
			OpenId:      wxResp.OpenID,
			AppType:     &appType,
			Subscribe:   &subscribe,
			SubscribeTime: &now,
		}
		if wxResp.UnionID != "" {
			user.UnionId = &wxResp.UnionID
		}
		if wxResp.SessionKey != "" {
			user.SessionKey = &wxResp.SessionKey
		}
		if err = global.GVA_DB.Create(&user).Error; err != nil {
			err = fmt.Errorf("创建微信用户失败: %w", err)
			return
		}
		result.IsNewUser = true
	} else {
		// 老用户，更新 session_key
		if wxResp.SessionKey != "" {
			global.GVA_DB.Model(&user).Update("session_key", wxResp.SessionKey)
			user.SessionKey = &wxResp.SessionKey
		}
	}
	result.WxUser = user
	return
}

// GetMyOptometryRecords 根据 openid 查询该微信用户绑定客户的所有验光记录
// 关联路径：WxUser.Phone → MxUser.PhoneNumber → OptometryRecord.CustomerId
func (s *WxMiniService) GetMyOptometryRecords(openId string) (records []optometryModel.OptometryRecord, err error) {
	// 1. 找到 WxUser
	var wxUser wechatModel.WxUser
	if err = global.GVA_DB.Where("open_id = ? AND del_flag = '0'", openId).First(&wxUser).Error; err != nil {
		err = errors.New("未找到微信用户，请先完成登录绑定")
		return
	}

	// 2. 通过手机号找到门店用户（MxUser）
	phone := ""
	if wxUser.Phone != nil {
		phone = *wxUser.Phone
	}
	if phone == "" {
		// 手机号未绑定，无法关联验光记录
		records = []optometryModel.OptometryRecord{}
		return
	}

	var mxUser storeModel.MxUser
	if err = global.GVA_DB.Where("phone_number = ? AND is_delete = 0", phone).First(&mxUser).Error; err != nil {
		records = []optometryModel.OptometryRecord{}
		err = nil // 无对应门店客户，不报错，返回空列表
		return
	}

	// 3. 查询验光记录，按时间倒序，预加载关联数据
	err = global.GVA_DB.
		Where("customer_id = ? AND is_delete = 0", mxUser.UserId).
		Preload("DataList").
		Preload("VisionResult").
		Preload("VisionResult.TryOptometryList").
		Order("create_time DESC").
		Find(&records).Error
	return
}

// BindPhone 小程序绑定手机号（微信解密后得到真实手机号）
func (s *WxMiniService) BindPhone(openId, phone string) (err error) {
	if openId == "" || phone == "" {
		return errors.New("openId 和手机号不能为空")
	}
	err = global.GVA_DB.Model(&wechatModel.WxUser{}).
		Where("open_id = ? AND del_flag = '0'", openId).
		Update("phone", phone).Error
	return
}

// newUserID 生成唯一用户 ID（UUID，去掉连字符共 32 字符）
func newUserID() string {
	return fmt.Sprintf("%x", [16]byte(uuid.New()))
}
