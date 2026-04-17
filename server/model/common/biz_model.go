package common

import (
	"gorm.io/gorm"
)

// BizModel ry 项目业务表通用字段（create_time/update_time + is_delete）
type BizModel struct {
	CreateTime DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime"`
	UpdateTime DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime"`
}

// NotDelete 软删除过滤（ry 使用 is_delete int(1) 0=未删 1=已删）
func NotDeleted(db *gorm.DB) *gorm.DB {
	return db.Where("is_delete = ?", 0)
}
