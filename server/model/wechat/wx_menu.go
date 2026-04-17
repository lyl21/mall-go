package wechat

import "time"

// WxMenu 微信自定义菜单表
type WxMenu struct {
	Id               string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:菜单ID"`
	DelFlag          string     `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	CreateTime       time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime       *time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:更新时间"`
	Sort             *int       `json:"sort" gorm:"column:sort;default:1;comment:排序值"`
	ParentId         *string    `json:"parentId" gorm:"column:parent_id;type:varchar(32);comment:父菜单ID"`
	Type             *string    `json:"type" gorm:"column:type;type:char(20);comment:菜单类型"`
	Name             *string    `json:"name" gorm:"column:name;type:varchar(20);comment:菜单名"`
	Url              *string    `json:"url" gorm:"column:url;type:varchar(500);comment:view、miniprogram保存链接"`
	MaAppId          *string    `json:"maAppId" gorm:"column:ma_app_id;type:varchar(32);comment:小程序的appid"`
	MaPagePath       *string    `json:"maPagePath" gorm:"column:ma_page_path;type:varchar(100);comment:小程序的页面路径"`
	RepType          *string    `json:"repType" gorm:"column:rep_type;type:char(10);comment:回复消息类型（text/image/voice/video/music/news）"`
	RepContent       *string    `json:"repContent" gorm:"column:rep_content;type:text;comment:Text:保存文字"`
	RepMediaId       *string    `json:"repMediaId" gorm:"column:rep_media_id;type:varchar(64);comment:mediaID"`
	RepName          *string    `json:"repName" gorm:"column:rep_name;type:varchar(100);comment:素材名、视频和音乐的标题"`
	RepDesc          *string    `json:"repDesc" gorm:"column:rep_desc;type:varchar(200);comment:视频和音乐的描述"`
	RepUrl           *string    `json:"repUrl" gorm:"column:rep_url;type:varchar(500);comment:链接"`
	RepHqUrl         *string    `json:"repHqUrl" gorm:"column:rep_hq_url;type:varchar(500);comment:高质量链接"`
	RepThumbMediaId  *string    `json:"repThumbMediaId" gorm:"column:rep_thumb_media_id;type:varchar(64);comment:缩略图的媒体id"`
	RepThumbUrl      *string    `json:"repThumbUrl" gorm:"column:rep_thumb_url;type:varchar(500);comment:缩略图url"`
	Content          *string    `json:"content" gorm:"column:content;type:mediumtext;comment:图文消息的内容"`
}

func (WxMenu) TableName() string { return "wx_menu" }
