package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// MxPicture 视图图片表
type MxPicture struct {
	PictureId  int64           `json:"pictureId" gorm:"column:picture_id;primaryKey;autoIncrement;comment:图片ID"`
	CreateTime common.BizModel `gorm:"embedded"`
	XmIconid   *int64          `json:"xmIconid" gorm:"column:xm_iconid;type:int(11);comment:视图id"`
	Picture    string          `json:"picture" gorm:"column:picture;type:varchar(255);comment:图片"`
}

func (MxPicture) TableName() string { return "mx_picture" }
