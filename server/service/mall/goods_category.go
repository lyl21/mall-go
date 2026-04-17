package mall

import (
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type GoodsCategoryService struct{}

var GoodsCategoryServiceApp = new(GoodsCategoryService)

func (s *GoodsCategoryService) CreateGoodsCategory(category mallModel.GoodsCategory) (err error) {
	if category.Id == "" {
		category.Id = strings.ReplaceAll(uuid.New().String(), "-", "")
	}
	err = global.GVA_DB.Create(&category).Error
	return err
}

func (s *GoodsCategoryService) DeleteGoodsCategory(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.GoodsCategory{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *GoodsCategoryService) DeleteGoodsCategoryByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.GoodsCategory{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *GoodsCategoryService) UpdateGoodsCategory(category mallModel.GoodsCategory) (err error) {
	err = global.GVA_DB.Select("enable", "name", "parent_id", "description", "pic_url", "sort").Where("id = ?", category.Id).Updates(&category).Error
	return err
}

func (s *GoodsCategoryService) GetGoodsCategory(id string) (category mallModel.GoodsCategory, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&category).Error
	return
}

func (s *GoodsCategoryService) GetGoodsCategoryList(info request.PageInfo, name string, parentId string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.GoodsCategory{}).Where("del_flag = ?", "0")
	if name != "" {
		db = db.Where("name LIKE ?", "%"+name+"%")
	}
	if parentId != "" {
		db = db.Where("parent_id = ?", parentId)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var categoryList []mallModel.GoodsCategory
	err = db.Limit(limit).Offset(offset).Order("sort ASC").Find(&categoryList).Error
	return categoryList, total, err
}

func (s *GoodsCategoryService) GetGoodsCategoryTree() (list []mallModel.GoodsCategory, err error) {
	err = global.GVA_DB.Where("del_flag = ?", "0").Order("sort ASC").Find(&list).Error
	return
}
