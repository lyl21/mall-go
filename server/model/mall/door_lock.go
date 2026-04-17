package mall

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// DoorLock 门锁表（从Java实体重建，无SQL建表语句）
type DoorLock struct {
	Id           int64           `json:"id" gorm:"column:id;primaryKey;autoIncrement;comment:门锁id"`
	YardSn       *string         `json:"yardSn" gorm:"column:yard_sn;comment:园区sn（第三方）"`
	DoorGuid     *string         `json:"doorGuid" gorm:"column:door_guid;comment:门禁id（第三方）"`
	DoorName     *string         `json:"doorName" gorm:"column:door_name;comment:门禁名称（第三方）"`
	DelFlag      string          `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	ProvinceName *string         `json:"provinceName" gorm:"column:province_name;comment:省名"`
	CityName     *string         `json:"cityName" gorm:"column:city_name;comment:市名"`
	CountyName   *string         `json:"countyName" gorm:"column:county_name;comment:区名"`
	DetailInfo   *string         `json:"detailInfo" gorm:"column:detail_info;comment:详情地址"`
	CreateTime   common.DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime   common.DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
}

func (DoorLock) TableName() string { return "door_lock" }
