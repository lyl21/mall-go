package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type SpuTryOnImgUrlService struct{}

var SpuTryOnImgUrlServiceApp = new(SpuTryOnImgUrlService)

func (s *SpuTryOnImgUrlService) CreateSpuTryOnImgUrl(img mallModel.SpuTryOnImgUrl) (err error) {
	err = global.GVA_DB.Create(&img).Error
	return err
}

func (s *SpuTryOnImgUrlService) DeleteSpuTryOnImgUrl(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.SpuTryOnImgUrl{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *SpuTryOnImgUrlService) DeleteSpuTryOnImgUrlByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.SpuTryOnImgUrl{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *SpuTryOnImgUrlService) UpdateSpuTryOnImgUrl(img mallModel.SpuTryOnImgUrl) (err error) {
	err = global.GVA_DB.Model(&mallModel.SpuTryOnImgUrl{}).Where("id = ?", img.Id).Updates(&img).Error
	return err
}

func (s *SpuTryOnImgUrlService) GetSpuTryOnImgUrl(id string) (img mallModel.SpuTryOnImgUrl, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&img).Error
	return
}

func (s *SpuTryOnImgUrlService) GetSpuTryOnImgUrlList(info request.PageInfo, goodsSpuId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.SpuTryOnImgUrl{}).Where("del_flag = ?", "0")
	if goodsSpuId != "" {
		db = db.Where("goods_spu_id = ?", goodsSpuId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var imgList []mallModel.SpuTryOnImgUrl
	err = db.Limit(limit).Offset(offset).Find(&imgList).Error
	return imgList, total, err
}
