package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// MxActivationCode 设备激活码表
type MxActivationCode struct {
	ActivationId    int64            `json:"activationId" gorm:"column:activation_id;primaryKey;autoIncrement;comment:激活码ID"`
	CreateTime      common.BizModel  `gorm:"embedded"`
	App             string           `json:"app" gorm:"column:app;type:varchar(100);comment:应用名称"`
	Equipment       string           `json:"equipment" gorm:"column:equipment;type:varchar(255);uniqueIndex:unique_equipment_app;comment:设备id"`
	ActivationCode  string           `json:"activationCode" gorm:"column:activation_code;type:varchar(255);comment:激活码"`
	OnlineStatus    int              `json:"onlineStatus" gorm:"column:online_status;type:int(1);default:0;comment:在线状态0离线1在线"`
	LastOnlineTime  *common.DateTime `json:"lastOnlineTime" gorm:"column:last_online_time;comment:最后在线时间"`
	DeviceName      string           `json:"deviceName" gorm:"column:device_name;type:varchar(100);default:'';comment:设备名称"`
	DeviceLocation  string           `json:"deviceLocation" gorm:"column:device_location;type:varchar(200);default:'';comment:设备位置"`
	Remark          string           `json:"remark" gorm:"column:remark;type:varchar(500);default:'';comment:备注"`
}

func (MxActivationCode) TableName() string { return "mx_activation_code" }
