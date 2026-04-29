package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"gorm.io/gorm"
)

type UserFlowService struct{}

var UserFlowServiceApp = new(UserFlowService)

func (s *UserFlowService) CreateMxUserFlow(flow storeModel.MxUserFlow) (err error) {
	err = global.GVA_DB.Create(&flow).Error
	return err
}

func (s *UserFlowService) DeleteMxUserFlow(flow storeModel.MxUserFlow) (err error) {
	err = global.GVA_DB.Delete(&flow).Error
	return err
}

func (s *UserFlowService) UpdateMxUserFlow(flow storeModel.MxUserFlow) (err error) {
	err = global.GVA_DB.Save(&flow).Error
	return err
}

func (s *UserFlowService) GetMxUserFlow(id int64) (flow storeModel.MxUserFlow, err error) {
	err = global.GVA_DB.Where("flow_id = ?", id).First(&flow).Error
	return
}

func (s *UserFlowService) GetMxUserFlowList(info request.PageInfo, userId int64) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	
	if limit == 0 {
		limit = 10000
	}
	
	db := global.GVA_DB.Model(&storeModel.MxUserFlow{}).Where("user_id = ?", userId)
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var flowList []storeModel.MxUserFlow
	err = db.Limit(limit).Offset(offset).Find(&flowList).Error
	return flowList, total, err
}

func (s *UserFlowService) UpsertMxUserFlow(flow storeModel.MxUserFlow) (err error) {
	var existing storeModel.MxUserFlow
	err = global.GVA_DB.Where("flow_id = ?", flow.FlowId).First(&existing).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return global.GVA_DB.Create(&flow).Error
		}
		return err
	}
	return global.GVA_DB.Save(&flow).Error
}
