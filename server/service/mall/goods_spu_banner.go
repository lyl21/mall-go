package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type GoodsSpuBannerService struct{}

var GoodsSpuBannerServiceApp = new(GoodsSpuBannerService)

func (s *GoodsSpuBannerService) CreateGoodsSpuBanner(banner mallModel.GoodsSpuBanner) (err error) {
	err = global.GVA_DB.Create(&banner).Error
	return err
}

func (s *GoodsSpuBannerService) DeleteGoodsSpuBanner(id int64) (err error) {
	err = global.GVA_DB.Where("id = ?", id).Delete(&mallModel.GoodsSpuBanner{}).Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *GoodsSpuBannerService) UpdateGoodsSpuBanner(banner mallModel.GoodsSpuBanner) (err error) {
	err = global.GVA_DB.Model(&mallModel.GoodsSpuBanner{}).Where("id = ?", banner.Id).Updates(&banner).Error
	return err
}

func (s *GoodsSpuBannerService) GetGoodsSpuBanner(id int64) (banner mallModel.GoodsSpuBanner, err error) {
	err = global.GVA_DB.Where("id = ?", id).First(&banner).Error
	return
}

func (s *GoodsSpuBannerService) GetGoodsSpuBannerList(info request.PageInfo, goodsSpuId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.GoodsSpuBanner{})
	if goodsSpuId != "" {
		db = db.Where("goods_spu_id = ?", goodsSpuId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var bannerList []mallModel.GoodsSpuBanner
	err = db.Limit(limit).Offset(offset).Find(&bannerList).Error
	return bannerList, total, err
}
