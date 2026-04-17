package optometry

// TryOptometry 试戴验光表（无 create_time/update_time）
type TryOptometry struct {
	TryOptometryId   int64   `json:"tryOptometryId" gorm:"column:try_optometry_id;primaryKey;autoIncrement;comment:主键ID"`
	ResultsId        *int64  `json:"resultsId" gorm:"column:results_id;comment:视图验光id"`
	LeftRightEyes    *int    `json:"leftRightEyes" gorm:"column:left_right_eyes;type:int(11);comment:左右眼睛（0左，1右）"`
	SphericalMirror  *string `json:"sphericalMirror" gorm:"column:spherical_mirror;type:varchar(50);comment:球镜"`
	CylindricalMirror *string `json:"cylindricalMirror" gorm:"column:cylindrical_mirror;type:varchar(50);comment:柱镜"`
	PositionOfAxis   *string `json:"positionOfAxis" gorm:"column:position_of_axis;type:varchar(50);comment:轴位"`
	Addend           *string `json:"addend" gorm:"column:addend;type:varchar(50);comment:ADD"`
}

func (TryOptometry) TableName() string { return "try_optometry" }
