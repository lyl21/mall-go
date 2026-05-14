package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// ErrorReportLog 错误报告日志表
type ErrorReportLog struct {
	ErrorReportLogId int64           `json:"errorReportLogId" gorm:"column:error_report_log_id;primaryKey;autoIncrement;comment:错误日志报告ID"`
	LogId            string          `json:"logId" gorm:"column:log_id;type:varchar(64);index;comment:日志ID"`
	EquipmentId      string          `json:"equipmentId" gorm:"column:equipment_id;type:varchar(100);index;comment:设备ID"`
	LogPath          string          `json:"logPath" gorm:"column:log_path;type:varchar(500);comment:日志路径或内容"`
	CreateTime       common.BizModel `gorm:"embedded"`
}

func (ErrorReportLog) TableName() string { return "error_report_log" }
