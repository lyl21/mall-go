package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"go.uber.org/zap"
)

type WxUserService struct{}

var WxUserServiceApp = new(WxUserService)

func (s *WxUserService) CreateWxUser(user wechatModel.WxUser) (err error) {
	err = global.GVA_DB.Create(&user).Error
	return err
}

func (s *WxUserService) DeleteWxUser(user wechatModel.WxUser) (err error) {
	err = global.GVA_DB.Model(&user).Where("id = ?", user.Id).Update("del_flag", "1").Error
	return err
}

func (s *WxUserService) UpdateWxUser(user wechatModel.WxUser) (err error) {
	err = global.GVA_DB.Save(&user).Error
	return err
}

func (s *WxUserService) GetWxUser(id string) (user wechatModel.WxUser, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&user).Error
	return
}

func (s *WxUserService) GetWxUserList(info request.PageInfo, nickName string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&wechatModel.WxUser{}).Where("del_flag = ?", "0")
	if nickName != "" {
		db = db.Where("nick_name LIKE ?", "%"+nickName+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var userList []wechatModel.WxUser
	err = db.Limit(limit).Offset(offset).Find(&userList).Error
	return userList, total, err
}

func (s *WxUserService) GetWxUserByOpenId(openId string) (user wechatModel.WxUser, err error) {
	err = global.GVA_DB.Where("open_id = ? AND del_flag = ?", openId, "0").First(&user).Error
	return
}

// DeleteWxUserByIds 批量逻辑删除微信用户
func (s *WxUserService) DeleteWxUserByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&wechatModel.WxUser{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return
}
