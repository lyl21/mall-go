package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
)

type VisionTestResultService struct{}

var VisionTestResultServiceApp = new(VisionTestResultService)

func (s *VisionTestResultService) CreateVisionTestResult(result optometryModel.VisionTestResult) (err error) {
	err = global.GVA_DB.Create(&result).Error
	return err
}

func (s *VisionTestResultService) DeleteVisionTestResult(id int64) (err error) {
	err = global.GVA_DB.Where("results_id = ?", id).Delete(&optometryModel.VisionTestResult{}).Error
	return err
}

func (s *VisionTestResultService) UpdateVisionTestResult(result optometryModel.VisionTestResult) (err error) {
	err = global.GVA_DB.Model(&result).Where("results_id = ?", result.ResultsId).Updates(&result).Error
	return err
}

func (s *VisionTestResultService) GetVisionTestResult(id int64) (result optometryModel.VisionTestResult, err error) {
	err = global.GVA_DB.Where("results_id = ?", id).First(&result).Error
	return
}

func (s *VisionTestResultService) GetByRecordId(recordsId int64) (result optometryModel.VisionTestResult, err error) {
	err = global.GVA_DB.Where("optometry_records_id = ?", recordsId).First(&result).Error
	return
}

func (s *VisionTestResultService) GetVisionTestResultList(pageInfo request.PageInfo, search optometryModel.VisionTestResult) (list []optometryModel.VisionTestResult, total int64, err error) {
	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)
	db := global.GVA_DB.Model(&optometryModel.VisionTestResult{})

	if search.OptometryRecordsId != nil {
		db = db.Where("optometry_records_id = ?", *search.OptometryRecordsId)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&list).Error
	return
}

// VisionTestAndTryOnResult is the composite response for vision test + try-on data.
type VisionTestAndTryOnResult struct {
	VisionTestResults *optometryModel.VisionTestResult `json:"visionTestResults"`
	OptometryList     []optometryModel.TryOptometry    `json:"optometryList"`
}

// GetVisionTestAndTryOn returns the VisionTestResult and associated TryOptometry list for a record.
func (s *VisionTestResultService) GetVisionTestAndTryOn(recordsId int64) (result VisionTestAndTryOnResult, err error) {
	var vr optometryModel.VisionTestResult
	if err = global.GVA_DB.Where("optometry_records_id = ?", recordsId).First(&vr).Error; err != nil {
		// No vision test result yet — return empty, not error
		result.OptometryList = []optometryModel.TryOptometry{}
		err = nil
		return
	}
	result.VisionTestResults = &vr

	var tryList []optometryModel.TryOptometry
	if dbErr := global.GVA_DB.Where("results_id = ?", vr.ResultsId).Find(&tryList).Error; dbErr == nil {
		result.OptometryList = tryList
	} else {
		result.OptometryList = []optometryModel.TryOptometry{}
	}
	return
}
