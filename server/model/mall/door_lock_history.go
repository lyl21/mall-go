package mall

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// DoorLockHistory 门锁操作历史表（从Java实体重建，无SQL建表语句）
type DoorLockHistory struct {
	Id         int64           `json:"id" gorm:"column:id;primaryKey;autoIncrement;comment:门锁id"`
	YardSn     *string         `json:"yardSn" gorm:"column:yard_sn;comment:园区sn（第三方）"`
	DoorGuid   *string         `json:"doorGuid" gorm:"column:door_guid;comment:门禁id（第三方）"`
	Operation  *string         `json:"operation" gorm:"column:operation;comment:操作记录(open：远程开门 reboot：重启)"`
	Response   *string         `json:"response" gorm:"column:response;comment:第三方接口响应"`
	DetailInfo *string         `json:"detailInfo" gorm:"column:detail_info;comment:详情地址"`
	OpenId     *string         `json:"openId" gorm:"column:open_id;comment:用户标识"`
	CreateTime common.DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime common.DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
}

func (DoorLockHistory) TableName() string { return "door_lock_history" }
