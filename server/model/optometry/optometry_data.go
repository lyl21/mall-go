package optometry

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// OptometryData 眼镜验光数据表
type OptometryData struct {
	OptometryId        int64           `json:"optometryId" gorm:"column:optometry_id;primaryKey;autoIncrement;comment:眼镜验光ID"`
	OptometryRecordsId *int64          `json:"optometryRecordsId" gorm:"column:optometry_records_id;index;comment:验光记录ID"`
	CreateTime         common.BizModel `gorm:"embedded"`
	SphericalMirror    string          `json:"sphericalMirror" gorm:"column:spherical_mirror;type:varchar(50);comment:球镜数据"`
	CylindricalMirror  string          `json:"cylindricalMirror" gorm:"column:cylindrical_mirror;type:varchar(50);comment:柱镜数据"`
	PositionOfAxis     string          `json:"positionOfAxis" gorm:"column:position_of_axis;type:varchar(50);comment:轴位数据"`
	Addend             *string         `json:"addend" gorm:"column:addend;type:varchar(50);comment:ADD数据"`
	DistanceOfPupil    string          `json:"distanceOfPupil" gorm:"column:distance_of_pupil;type:varchar(50);comment:瞳距数据"`
	HorizontalPrism    string          `json:"horizontalPrism" gorm:"column:horizontal_prism;type:varchar(50);default:'0.0';comment:水平棱镜数据"`
	VerticalPrism      string          `json:"verticalPrism" gorm:"column:vertical_prism;type:varchar(50);default:'0.0';comment:垂直棱镜数据"`
	Type               int             `json:"type" gorm:"column:type;type:int(1);not null;comment:分类数据（1=电脑验光仪，2=查片仪，3=验光头，4=最终配镜）"`
	NearFar            *int            `json:"nearFar" gorm:"column:near_far;type:int(1);comment:远近数据（0=远，1=近）"`
	LeftRightEyes      int             `json:"leftRightEyes" gorm:"column:left_right_eyes;type:int(1);not null;comment:左右眼数据（0=左眼，1=右眼）"`
}

func (OptometryData) TableName() string { return "optometry_data" }
