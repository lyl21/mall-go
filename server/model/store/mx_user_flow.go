package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// MxUserFlow 用户流程表
type MxUserFlow struct {
	FlowId        int64           `json:"flowId" gorm:"column:flow_id;primaryKey;autoIncrement;comment:流程ID"`
	UserId        int64           `json:"userId" gorm:"column:user_id;not null;comment:用户ID"`
	CreateTime    common.BizModel `gorm:"embedded"`
	Type          int             `json:"type" gorm:"column:type;type:int(1);not null;comment:分类"`
	XmIconid      *int64          `json:"xmIconid" gorm:"column:xm_iconid;type:int(11);comment:视图id"`
	LeftEyeGlassid *int64          `json:"leftEyeGlassid" gorm:"column:left_eye_glassid;type:int(11);comment:左眼镜片ID"`
	RightEyeGlassid *int64         `json:"rightEyeGlassid" gorm:"column:right_eye_glassid;type:int(11);comment:右眼镜片ID"`
	DetectionEye  string          `json:"detectionEye" gorm:"column:detection_eye;type:varchar(50);comment:检测眼"`
	DialOption    string          `json:"dialOption" gorm:"column:dial_option;type:varchar(50);comment:拨盘选项"`
	FarNearlyUse  string          `json:"farNearlyUse" gorm:"column:far_nearly_use;type:varchar(50);comment:远近用"`
	FogVision     string          `json:"fogVision" gorm:"column:fog_vision;type:varchar(50);comment:雾视"`
}

func (MxUserFlow) TableName() string { return "mx_user_flow" }
