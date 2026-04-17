package common

import (
	"time"

	"gorm.io/gorm"
)

// MallModel mall 项目业务表通用字段（create_time/update_time + del_flag）
type MallModel struct {
	CreateTime time.Time `json:"createTime" gorm:"column:create_time;autoCreateTime"`
	UpdateTime time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime"`
	DelFlag    string    `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0'"`
}

// NotDelMall 软删除过滤（mall 使用 del_flag char(2) 0=显示 1=隐藏）
func NotDelMall(db *gorm.DB) *gorm.DB {
	return db.Where("del_flag = ?", "0")
}
