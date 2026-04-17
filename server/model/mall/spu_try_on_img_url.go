package mall

import "time"

// SpuTryOnImgUrl 商品试戴图片
type SpuTryOnImgUrl struct {
	Id         string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:主键ID"`
	ImgUrl     string     `json:"imgUrl" gorm:"column:img_url;comment:图片地址"`
	GoodsSpuId string     `json:"goodsSpuId" gorm:"column:goods_spu_id;type:varchar(32);comment:商品SPU ID"`
	DelFlag    string     `json:"-" gorm:"column:del_flag;type:char(2);comment:逻辑删除标记（0：显示；1：隐藏）"`
	CreateTime time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime time.Time  `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
}

func (SpuTryOnImgUrl) TableName() string { return "spu_try_on_img_url" }
