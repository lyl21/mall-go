package mall

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// GoodsCategory 商品分类表（树形结构）
type GoodsCategory struct {
	Id          string           `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	Enable      int              `json:"enable" gorm:"column:enable;type:char(2);not null;comment:（1：开启；0：关闭）"`
	ParentId    *string          `json:"parentId" gorm:"column:parent_id;type:varchar(32);comment:父分类编号"`
	Name        *string          `json:"name" gorm:"column:name;type:varchar(16);comment:名称"`
	Description *string          `json:"description" gorm:"column:description;type:varchar(255);comment:描述"`
	PicUrl      *string          `json:"picUrl" gorm:"column:pic_url;type:varchar(255);comment:图片"`
	Sort        *int16           `json:"sort" gorm:"column:sort;comment:排序"`
	CreateTime  common.DateTime  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime  common.DateTime  `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
	DelFlag     string           `json:"delFlag" gorm:"column:del_flag;type:char(2);default:'0';comment:逻辑删除标记"`
}

func (GoodsCategory) TableName() string { return "goods_category" }
