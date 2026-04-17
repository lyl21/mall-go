package store

import (
	"time"
)

// ErrorReportLog 错误报告日志表
type ErrorReportLog struct {
	LogId       string    `json:"logId" gorm:"column:log_id;primaryKey;type:varchar(64);comment:日志ID"`
	EquipmentId string    `json:"equipmentId" gorm:"column:equipment_id;type:varchar(100);comment:设备ID"`
	LogPath     string    `json:"logPath" gorm:"column:log_path;type:varchar(500);comment:日志路径或内容"`
	CreateTime  time.Time `json:"createTime" gorm:"column:create_time;comment:创建时间"`
}

func (ErrorReportLog) TableName() string { return "error_report_log" }
