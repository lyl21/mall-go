package store

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// RemoteOptometryLog 远程验光远控日志表
type RemoteOptometryLog struct {
	LogId          string           `json:"logId" gorm:"column:log_id;primaryKey;type:varchar(64);comment:日志ID"`
	SessionId      string           `json:"sessionId" gorm:"column:session_id;type:varchar(64);index;comment:会话ID"`
	Equipment      string           `json:"equipment" gorm:"column:equipment;type:varchar(255);index;comment:设备ID(牛头APP设备号)"`
	UserId         *int64           `json:"userId" gorm:"column:user_id;type:bigint;index;comment:用户ID"`
	MainControlId  *string          `json:"mainControlId" gorm:"column:main_control_id;type:varchar(64);comment:主控端连接ID"`
	ControlledId   *string          `json:"controlledId" gorm:"column:controlled_id;type:varchar(64);comment:被控端连接ID"`
	
	// 远控状态
	IsControlActive bool       `json:"isControlActive" gorm:"column:is_control_active;type:tinyint(1);default:0;comment:远控是否激活"`
	ControlStatus   string     `json:"controlStatus" gorm:"column:control_status;type:varchar(20);default:'';comment:远控状态: pending/accepted/rejected/timeout/terminated"`
	
	// 设备状态
	NiuTouConnected bool       `json:"niuTouConnected" gorm:"column:niu_tou_connected;type:tinyint(1);default:0;comment:牛头设备是否连接"`
	Transport       string     `json:"transport" gorm:"column:transport;type:varchar(10);comment:传输方式 BLE/USB"`
	LensMode        string     `json:"lensMode" gorm:"column:lens_mode;type:varchar(10);comment:镜片模式 FAR/NEAR"`
	LeftS           *float64   `json:"leftS" gorm:"column:left_s;type:decimal(5,2);comment:左眼镜片度数"`
	RightS          *float64   `json:"rightS" gorm:"column:right_s;type:decimal(5,2);comment:右眼镜片度数"`
	
	// 执行状态
	LastApplyStatus string     `json:"lastApplyStatus" gorm:"column:last_apply_status;type:varchar(20);comment:最后执行状态 applying/success/failed/timeout"`
	LastApplyTxnId  string     `json:"lastApplyTxnId" gorm:"column:last_apply_txn_id;type:varchar(64);comment:最后执行事务ID"`
	LastApplyError  string     `json:"lastApplyError" gorm:"column:last_apply_error;type:varchar(500);comment:最后执行错误信息"`
	
	// 时间记录
	StartTime      time.Time      `json:"startTime" gorm:"column:start_time;comment:会话开始时间"`
	EndTime        *time.Time     `json:"endTime" gorm:"column:end_time;comment:会话结束时间"`
	LastActiveTime time.Time      `json:"lastActiveTime" gorm:"column:last_active_time;comment:最后活跃时间"`
	
	// 元数据
	DeviceInfo     string     `json:"deviceInfo" gorm:"column:device_info;type:varchar(500);comment:设备信息JSON"`
	Remark         string     `json:"remark" gorm:"column:remark;type:varchar(500);comment:备注"`
	
	common.BizModel
}

func (RemoteOptometryLog) TableName() string {
	return "remote_optometry_log"
}

// RemoteOptometryStatus 远程验光实时状态（内存缓存结构）
type RemoteOptometryStatus struct {
	SessionId       string    `json:"sessionId"`
	Equipment       string    `json:"equipment"`
	UserId          *int64    `json:"userId"`
	IsOnline        bool      `json:"isOnline"`
	IsControlActive bool      `json:"isControlActive"`
	ControlStatus   string    `json:"controlStatus"`
	NiuTouConnected bool      `json:"niuTouConnected"`
	Transport       string    `json:"transport"`
	LensMode        string    `json:"lensMode"`
	LeftS           *float64  `json:"leftS"`
	RightS          *float64  `json:"rightS"`
	LastApplyStatus string    `json:"lastApplyStatus"`
	MainControlUser *int64    `json:"mainControlUser"`
	StartTime       time.Time `json:"startTime"`
	LastActiveTime  time.Time `json:"lastActiveTime"`
}
