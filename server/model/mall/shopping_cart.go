package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// ShoppingCart 购物车
type ShoppingCart struct {
	Id        string          `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	DelFlag   string          `json:"delFlag" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	UserId    string          `json:"userId" gorm:"column:user_id;type:varchar(32);not null;comment:用户编号"`
	SpuId     string          `json:"spuId" gorm:"column:spu_id;type:varchar(32);not null;comment:商品SPU"`
	Quantity  int             `json:"quantity" gorm:"column:quantity;not null;comment:数量"`
	SpuName   string          `json:"spuName" gorm:"column:spu_name;type:varchar(200);comment:加入时的spu名字"`
	AddPrice  float64         `json:"addPrice" gorm:"column:add_price;type:decimal(10,2);comment:加入时价格"`
	PicUrl    string          `json:"picUrl" gorm:"column:pic_url;type:varchar(500);comment:图片"`
	CreateTime common.DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime common.DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
	// 关联
	GoodsSpu GoodsSpu `json:"goodsSpu" gorm:"foreignKey:SpuId;references:Id"`
}

func (ShoppingCart) TableName() string { return "shopping_cart" }
