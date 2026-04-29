package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// MxStoreMember 门店成员信息表（无独立主键，联合唯一索引）
type MxStoreMember struct {
	StoreId          int64       `json:"storeId" gorm:"column:store_id;not null;comment:门店ID"`
	CreateTime       common.BizModel `gorm:"embedded"`
	UserId           int64       `json:"userId" gorm:"column:user_id;not null;comment:用户ID"`
	Username         string      `json:"username" gorm:"column:username;type:varchar(255);comment:用户姓名"`
	Post             int64       `json:"post" gorm:"column:post;not null;comment:职位：1店长，2验光师，3顾客"`
	OptometristUserId *int64     `json:"optometristUserId" gorm:"column:optometrist_user_id;comment:验光师id(如果职位是3则需要填)"`
	IsDelete         int         `json:"isDelete" gorm:"column:is_delete;type:int(1);default:0;comment:逻辑删0否1是"`
}

func (MxStoreMember) TableName() string { return "mx_store_member" }

// MxStoreMemberWithUser 门店成员（含用户姓名）
// 用于门店成员列表展示，避免前端二次查询用户名称。
type MxStoreMemberWithUser struct {
	MxStoreMember
	Username string `json:"username" gorm:"column:username;comment:用户姓名"`
}
