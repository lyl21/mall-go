package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
)

type ErrorReportLogService struct{}

var ErrorReportLogServiceApp = new(ErrorReportLogService)

func (s *ErrorReportLogService) GetErrorReportLogList(info request.PageInfo, equipmentId string, createTime string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)

	if limit == 0 {
		limit = 10000
	}

	db := global.GVA_DB.Model(&storeModel.ErrorReportLog{})
	if equipmentId != "" {
		db = db.Where("equipment_id LIKE ?", "%"+equipmentId+"%")
	}
	if createTime != "" {
		db = db.Where("DATE(create_time) = ?", createTime)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}

	var logList []storeModel.ErrorReportLog
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&logList).Error
	return logList, total, err
}

func (s *ErrorReportLogService) GetErrorReportLog(id int64) (log storeModel.ErrorReportLog, err error) {
	err = global.GVA_DB.Where("error_report_log_id = ?", id).First(&log).Error
	return
}

func (s *ErrorReportLogService) DeleteErrorReportLog(id int64) (err error) {
	err = global.GVA_DB.Where("error_report_log_id = ?", id).Delete(&storeModel.ErrorReportLog{}).Error
	return
}

func (s *ErrorReportLogService) DeleteErrorReportLogByIds(ids []int64) (err error) {
	err = global.GVA_DB.Where("error_report_log_id IN ?", ids).Delete(&storeModel.ErrorReportLog{}).Error
	return
}
