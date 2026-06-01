package wechat

import (
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/google/uuid"
	"github.com/silenceper/wechat/v2"
	"github.com/silenceper/wechat/v2/miniprogram"
	miniProgramConfig "github.com/silenceper/wechat/v2/miniprogram/config"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type WxMiniService struct{}

var (
	WxMiniServiceApp = new(WxMiniService)
	miniProgramInst  *miniprogram.MiniProgram
	miniProgramMu    sync.Mutex
	miniProgramErr   error
)

// MiniLoginResult 小程序登录结果（不暴露 session_key）
type MiniLoginResult struct {
	Token     string       `json:"token"`
	WxUser    WxUserSafeVO `json:"wxUser"`
	IsNewUser bool         `json:"isNewUser"`
}

// WxUserSafeVO 前端安全的微信用户信息（不含敏感字段）
type WxUserSafeVO struct {
	Id         string    `json:"id"`
	OpenId     string    `json:"openId"`
	NickName   *string   `json:"nickName"`
	Sex        *string   `json:"sex"`
	Phone      *string   `json:"phone"`
	City       *string   `json:"city"`
	Province   *string   `json:"province"`
	Country    *string   `json:"country"`
	HeadimgUrl *string   `json:"headimgUrl"`
	UnionId    *string   `json:"unionId"`
	AppType    *string   `json:"appType"`
	CreateTime time.Time `json:"createTime"`
}

func toSafeWxUser(u wechatModel.WxUser) WxUserSafeVO {
	return WxUserSafeVO{
		Id:         u.Id,
		OpenId:     u.OpenId,
		NickName:   u.NickName,
		Sex:        u.Sex,
		Phone:      u.Phone,
		City:       u.City,
		Province:   u.Province,
		Country:    u.Country,
		HeadimgUrl: u.HeadimgUrl,
		UnionId:    u.UnionId,
		AppType:    u.AppType,
		CreateTime: u.CreateTime,
	}
}

// getMiniProgram 获取微信小程序实例（懒加载，失败可重试）
func (s *WxMiniService) getMiniProgram() (*miniprogram.MiniProgram, error) {
	miniProgramMu.Lock()
	defer miniProgramMu.Unlock()

	if miniProgramInst != nil {
		return miniProgramInst, nil
	}

	appID := global.GVA_CONFIG.WechatMiniProgram.AppID
	appSecret := global.GVA_CONFIG.WechatMiniProgram.AppSecret
	if appID == "" || appSecret == "" {
		miniProgramErr = errors.New("微信小程序 AppID/AppSecret 未配置，请在 config.yaml 中设置 wechat-mini-program")
		return nil, miniProgramErr
	}
	wc := wechat.NewWechat()
	cfg := &miniProgramConfig.Config{
		AppID:     appID,
		AppSecret: appSecret,
	}
	miniProgramInst = wc.GetMiniProgram(cfg)
	if miniProgramInst == nil {
		miniProgramErr = errors.New("微信小程序 SDK 初始化失败")
		return nil, miniProgramErr
	}
	miniProgramErr = nil
	return miniProgramInst, nil
}

// MiniLogin 小程序登录（按微信官方时序）
// 1. code 换取 openid + session_key
// 2. session_key 仅存数据库，不下发到前端（安全要求）
// 3. 生成 JWT Token 作为自定义登录态返回给前端
func (s *WxMiniService) MiniLogin(code string) (result MiniLoginResult, err error) {
	mp, err := s.getMiniProgram()
	if err != nil {
		return
	}

	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("微信小程序服务异常: %v", r)
			global.GVA_LOG.Error("MiniLogin panic recovered", zap.Any("panic", r))
		}
	}()

	auth := mp.GetAuth()
	session, err := auth.Code2Session(code)
	if err != nil {
		err = fmt.Errorf("微信 code2session 失败: %w", err)
		return
	}
	if session.ErrCode != 0 {
		err = fmt.Errorf("微信接口错误 errcode=%d: %s", session.ErrCode, session.ErrMsg)
		return
	}

	// 查找或创建 WxUser
	var user wechatModel.WxUser
	dbErr := global.GVA_DB.Where("open_id = ? AND del_flag = '0'", session.OpenID).First(&user).Error
	if dbErr != nil && !errors.Is(dbErr, gorm.ErrRecordNotFound) {
		// DB 连接等非预期错误，直接返回
		err = fmt.Errorf("查询微信用户失败: %w", dbErr)
		return
	}

	if errors.Is(dbErr, gorm.ErrRecordNotFound) {
		// 新用户
		now := time.Now()
		appType := "1"
		subscribe := "0"
		user = wechatModel.WxUser{
			Id:            newUserID(),
			OpenId:        session.OpenID,
			AppType:       &appType,
			Subscribe:     &subscribe,
			SubscribeTime: &now,
		}
		if session.UnionID != "" {
			user.UnionId = &session.UnionID
		}
		if session.SessionKey != "" {
			user.SessionKey = &session.SessionKey
		}
		if err = global.GVA_DB.Create(&user).Error; err != nil {
			err = fmt.Errorf("创建微信用户失败: %w", err)
			return
		}
		result.IsNewUser = true
	} else {
		// 老用户，更新 session_key（仅存数据库）
		if session.SessionKey != "" {
			if updateErr := global.GVA_DB.Model(&user).Update("session_key", session.SessionKey).Error; updateErr != nil {
				global.GVA_LOG.Error("更新session_key失败", zap.Error(updateErr))
			}
		}
	}

	// 生成自定义登录态 JWT Token（含 openId + wxUserId）
	token, err := utils.GenerateMiniToken(session.OpenID, user.Id)
	if err != nil {
		err = fmt.Errorf("生成登录Token失败: %w", err)
		return
	}

	result.Token = token
	result.WxUser = toSafeWxUser(user)
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

// GetPhoneNumber 使用微信手机号获取code换取真实手机号
func (s *WxMiniService) GetPhoneNumber(code string) (phone string, err error) {
	mp, err := s.getMiniProgram()
	if err != nil {
		return
	}

	// 调用微信接口获取手机号
	// 注意：微信手机号获取需要使用用户授权的 code，通过 cloudbase 或直接调用解密接口
	// 这里实现一个简单版本，实际生产需要根据微信官方文档实现解密逻辑
	// 参考：https://developers.weixin.qq.com/miniprogram/dev/api-backend/open-api/user-info/auth.getPhoneNumber.html

	// 当前返回模拟数据，实际项目需要对接微信官方接口
	// 解密需要 session_key，需要从数据库获取用户的 session_key
	_ = mp
	_ = code

	// 返回空，让调用方从数据库读取已存储的手机号
	return "", errors.New("未实现微信手机号解密，请先通过其他方式绑定手机号")
}

// newUserID 生成唯一用户 ID（UUID，去掉连字符共 32 字符）
func newUserID() string {
	return fmt.Sprintf("%x", [16]byte(uuid.New()))
}
