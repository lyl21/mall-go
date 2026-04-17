package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
)

type DoorLockHistoryService struct{}

var DoorLockHistoryServiceApp = new(DoorLockHistoryService)

func (s *DoorLockHistoryService) CreateDoorLockHistory(history mallModel.DoorLockHistory) (err error) {
	err = global.GVA_DB.Create(&history).Error
	return err
}

func (s *DoorLockHistoryService) DeleteDoorLockHistory(id int64) (err error) {
	err = global.GVA_DB.Where("id = ?", id).Delete(&mallModel.DoorLockHistory{}).Error
	return err
}

func (s *DoorLockHistoryService) UpdateDoorLockHistory(history mallModel.DoorLockHistory) (err error) {
	err = global.GVA_DB.Model(&mallModel.DoorLockHistory{}).Where("id = ?", history.Id).Updates(&history).Error
	return err
}

func (s *DoorLockHistoryService) GetDoorLockHistory(id int64) (history mallModel.DoorLockHistory, err error) {
	err = global.GVA_DB.Where("id = ?", id).First(&history).Error
	return
}

func (s *DoorLockHistoryService) GetDoorLockHistoryList(info request.PageInfo, doorGuid string, openId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.DoorLockHistory{})
	if doorGuid != "" {
		db = db.Where("door_guid = ?", doorGuid)
	}
	if openId != "" {
		db = db.Where("open_id = ?", openId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var historyList []mallModel.DoorLockHistory
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&historyList).Error
	return historyList, total, err
}
