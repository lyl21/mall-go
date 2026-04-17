package mall

import (
	"bytes"
	"encoding/json"
	"errors"
	"io"
	"net/http"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type DoorLockService struct{}

var DoorLockServiceApp = new(DoorLockService)

// 第三方平台配置
const (
	doorLockBaseURL      = "https://yun.andudu.net/dist"
	doorLockUsername     = "18136108622"
	doorLockPassword     = "123456"
	doorLockYardSn       = "786537017627385856"
	doorLockGyscode      = "hyzh"
	optometryAppBaseURL  = "http://localhost:8083/client"
)

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

// OpenDoor 远程开门
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
		// 继续记录历史，但返回错误
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

	return result, nil
}

// doorRemote 调用第三方接口远程开门
func (s *DoorLockService) doorRemote(doorGuid string) (string, error) {
	// 1. 登录获取 token
	loginURL := doorLockBaseURL + "/sess/check-login"
	loginBody := map[string]string{
		"username": doorLockUsername,
		"password": doorLockPassword,
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
	openURL := doorLockBaseURL + "/device/door-remote"
	openBody := map[string]string{
		"yard_sn":      doorLockYardSn,
		"door_sn":      doorGuid,
		"door_gyscode": doorLockGyscode,
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
