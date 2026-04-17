package wechat

import "time"

// WxUser 微信用户表
type WxUser struct {
	Id                  string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:主键"`
	CreateId            *string    `json:"createId" gorm:"column:create_id;type:varchar(32);comment:创建者"`
	CreateTime          time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateId            *string    `json:"updateId" gorm:"column:update_id;type:varchar(32);comment:更新者"`
	UpdateTime          *time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:更新时间"`
	Remark              *string    `json:"remark" gorm:"column:remark;type:varchar(100);comment:用户备注"`
	DelFlag             string     `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	AppType             *string    `json:"appType" gorm:"column:app_type;type:char(2);comment:应用类型(1:小程序，2:公众号)"`
	Subscribe           *string    `json:"subscribe" gorm:"column:subscribe;type:char(2);comment:是否订阅（1：是；0：否；2：网页授权用户）"`
	SubscribeScene      *string    `json:"subscribeScene" gorm:"column:subscribe_scene;type:varchar(50);comment:关注渠道来源"`
	SubscribeTime       *time.Time `json:"subscribeTime" gorm:"column:subscribe_time;comment:关注时间"`
	SubscribeNum        *int       `json:"subscribeNum" gorm:"column:subscribe_num;comment:关注次数"`
	CancelSubscribeTime *time.Time `json:"cancelSubscribeTime" gorm:"column:cancel_subscribe_time;comment:取消关注时间"`
	OpenId              string     `json:"openId" gorm:"column:open_id;type:varchar(64);not null;uniqueIndex:uk_openid;comment:用户标识"`
	NickName            *string    `json:"nickName" gorm:"column:nick_name;type:varchar(200);comment:昵称"`
	Sex                 *string    `json:"sex" gorm:"column:sex;type:char(2);comment:性别（1：男，2：女，0：未知）"`
	City                *string    `json:"city" gorm:"column:city;type:varchar(64);comment:所在城市"`
	Country             *string    `json:"country" gorm:"column:country;type:varchar(64);comment:所在国家"`
	Province            *string    `json:"province" gorm:"column:province;type:varchar(64);comment:所在省份"`
	Phone               *string    `json:"phone" gorm:"column:phone;type:varchar(15);comment:手机号码"`
	Language            *string    `json:"language" gorm:"column:language;type:varchar(64);comment:用户语言"`
	HeadimgUrl          *string    `json:"headimgUrl" gorm:"column:headimg_url;type:varchar(1000);comment:头像"`
	UnionId             *string    `json:"unionId" gorm:"column:union_id;type:varchar(64);comment:union_id"`
	GroupId             *string    `json:"groupId" gorm:"column:group_id;type:varchar(64);comment:用户组"`
	TagidList           *string    `json:"tagidList" gorm:"column:tagid_list;type:varchar(64);comment:标签列表"`
	QrSceneStr          *string    `json:"qrSceneStr" gorm:"column:qr_scene_str;type:varchar(64);comment:二维码扫码场景"`
	Latitude            *float64   `json:"latitude" gorm:"column:latitude;comment:地理位置纬度"`
	Longitude           *float64   `json:"longitude" gorm:"column:longitude;comment:地理位置经度"`
	Precision           *float64   `json:"precision" gorm:"column:precision;comment:地理位置精度"`
	SessionKey          *string    `json:"sessionKey" gorm:"column:session_key;type:varchar(200);comment:会话密钥"`
}

func (WxUser) TableName() string { return "wx_user" }
