package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type StoreService struct{}

var StoreServiceApp = new(StoreService)

func (s *StoreService) CreateMxStore(store storeModel.MxStore, member storeModel.MxStoreMember) (err error) {
	err = global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(&store).Error; err != nil {
			return err
		}
		member.StoreId = store.StoreId
		member.Post = 1 // 店长
		if err := tx.Create(&member).Error; err != nil {
			return err
		}
		return nil
	})
	return err
}

func (s *StoreService) DeleteMxStore(store storeModel.MxStore) (err error) {
	err = global.GVA_DB.Model(&store).Where("store_id = ?", store.StoreId).Update("is_delete", 1).Error
	return err
}

func (s *StoreService) UpdateMxStore(store storeModel.MxStore) (err error) {
	err = global.GVA_DB.Save(&store).Error
	return err
}

func (s *StoreService) GetMxStore(id int64) (store storeModel.MxStore, err error) {
	err = global.GVA_DB.Where("store_id = ? AND is_delete = ?", id, 0).First(&store).Error
	return
}

func (s *StoreService) GetMxStoreList(info request.PageInfo, search string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&storeModel.MxStore{}).Where("is_delete = ?", 0)
	if search != "" {
		db = db.Where("store_name_english LIKE ?", "%"+search+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var storeList []storeModel.MxStore
	err = db.Limit(limit).Offset(offset).Find(&storeList).Error
	return storeList, total, err
}

func (s *StoreService) GetMxStoreById(storeId int64) (store storeModel.MxStore, err error) {
	err = global.GVA_DB.Where("store_id = ? AND is_delete = ?", storeId, 0).First(&store).Error
	return
}

// DeleteMxStoreByIds 批量逻辑删除门店
func (s *StoreService) DeleteMxStoreByIds(ids []int64) (err error) {
	err = global.GVA_DB.Model(&storeModel.MxStore{}).Where("store_id IN ?", ids).Update("is_delete", 1).Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return
}
