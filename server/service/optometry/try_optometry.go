package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
)

type TryOptometryService struct{}

var TryOptometryServiceApp = new(TryOptometryService)

func (s *TryOptometryService) CreateTryOptometry(data optometryModel.TryOptometry) (err error) {
	err = global.GVA_DB.Create(&data).Error
	return err
}

func (s *TryOptometryService) DeleteTryOptometry(id int64) (err error) {
	err = global.GVA_DB.Where("try_optometry_id = ?", id).Delete(&optometryModel.TryOptometry{}).Error
	return err
}

func (s *TryOptometryService) UpdateTryOptometry(data optometryModel.TryOptometry) (err error) {
	err = global.GVA_DB.Model(&data).Where("try_optometry_id = ?", data.TryOptometryId).Updates(&data).Error
	return err
}

func (s *TryOptometryService) GetTryOptometry(id int64) (data optometryModel.TryOptometry, err error) {
	err = global.GVA_DB.Where("try_optometry_id = ?", id).First(&data).Error
	return
}

func (s *TryOptometryService) GetByResultsId(resultsId int64) (list []optometryModel.TryOptometry, err error) {
	err = global.GVA_DB.Where("results_id = ?", resultsId).Find(&list).Error
	return
}

func (s *TryOptometryService) GetTryOptometryList(pageInfo request.PageInfo, search optometryModel.TryOptometry) (list []optometryModel.TryOptometry, total int64, err error) {
	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)
	db := global.GVA_DB.Model(&optometryModel.TryOptometry{})

	if search.ResultsId != nil {
		db = db.Where("results_id = ?", *search.ResultsId)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Find(&list).Error
	return
}
