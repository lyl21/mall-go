package wechat

import "time"

// WxAutoReply 微信自动回复表
type WxAutoReply struct {
	Id               string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:主键"`
	CreateId         *string    `json:"createId" gorm:"column:create_id;type:varchar(32);comment:创建者"`
	CreateTime       time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateId         *string    `json:"updateId" gorm:"column:update_id;type:varchar(32);comment:更新者"`
	UpdateTime       *time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:更新时间"`
	Remark           *string    `json:"remark" gorm:"column:remark;type:varchar(100);comment:备注"`
	DelFlag          string     `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	Type             *string    `json:"type" gorm:"column:type;type:char(2);comment:类型（1、关注时回复；2、消息回复；3、关键词回复）"`
	ReqKey           *string    `json:"reqKey" gorm:"column:req_key;type:varchar(64);comment:关键词"`
	ReqType          *string    `json:"reqType" gorm:"column:req_type;type:char(10);comment:请求消息类型（text/image/voice/video/shortvideo/location）"`
	RepType          *string    `json:"repType" gorm:"column:rep_type;type:char(10);comment:回复消息类型（text/image/voice/video/music/news）"`
	RepMate          *string    `json:"repMate" gorm:"column:rep_mate;type:char(10);comment:回复类型文本匹配类型（1、全匹配，2、半匹配）"`
	RepContent       *string    `json:"repContent" gorm:"column:rep_content;type:text;comment:回复类型文本保存文字"`
	RepMediaId       *string    `json:"repMediaId" gorm:"column:rep_media_id;type:varchar(64);comment:mediaID或音乐缩略图的媒体id"`
	RepName          *string    `json:"repName" gorm:"column:rep_name;type:varchar(100);comment:素材名、视频和音乐的标题"`
	RepDesc          *string    `json:"repDesc" gorm:"column:rep_desc;type:varchar(200);comment:视频和音乐的描述"`
	RepUrl           *string    `json:"repUrl" gorm:"column:rep_url;type:varchar(500);comment:链接"`
	RepHqUrl         *string    `json:"repHqUrl" gorm:"column:rep_hq_url;type:varchar(500);comment:高质量链接"`
	RepThumbMediaId  *string    `json:"repThumbMediaId" gorm:"column:rep_thumb_media_id;type:varchar(64);comment:缩略图的媒体id"`
	RepThumbUrl      *string    `json:"repThumbUrl" gorm:"column:rep_thumb_url;type:varchar(500);comment:缩略图url"`
	Content          *string    `json:"content" gorm:"column:content;type:mediumtext;comment:图文消息的内容"`
}

func (WxAutoReply) TableName() string { return "wx_auto_reply" }
