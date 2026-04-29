package store

import (
	"errors"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"go.uber.org/zap"
)

type StoreMemberService struct{}

var StoreMemberServiceApp = new(StoreMemberService)

func (s *StoreMemberService) CreateMxStoreMember(member storeModel.MxStoreMember) (err error) {
	if member.Post == 1 {
		// 检查门店是否已有店长
		var count int64
		if err := global.GVA_DB.Model(&storeModel.MxStoreMember{}).
			Where("store_id = ? AND post = 1 AND is_delete = 0", member.StoreId).
			Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return errors.New("该门店已有店长，不能重复添加")
		}
	}
	err = global.GVA_DB.Create(&member).Error
	return err
}

func (s *StoreMemberService) DeleteMxStoreMember(storeId int64, userId int64) (err error) {
	err = global.GVA_DB.Model(&storeModel.MxStoreMember{}).
		Where("store_id = ? AND user_id = ?", storeId, userId).
		Update("is_delete", 1).Error
	return err
}

func (s *StoreMemberService) UpdateMxStoreMember(member storeModel.MxStoreMember) (err error) {
	if member.Post == 1 {
		var count int64
		if err := global.GVA_DB.Model(&storeModel.MxStoreMember{}).
			Where("store_id = ? AND post = 1 AND is_delete = 0 AND user_id != ?", member.StoreId, member.UserId).
			Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return errors.New("该门店已有店长，不能重复设置")
		}
	}
	err = global.GVA_DB.Model(&storeModel.MxStoreMember{}).
		Where("store_id = ? AND user_id = ?", member.StoreId, member.UserId).
		Updates(&member).Error
	return err
}

func (s *StoreMemberService) GetMxStoreMember(storeId int64, userId int64) (member storeModel.MxStoreMember, err error) {
	err = global.GVA_DB.Where("store_id = ? AND user_id = ? AND is_delete = ?", storeId, userId, 0).First(&member).Error
	return
}

func (s *StoreMemberService) GetMxStoreMemberByStoreIdUserIdPost(storeId int64, userId int64, post int) (member storeModel.MxStoreMember, err error) {
	db := global.GVA_DB.Where("store_id = ? AND user_id = ? AND is_delete = ?", storeId, userId, 0)
	if post > 0 {
		db = db.Where("post = ?", post)
	}
	err = db.First(&member).Error
	return
}

func (s *StoreMemberService) DeleteMxStoreMemberByStoreIds(storeIds []int64) (err error) {
	err = global.GVA_DB.Model(&storeModel.MxStoreMember{}).
		Where("store_id IN ?", storeIds).
		Update("is_delete", 1).Error
	return err
}

func (s *StoreMemberService) GetMxStoreMemberList(info request.PageInfo, storeId int64) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	
	if limit == 0 {
		limit = 10000
	}
	
	db := global.GVA_DB.Table("mx_store_member AS msm").
		Joins("LEFT JOIN mx_user AS mu ON mu.user_id = msm.user_id AND mu.is_delete = 0").
		Where("msm.store_id = ? AND msm.is_delete = ?", storeId, 0)
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var memberList []storeModel.MxStoreMemberWithUser
	err = db.Select("msm.*, mu.name AS username").Limit(limit).Offset(offset).Find(&memberList).Error
	return memberList, total, err
}

func (s *StoreMemberService) GetStoreMemberByUserId(userId int64) (member storeModel.MxStoreMember, err error) {
	err = global.GVA_DB.Where("user_id = ? AND is_delete = ?", userId, 0).First(&member).Error
	return
}

func (s *StoreMemberService) IsManagerOrAssistant(storeId int64, userId int64) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&storeModel.MxStoreMember{}).
		Where("store_id = ? AND user_id = ? AND post IN (1, 2) AND is_delete = ?", storeId, userId, 0).
		Count(&count).Error
	if err != nil {
		global.GVA_LOG.Error("查询成员角色失败!", zap.Error(err))
		return false, err
	}
	return count > 0, nil
}
