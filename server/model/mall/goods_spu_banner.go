package mall

import "time"

// GoodsSpuBanner 商品轮播图（无独立主键，继承 BaseEntity 的 id/create_time/update_time）
type GoodsSpuBanner struct {
	Id           int64      `json:"id" gorm:"column:id;primaryKey;autoIncrement;comment:ID"`
	GoodsSpuId   string     `json:"goodsSpuId" gorm:"column:goods_spu_id;type:varchar(32);comment:商品SPU ID"`
	BannerImgUrl string     `json:"bannerImgUrl" gorm:"column:banner_img_url;type:varchar(255);comment:图片"`
	CreateTime   *time.Time `json:"createTime" gorm:"column:create_time;comment:创建时间"`
	UpdateTime   *time.Time `json:"updateTime" gorm:"column:update_time;comment:更新时间"`
}

func (GoodsSpuBanner) TableName() string { return "goods_spu_banners" }
