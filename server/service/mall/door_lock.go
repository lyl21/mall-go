package mall

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/flipped-aurora/gin-vue-admin/server/wsmanager"
	"go.uber.org/zap"
)

type DoorLockService struct{}

var DoorLockServiceApp = new(DoorLockService)

func (s *DoorLockService) CreateDoorLock(lock mallModel.DoorLock) (err error) {
	err = global.GVA_DB.Create(&lock).Error
	return err
}

func (s *DoorLockService) DeleteDoorLock(id int64) (err error) {
	err = global.GVA_DB.Model(&mallModel.DoorLock{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *DoorLockService) UpdateDoorLock(lock mallModel.DoorLock) (err error) {
	err = global.GVA_DB.Model(&mallModel.DoorLock{}).Where("id = ?", lock.Id).Updates(&lock).Error
	return err
}

func (s *DoorLockService) GetDoorLock(id int64) (lock mallModel.DoorLock, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&lock).Error
	return
}

func (s *DoorLockService) GetDoorLockList(info request.PageInfo, doorName string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.DoorLock{}).Where("del_flag = ?", "0")
	if doorName != "" {
		db = db.Where("door_name LIKE ?", "%"+doorName+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var lockList []mallModel.DoorLock
	err = db.Limit(limit).Offset(offset).Find(&lockList).Error
	return lockList, total, err
}

// OpenDoor 远程开门（完整流程：远程开门 → 记录历史 → 同步用户 → WS通知门店）
func (s *DoorLockService) OpenDoor(id int64, openId string) (string, error) {
	// 1. 查询门锁信息
	var doorLock mallModel.DoorLock
	err := global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&doorLock).Error
	if err != nil {
		return "", errors.New("门锁不存在")
	}

	// 2. 校验必要参数
	if doorLock.YardSn == nil || *doorLock.YardSn == "" {
		return "", errors.New("请先绑定门店")
	}
	if doorLock.DoorGuid == nil || *doorLock.DoorGuid == "" {
		return "", errors.New("请先绑定门锁")
	}

	doorGuid := *doorLock.DoorGuid

	// 3. 调用第三方接口远程开门
	result, err := s.doorRemote(doorGuid)
	if err != nil {
		global.GVA_LOG.Error("远程开门失败", zap.Error(err))
		result = fmt.Sprintf("error: %v", err)
	}

	// 4. 记录操作历史
	history := mallModel.DoorLockHistory{
		YardSn:     doorLock.YardSn,
		DoorGuid:   &doorGuid,
		Operation:  stringPtr("open"),
		Response:   &result,
		DetailInfo: doorLock.DetailInfo,
		OpenId:     &openId,
	}
	err = global.GVA_DB.Create(&history).Error
	if err != nil {
		global.GVA_LOG.Error("记录操作历史失败", zap.Error(err))
	}

	// 5. 查询微信用户信息
	var wxUser wechatModel.WxUser
	if err := global.GVA_DB.Where("open_id = ? AND del_flag = ?", openId, "0").First(&wxUser).Error; err != nil {
		global.GVA_LOG.Warn("未找到微信用户", zap.String("openId", openId))
		return result, nil
	}

	phone := ""
	if wxUser.Phone != nil {
		phone = *wxUser.Phone
	}
	if phone == "" {
		return "", errors.New("请先在小程序中授权绑定手机号后再开门")
	}

	// 同步更新 WxUser 的手机号（双向关联）
	if wxUser.Phone == nil || *wxUser.Phone == "" {
		global.GVA_DB.Model(&wxUser).Update("phone", phone)
	}
	wxNickName := ""
	if wxUser.NickName != nil {
		wxNickName = *wxUser.NickName
	}

	// 6. 根据门禁ID查找门店（brandId 即 doorGuid）
	mxStore, err := storeService.StoreServiceApp.GetMxStoreByBrandId(doorGuid)
	if err != nil {
		global.GVA_LOG.Warn("未找到对应门店", zap.String("doorGuid", doorGuid))
		return result, nil
	}

	// 7. 根据手机号查找或创建门店用户（MxUser）
	var mxUser storeModel.MxUser
	err = global.GVA_DB.Where("phone_number = ? AND is_delete = ?", phone, 0).First(&mxUser).Error
	if err != nil {
		// 新用户：创建 MxUser
		mxUser = storeModel.MxUser{
			PhoneNumber: phone,
			Password:    "123456", // 默认密码
			Name:        wxNickName,
			Wechat:      openId,
			Openid:      openId,
		}
		if wxUser.Sex != nil && *wxUser.Sex == "1" {
			mxUser.Gender = 1
		}
		if wxUser.UnionId != nil {
			mxUser.Unionid = *wxUser.UnionId
		}
		if err := global.GVA_DB.Create(&mxUser).Error; err != nil {
			global.GVA_LOG.Error("创建门店用户失败", zap.Error(err))
		}
	} else {
		// 已有用户：更新微信信息
		updates := map[string]interface{}{
			"wechat": openId,
			"openid": openId,
		}
		if wxNickName != "" && mxUser.Name == "" {
			updates["name"] = wxNickName
		}
		if wxUser.UnionId != nil {
			updates["unionid"] = *wxUser.UnionId
		}
		global.GVA_DB.Model(&mxUser).Updates(updates)
	}

	// 8. 添加门店成员关系（顾客角色 post=3）
	var existMember storeModel.MxStoreMember
	err = global.GVA_DB.Where("store_id = ? AND user_id = ? AND post = ? AND is_delete = ?",
		mxStore.StoreId, mxUser.UserId, 3, 0).First(&existMember).Error
	if err != nil {
		// 不存在则创建
		member := storeModel.MxStoreMember{
			StoreId: mxStore.StoreId,
			UserId:  mxUser.UserId,
			Post:    3, // 顾客
		}
		if err := global.GVA_DB.Create(&member).Error; err != nil {
			global.GVA_LOG.Error("添加门店成员失败", zap.Error(err))
		}
	}

	// 9. 通过 WebSocket 异步通知门店店长和验光师
	openDoorNotify := map[string]interface{}{
		"id":          mxUser.UserId,
		"doorGuid":    doorGuid,
		"openId":      openId,
		"name":        mxUser.Name,
		"phoneNumber": phone,
		"gender":      mxUser.Gender,
		"storeId":     mxStore.StoreId,
	}
	go func() {
		defer func() {
			if r := recover(); r != nil {
				global.GVA_LOG.Error("开门通知WS goroutine panic",
					zap.Any("panic", r),
					zap.Int64("storeId", mxStore.StoreId))
			}
		}()
		wsmanager.WSManager.SendOpenDoorNotify(mxStore.StoreId, openDoorNotify)
	}()

	return result, nil
}

// doorRemote 调用第三方接口远程开门
func (s *DoorLockService) doorRemote(doorGuid string) (string, error) {
	cfg := global.GVA_CONFIG.DoorLock
	baseURL := cfg.BaseURL
	if baseURL == "" {
		baseURL = "https://yun.andudu.net/dist"
	}

	// 1. 登录获取 token
	loginURL := baseURL + "/sess/check-login"
	loginBody := map[string]string{
		"username": cfg.Username,
		"password": cfg.Password,
	}
	loginJSON, _ := json.Marshal(loginBody)

	resp, err := http.Post(loginURL, "application/json", bytes.NewBuffer(loginJSON))
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	var loginResp struct {
		Code int `json:"code"`
		Data struct {
			Token string `json:"token"`
		} `json:"data"`
	}
	if err := json.Unmarshal(body, &loginResp); err != nil {
		return "", err
	}
	token := loginResp.Data.Token

	// 2. 调用开门接口
	openURL := baseURL + "/device/door-remote"
	gyscode := cfg.Gyscode
	if gyscode == "" {
		gyscode = "hyzh"
	}
	openBody := map[string]string{
		"yard_sn":      cfg.YardSn,
		"door_sn":      doorGuid,
		"door_gyscode": gyscode,
		"cmd_type":     "open",
	}
	openJSON, _ := json.Marshal(openBody)

	req, _ := http.NewRequest("POST", openURL, bytes.NewBuffer(openJSON))
	req.Header.Set("token", token)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err = client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, _ = io.ReadAll(resp.Body)
	var openResp struct {
		Code string `json:"code"`
	}
	if err := json.Unmarshal(body, &openResp); err != nil {
		return string(body), nil
	}

	return openResp.Code, nil
}

func stringPtr(s string) *string {
	return &s
}
