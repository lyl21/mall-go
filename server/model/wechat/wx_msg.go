package wechat

import "time"

// WxMsg 微信消息表
type WxMsg struct {
	Id              string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:主键"`
	CreateId        *string    `json:"createId" gorm:"column:create_id;type:varchar(32);comment:创建者"`
	CreateTime      time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateId        *string    `json:"updateId" gorm:"column:update_id;type:varchar(32);comment:更新者"`
	UpdateTime      *time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:更新时间"`
	Remark          *string    `json:"remark" gorm:"column:remark;type:varchar(100);comment:备注"`
	DelFlag         string     `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	AppName         *string    `json:"appName" gorm:"column:app_name;type:varchar(50);comment:公众号名称"`
	AppLogo         *string    `json:"appLogo" gorm:"column:app_logo;type:varchar(500);comment:公众号logo"`
	WxUserId        string     `json:"wxUserId" gorm:"column:wx_user_id;type:varchar(32);not null;comment:微信用户ID"`
	NickName        *string    `json:"nickName" gorm:"column:nick_name;type:varchar(200);comment:微信用户昵称"`
	HeadimgUrl      *string    `json:"headimgUrl" gorm:"column:headimg_url;type:varchar(1000);comment:微信用户头像"`
	Type            *string    `json:"type" gorm:"column:type;type:char(2);comment:消息分类（1、用户发给公众号；2、公众号发给用户）"`
	RepType         *string    `json:"repType" gorm:"column:rep_type;type:char(20);comment:消息类型（text/image/voice/video/shortvideo/location/music/news/event）"`
	RepEvent        *string    `json:"repEvent" gorm:"column:rep_event;type:char(20);comment:事件类型（subscribe/unsubscribe/CLICK/VIEW）"`
	RepContent      *string    `json:"repContent" gorm:"column:rep_content;type:text;comment:回复类型文本保存文字、地理位置信息"`
	RepMediaId      *string    `json:"repMediaId" gorm:"column:rep_media_id;type:varchar(64);comment:mediaID"`
	RepName         *string    `json:"repName" gorm:"column:rep_name;type:varchar(100);comment:素材名、视频和音乐的标题"`
	RepDesc         *string    `json:"repDesc" gorm:"column:rep_desc;type:varchar(200);comment:视频和音乐的描述"`
	RepUrl          *string    `json:"repUrl" gorm:"column:rep_url;type:varchar(500);comment:链接"`
	RepHqUrl        *string    `json:"repHqUrl" gorm:"column:rep_hq_url;type:varchar(500);comment:高质量链接"`
	Content         *string    `json:"content" gorm:"column:content;type:mediumtext;comment:图文消息的内容"`
	RepThumbMediaId *string    `json:"repThumbMediaId" gorm:"column:rep_thumb_media_id;type:varchar(64);comment:缩略图的媒体id"`
	RepThumbUrl     *string    `json:"repThumbUrl" gorm:"column:rep_thumb_url;type:varchar(500);comment:缩略图url"`
	RepLocationX    *float64   `json:"repLocationX" gorm:"column:rep_location_x;comment:地理位置纬度"`
	RepLocationY    *float64   `json:"repLocationY" gorm:"column:rep_location_y;comment:地理位置经度"`
	RepScale        *float64   `json:"repScale" gorm:"column:rep_scale;comment:地图缩放大小"`
	ReadFlag        string     `json:"readFlag" gorm:"column:read_flag;type:char(2);default:'1';comment:已读标记（1：是；0：否）"`
}

func (WxMsg) TableName() string { return "wx_msg" }
