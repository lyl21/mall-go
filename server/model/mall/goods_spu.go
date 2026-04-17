package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// GoodsSpu 商品表（SPU）
type GoodsSpu struct {
	Id             string          `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	SpuCode        *string         `json:"spuCode" gorm:"column:spu_code;type:varchar(32);comment:spu编码"`
	Name           string          `json:"name" gorm:"column:name;type:varchar(200);not null;default:'';comment:spu名字"`
	SellPoint      string          `json:"sellPoint" gorm:"column:sell_point;type:varchar(500);not null;default:'';comment:卖点"`
	Description    string          `json:"description" gorm:"column:description;type:text;not null;comment:描述"`
	CategoryFirst  string          `json:"categoryFirst" gorm:"column:category_first;type:varchar(32);not null;comment:一级分类ID"`
	CategorySecond *string         `json:"categorySecond" gorm:"column:category_second;type:varchar(32);comment:二级分类ID"`
	PicUrls        string          `json:"picUrls" gorm:"column:pic_urls;type:varchar(1024);not null;default:'';comment:商品图片"`
	Shelf          int             `json:"shelf" gorm:"column:shelf;type:char(2);not null;default:0;comment:是否上架（1是 0否）"`
	Sort           int             `json:"sort" gorm:"column:sort;not null;default:0;comment:排序字段"`
	SalesPrice     *float64         `json:"salesPrice" gorm:"column:sales_price;type:decimal(10,2);comment:销售价格"`
	MarketPrice    *float64         `json:"marketPrice" gorm:"column:market_price;type:decimal(10,2);comment:市场价"`
	CostPrice      *float64         `json:"costPrice" gorm:"column:cost_price;type:decimal(10,2);comment:成本价"`
	Stock          int             `json:"stock" gorm:"column:stock;not null;default:0;comment:库存"`
	SalesNum       int             `json:"salesNum" gorm:"column:sales_num;default:0;comment:销量"`
	DelFlag        string          `json:"delFlag" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记"`
	Version        int             `json:"version" gorm:"column:version;not null;default:0;comment:版本号（乐观锁）`
	CreateTime     common.DateTime `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime     common.DateTime `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
	// 关联
	Banners []GoodsSpuBanner `json:"banners" gorm:"foreignKey:GoodsSpuId;references:Id"`
}

func (GoodsSpu) TableName() string { return "goods_spu" }
