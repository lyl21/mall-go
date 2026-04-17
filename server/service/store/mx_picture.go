package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
)

type PictureService struct{}

var PictureServiceApp = new(PictureService)

func (s *PictureService) CreateMxPicture(picture storeModel.MxPicture) (err error) {
	err = global.GVA_DB.Create(&picture).Error
	return err
}

func (s *PictureService) DeleteMxPicture(picture storeModel.MxPicture) (err error) {
	err = global.GVA_DB.Delete(&picture).Error
	return err
}

func (s *PictureService) UpdateMxPicture(picture storeModel.MxPicture) (err error) {
	err = global.GVA_DB.Save(&picture).Error
	return err
}

func (s *PictureService) GetMxPicture(id int64) (picture storeModel.MxPicture, err error) {
	err = global.GVA_DB.Where("picture_id = ?", id).First(&picture).Error
	return
}

func (s *PictureService) GetMxPictureList(info request.PageInfo) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&storeModel.MxPicture{})
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var pictureList []storeModel.MxPicture
	err = db.Limit(limit).Offset(offset).Find(&pictureList).Error
	return pictureList, total, err
}
