package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
)

type OptometryRecordService struct{}

var OptometryRecordServiceApp = new(OptometryRecordService)

func (s *OptometryRecordService) CreateOptometryRecord(record optometryModel.OptometryRecord) (err error) {
	err = global.GVA_DB.Create(&record).Error
	return err
}

func (s *OptometryRecordService) DeleteOptometryRecord(id int64) (err error) {
	err = global.GVA_DB.Model(&optometryModel.OptometryRecord{}).Where("optometry_records_id = ?", id).Update("is_delete", 1).Error
	return err
}

func (s *OptometryRecordService) UpdateOptometryRecord(record optometryModel.OptometryRecord) (err error) {
	err = global.GVA_DB.Model(&record).Where("optometry_records_id = ?", record.OptometryRecordsId).Updates(&record).Error
	return err
}

func (s *OptometryRecordService) GetOptometryRecord(id int64) (record optometryModel.OptometryRecord, err error) {
	err = global.GVA_DB.Where("optometry_records_id = ? AND is_delete = ?", id, 0).First(&record).Error
	return
}

func (s *OptometryRecordService) GetOptometryRecordList(pageInfo request.PageInfo, search optometryModel.OptometryRecord) (list []optometryModel.OptometryRecord, total int64, err error) {
	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)
	db := global.GVA_DB.Model(&optometryModel.OptometryRecord{}).Where("is_delete = ?", 0)

	if search.CustomerName != "" {
		db = db.Where("customer_name LIKE ?", "%"+search.CustomerName+"%")
	}
	if search.StoreId != 0 {
		db = db.Where("store_id = ?", search.StoreId)
	}
	if search.OptometristId != 0 {
		db = db.Where("optometrist_id = ?", search.OptometristId)
	}
	if search.CustomerId != nil && *search.CustomerId != 0 {
		db = db.Where("customer_id = ?", *search.CustomerId)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&list).Error
	return
}
