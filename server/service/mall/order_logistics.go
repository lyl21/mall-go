package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"go.uber.org/zap"
)

type OrderLogisticsService struct{}

var OrderLogisticsServiceApp = new(OrderLogisticsService)

func (s *OrderLogisticsService) CreateOrderLogistics(logistics mallModel.OrderLogistics) (err error) {
	err = global.GVA_DB.Create(&logistics).Error
	return err
}

func (s *OrderLogisticsService) DeleteOrderLogistics(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderLogistics{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *OrderLogisticsService) DeleteOrderLogisticsByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderLogistics{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *OrderLogisticsService) UpdateOrderLogistics(logistics mallModel.OrderLogistics) (err error) {
	err = global.GVA_DB.Model(&mallModel.OrderLogistics{}).Where("id = ?", logistics.Id).Updates(&logistics).Error
	return err
}

func (s *OrderLogisticsService) GetOrderLogistics(id string) (logistics mallModel.OrderLogistics, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&logistics).Error
	return
}

func (s *OrderLogisticsService) GetOrderLogisticsList(info request.PageInfo, logistics string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.OrderLogistics{}).Where("del_flag = ?", "0")
	if logistics != "" {
		db = db.Where("logistics = ?", logistics)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var logisticsList []mallModel.OrderLogistics
	err = db.Limit(limit).Offset(offset).Find(&logisticsList).Error
	return logisticsList, total, err
}
