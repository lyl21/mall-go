package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type TryOnGlassImgUrlService struct{}

var TryOnGlassImgUrlServiceApp = new(TryOnGlassImgUrlService)

func (s *TryOnGlassImgUrlService) CreateTryOnGlassImgUrl(img mallModel.TryOnGlassImgUrl) (err error) {
	err = global.GVA_DB.Create(&img).Error
	return err
}

func (s *TryOnGlassImgUrlService) DeleteTryOnGlassImgUrl(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.TryOnGlassImgUrl{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *TryOnGlassImgUrlService) DeleteTryOnGlassImgUrlByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.TryOnGlassImgUrl{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *TryOnGlassImgUrlService) UpdateTryOnGlassImgUrl(img mallModel.TryOnGlassImgUrl) (err error) {
	err = global.GVA_DB.Model(&mallModel.TryOnGlassImgUrl{}).Where("id = ?", img.Id).Updates(&img).Error
	return err
}

func (s *TryOnGlassImgUrlService) GetTryOnGlassImgUrl(id string) (img mallModel.TryOnGlassImgUrl, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&img).Error
	return
}

func (s *TryOnGlassImgUrlService) GetTryOnGlassImgUrlList(info request.PageInfo, wxUserId string, goodsSpuId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.TryOnGlassImgUrl{}).Where("del_flag = ?", "0")
	if wxUserId != "" {
		db = db.Where("wx_user_id = ?", wxUserId)
	}
	if goodsSpuId != "" {
		db = db.Where("goods_spu_id = ?", goodsSpuId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var imgList []mallModel.TryOnGlassImgUrl
	err = db.Limit(limit).Offset(offset).Find(&imgList).Error
	return imgList, total, err
}
