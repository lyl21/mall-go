package optometry

import (
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"go.uber.org/zap"
)

type OptometryRecordService struct{}

var OptometryRecordServiceApp = new(OptometryRecordService)

type OptometryDataClientVo struct {
	OptometryRecordsId int64      `json:"optometryRecordsId"`
	SphericalMirrorL   *string    `json:"sphericalMirrorL"`
	CylindricalMirrorL *string    `json:"cylindricalMirrorL"`
	PositionOfAxisL    *string    `json:"positionOfAxisL"`
	SphericalMirrorR   *string    `json:"sphericalMirrorR"`
	CylindricalMirrorR *string    `json:"cylindricalMirrorR"`
	PositionOfAxisR    *string    `json:"positionOfAxisR"`
	CreateTime         *time.Time `json:"createTime"`
}

type OptometryDTO struct {
	OptometryRecords  *optometryModel.OptometryRecord   `json:"optometryRecords"`
	OptometryDataList []optometryModel.OptometryData    `json:"optometryDataList"`
}

type VisionTestResultsTryOptomentryVo struct {
	TryOptometryList  []optometryModel.TryOptometry     `json:"tryOptometryList"`
	VisionTestResults *optometryModel.VisionTestResult  `json:"visionTestResults"`
}

func (s *OptometryRecordService) CreateOptometryRecord(record optometryModel.OptometryRecord) (err error) {
	err = global.GVA_DB.Create(&record).Error
	return err
}

func (s *OptometryRecordService) DeleteOptometryRecord(id int64) (err error) {
	err = global.GVA_DB.Model(&optometryModel.OptometryRecord{}).Where("optometry_records_id = ?", id).Update("is_delete", 1).Error
	return err
}

func (s *OptometryRecordService) UpdateOptometryRecord(record optometryModel.OptometryRecord) (err error) {
	err = global.GVA_DB.Model(&record).Where("optometry_records_id = ?", record.OptometryRecordsId).Updates(&record).Error
	return err
}

func (s *OptometryRecordService) GetOptometryRecord(id int64) (record optometryModel.OptometryRecord, err error) {
	err = global.GVA_DB.Where("optometry_records_id = ? AND is_delete = ?", id, 0).First(&record).Error
	return
}

func (s *OptometryRecordService) GetOptometryRecordList(pageInfo request.PageInfo, search optometryModel.OptometryRecord) (list []optometryModel.OptometryRecord, total int64, err error) {
	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)
	
	if limit == 0 {
		limit = 10000
	}
	
	db := global.GVA_DB.Model(&optometryModel.OptometryRecord{}).Where("is_delete = ?", 0)

	if search.CustomerName != "" {
		db = db.Where("customer_name LIKE ?", "%"+search.CustomerName+"%")
	}
	if search.OptometristName != "" {
		db = db.Where("optometrist_name LIKE ?", "%"+search.OptometristName+"%")
	}
	if search.StoreName != "" {
		db = db.Where("store_name LIKE ?", "%"+search.StoreName+"%")
	}
	if search.StoreId != 0 {
		db = db.Where("store_id = ?", search.StoreId)
	}
	if search.OptometristId != 0 {
		db = db.Where("optometrist_id = ?", search.OptometristId)
	}
	if search.CustomerId != nil && *search.CustomerId != 0 {
		db = db.Where("customer_id = ?", *search.CustomerId)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&list).Error
	return
}

func (s *OptometryRecordService) GetOptometryDataClientVoByCustomerId(customerId int64) (list []OptometryDataClientVo, err error) {
	var data []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id IN (SELECT optometry_records_id FROM optometry_records WHERE customer_id = ? AND is_delete = 0) AND type IN (1, 2)", customerId).
		Order("optometry_records_id ASC, create_time ASC").
		Find(&data).Error
	if err != nil {
		return
	}

	type leftRightData struct {
		SphericalMirror   *string
		CylindricalMirror *string
		PositionOfAxis    *string
		CreateTime        *time.Time
	}

	resultMap := make(map[int64]map[int]*leftRightData)
	var recordIds []int64
	recordCreateTime := make(map[int64]*time.Time)

	for i := range data {
		d := &data[i]
		if d.OptometryRecordsId == nil {
			continue
		}
		recordId := *d.OptometryRecordsId
		lr := d.LeftRightEyes

		if _, ok := resultMap[recordId]; !ok {
			resultMap[recordId] = make(map[int]*leftRightData)
		}

		if _, ok := resultMap[recordId][lr]; !ok {
			resultMap[recordId][lr] = &leftRightData{}
		}

		target := resultMap[recordId][lr]
		target.SphericalMirror = strPtr2(d.SphericalMirror)
		target.CylindricalMirror = strPtr2(d.CylindricalMirror)
		target.PositionOfAxis = strPtr2(d.PositionOfAxis)
		target.CreateTime = &d.CreateTime.CreateTime.Time

		if _, ok := recordCreateTime[recordId]; !ok {
			recordCreateTime[recordId] = &d.CreateTime.CreateTime.Time
		}
		recordIds = append(recordIds, recordId)
	}

	seen := make(map[int64]bool)
	var uniqueRecordIds []int64
	for _, id := range recordIds {
		if !seen[id] {
			seen[id] = true
			uniqueRecordIds = append(uniqueRecordIds, id)
		}
	}

	for _, recordId := range uniqueRecordIds {
		lrMap := resultMap[recordId]
		vo := OptometryDataClientVo{
			OptometryRecordsId: recordId,
			CreateTime:         recordCreateTime[recordId],
		}

		if leftData, ok := lrMap[0]; ok {
			vo.SphericalMirrorL = leftData.SphericalMirror
			vo.CylindricalMirrorL = leftData.CylindricalMirror
			vo.PositionOfAxisL = leftData.PositionOfAxis
		}
		if rightData, ok := lrMap[1]; ok {
			vo.SphericalMirrorR = rightData.SphericalMirror
			vo.CylindricalMirrorR = rightData.CylindricalMirror
			vo.PositionOfAxisR = rightData.PositionOfAxis
		}

		list = append(list, vo)
	}

	return
}

func strPtr2(s string) *string {
	if s == "" {
		return nil
	}
	return &s
}

func (s *OptometryRecordService) GetOptometryDTOByOptometryRecordsId(optometryRecordsId int64) (dto OptometryDTO, err error) {
	var record optometryModel.OptometryRecord
	if err = global.GVA_DB.Where("optometry_records_id = ? AND is_delete = ?", optometryRecordsId, 0).First(&record).Error; err != nil {
		return
	}
	dto.OptometryRecords = &record

	var dataList []optometryModel.OptometryData
	if err = global.GVA_DB.Where("optometry_records_id = ?", optometryRecordsId).Find(&dataList).Error; err != nil {
		return
	}

	typeNames := map[int]string{
		1: "电脑验光仪",
		2: "查片仪",
		3: "验光头",
		4: "最终配镜",
	}
	for i := range dataList {
		dataList[i].TypeName = typeNames[dataList[i].Type]
	}
	dto.OptometryDataList = dataList
	return
}

func (s *OptometryRecordService) GetVisionTestResultsTryOptomentryVoByOptometryRecordsId(optometryRecordsId int64) (vo VisionTestResultsTryOptomentryVo, err error) {
	var vr optometryModel.VisionTestResult
	if err = global.GVA_DB.Where("optometry_records_id = ?", optometryRecordsId).First(&vr).Error; err != nil {
		vo.TryOptometryList = []optometryModel.TryOptometry{}
		return
	}
	vo.VisionTestResults = &vr

	var tryList []optometryModel.TryOptometry
	if err = global.GVA_DB.Where("results_id = ?", vr.ResultsId).Find(&tryList).Error; err != nil {
		vo.TryOptometryList = []optometryModel.TryOptometry{}
		err = nil
		return
	}
	vo.TryOptometryList = tryList
	return
}

type OptometryRecordDTO struct {
	OptometryRecords  *optometryModel.OptometryRecord   `json:"optometryRecords"`
	OptometryDataList []optometryModel.OptometryData    `json:"optometryDataList"`
	VisionTestResults *optometryModel.VisionTestResult  `json:"visionTestResults"`
	TryOptometryList  []optometryModel.TryOptometry     `json:"tryOptometryList"`
}

func (s *OptometryRecordService) InsertOptometryRecordDTO(dto OptometryRecordDTO) (err error) {
	tx := global.GVA_DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	if dto.OptometryRecords == nil {
		return fmt.Errorf("验光记录不能为空")
	}

	record := dto.OptometryRecords
	if err = tx.Create(record).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("创建验光记录失败", zap.Error(err))
		return
	}

	optometryRecordsId := record.OptometryRecordsId

	for i := range dto.OptometryDataList {
		dto.OptometryDataList[i].OptometryRecordsId = &optometryRecordsId
		if err = tx.Create(&dto.OptometryDataList[i]).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("创建验光数据失败", zap.Error(err))
			return
		}
	}

	if dto.VisionTestResults != nil {
		dto.VisionTestResults.OptometryRecordsId = &optometryRecordsId
		if err = tx.Create(dto.VisionTestResults).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("创建视力测试结果失败", zap.Error(err))
			return
		}

		resultsId := dto.VisionTestResults.ResultsId
		for i := range dto.TryOptometryList {
			dto.TryOptometryList[i].ResultsId = &resultsId
			if err = tx.Create(&dto.TryOptometryList[i]).Error; err != nil {
				tx.Rollback()
				global.GVA_LOG.Error("创建试戴验光数据失败", zap.Error(err))
				return
			}
		}
	}

	if record.CustomerId != nil && *record.CustomerId > 0 {
		var member storeModel.MxStoreMember
		member.UserId = *record.CustomerId
		member.Username = record.CustomerName
		member.Post = 3
		member.StoreId = record.StoreId
		member.OptometristUserId = &record.OptometristId

		var count int64
		tx.Model(&storeModel.MxStoreMember{}).
			Where("store_id = ? AND user_id = ? AND optometrist_user_id = ? AND is_delete = 0",
				record.StoreId, *record.CustomerId, record.OptometristId).
			Count(&count)

		if count == 0 {
			if err = tx.Create(&member).Error; err != nil {
				global.GVA_LOG.Warn("创建门店成员失败", zap.Error(err))
			}
		}
	}

	if err = tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交事务失败", zap.Error(err))
		return
	}

	return nil
}
