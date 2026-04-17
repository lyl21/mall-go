package store

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
)

type ActivationCodeService struct{}

var ActivationCodeServiceApp = new(ActivationCodeService)

const (
	activationKey      = "uujjljkaahhznzkkassndasn,hasgsjadkasjkjxbz,,kajdl1shak1"
	activationPkgName  = "com.dongdialog.ks"
)

func (s *ActivationCodeService) CreateMxActivationCode(code storeModel.MxActivationCode) (err error) {
	err = global.GVA_DB.Create(&code).Error
	return err
}

func (s *ActivationCodeService) DeleteMxActivationCode(code storeModel.MxActivationCode) (err error) {
	err = global.GVA_DB.Delete(&code).Error
	return err
}

func (s *ActivationCodeService) UpdateMxActivationCode(code storeModel.MxActivationCode) (err error) {
	// 只更新允许编辑的字段
	updateData := map[string]interface{}{
		"device_name":     code.DeviceName,
		"device_location": code.DeviceLocation,
		"remark":          code.Remark,
	}
	// 使用 Table 明确指定表名，避免 GORM 的命名转换问题
	err = global.GVA_DB.Table("mx_activation_code").Where("activation_id = ?", code.ActivationId).Updates(updateData).Error
	return err
}

func (s *ActivationCodeService) GetMxActivationCode(id int64) (code storeModel.MxActivationCode, err error) {
	err = global.GVA_DB.Where("activation_id = ?", id).First(&code).Error
	return
}

func (s *ActivationCodeService) GetMxActivationCodeList(info request.PageInfo) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&storeModel.MxActivationCode{})
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var codeList []storeModel.MxActivationCode
	err = db.Limit(limit).Offset(offset).Find(&codeList).Error
	return codeList, total, err
}

func (s *ActivationCodeService) GenerateActivationCode(app, equipment string) (activationCode string, err error) {
	raw := activationKey + activationPkgName + equipment + app
	hash := md5.Sum([]byte(raw))
	code := fmt.Sprintf("%08s", hex.EncodeToString(hash[:])[:8])

	var existing storeModel.MxActivationCode
	err = global.GVA_DB.Where("app = ? AND equipment = ?", app, equipment).First(&existing).Error
	if err != nil {
		newCode := storeModel.MxActivationCode{
			App:            app,
			Equipment:      equipment,
			ActivationCode: code,
		}
		if createErr := global.GVA_DB.Create(&newCode).Error; createErr != nil {
			return "", createErr
		}
		return code, nil
	}
	err = global.GVA_DB.Model(&existing).Update("activation_code", code).Error
	if err != nil {
		return "", err
	}
	return code, nil
}
