package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// UserAddress 用户地址
type UserAddress struct {
	Id           string          `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	DelFlag      string          `json:"delFlag" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	UserId       string          `json:"userId" gorm:"column:user_id;type:varchar(32);not null;comment:用户编号"`
	UserName     string          `json:"userName" gorm:"column:user_name;type:varchar(50);comment:收货人名字"`
	PostalCode   string          `json:"postalCode" gorm:"column:postal_code;type:varchar(50);comment:邮编"`
	ProvinceName string          `json:"provinceName" gorm:"column:province_name;type:varchar(50);comment:省名"`
	CityName     string          `json:"cityName" gorm:"column:city_name;type:varchar(50);comment:市名"`
	CountyName   string          `json:"countyName" gorm:"column:county_name;type:varchar(50);comment:区名"`
	DetailInfo   string          `json:"detailInfo" gorm:"column:detail_info;type:varchar(255);comment:详情地址"`
	TelNum       string          `json:"telNum" gorm:"column:tel_num;type:varchar(50);comment:电话号码"`
	IsDefault    string          `json:"isDefault" gorm:"column:is_default;type:char(2);comment:是否默认 1是0否"`
	CreateTime   common.DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime   common.DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
}

func (UserAddress) TableName() string { return "user_address" }
