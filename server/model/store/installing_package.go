package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// InstallingPackage 安装包管理表
type InstallingPackage struct {
	InstallingId int64           `json:"installingId" gorm:"column:installing_id;primaryKey;autoIncrement;comment:安装包ID"`
	CreateTime   common.DateTime `json:"createTime" gorm:"column:create_time;comment:创建时间"`
	UpdateTime   common.DateTime `json:"updateTime" gorm:"column:update_time;comment:更新时间"`
	CreateBy     string          `json:"createBy" gorm:"column:create_by;type:varchar(64);comment:创建者"`
	UpdateBy     string          `json:"updateBy" gorm:"column:update_by;type:varchar(64);comment:更新者"`
	Remark       string          `json:"remark" gorm:"column:remark;type:varchar(500);comment:备注"`
	App          string          `json:"app" gorm:"column:app;type:varchar(100);comment:应用名称"`
	VersionName  string          `json:"versionName" gorm:"column:version_name;type:varchar(50);comment:应用版本"`
	Url          string          `json:"url" gorm:"column:url;type:varchar(500);comment:应用下载地址"`
	PackageName  string          `json:"packageName" gorm:"column:package_name;type:varchar(100);comment:包名"`
	ForceUpdate  int             `json:"forceUpdate" gorm:"column:forced_updating;type:int(1);default:0;comment:是否强制更新0否1是"`
	Note         string          `json:"note" gorm:"column:note;type:text;comment:更新内容"`
	PackageType  int             `json:"packageType" gorm:"column:package_type;type:int(1);comment:包类型1APP2键盘3验光仪4手动验光仪"`
	Status       int             `json:"status" gorm:"column:status;type:int(1);default:1;comment:状态0禁用1启用"`
}

func (InstallingPackage) TableName() string { return "installing_packages" }
