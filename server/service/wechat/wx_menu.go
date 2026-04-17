package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"go.uber.org/zap"
)

type WxMenuService struct{}

var WxMenuServiceApp = new(WxMenuService)

func (s *WxMenuService) CreateWxMenu(menu wechatModel.WxMenu) (err error) {
	err = global.GVA_DB.Create(&menu).Error
	return err
}

func (s *WxMenuService) DeleteWxMenu(menu wechatModel.WxMenu) (err error) {
	err = global.GVA_DB.Model(&menu).Where("id = ?", menu.Id).Update("del_flag", "1").Error
	return err
}

func (s *WxMenuService) UpdateWxMenu(menu wechatModel.WxMenu) (err error) {
	err = global.GVA_DB.Save(&menu).Error
	return err
}

func (s *WxMenuService) GetWxMenu(id string) (menu wechatModel.WxMenu, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&menu).Error
	return
}

func (s *WxMenuService) GetWxMenuList(info request.PageInfo) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&wechatModel.WxMenu{}).Where("del_flag = ?", "0")
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var menuList []wechatModel.WxMenu
	err = db.Order("sort ASC").Limit(limit).Offset(offset).Find(&menuList).Error
	return menuList, total, err
}

func (s *WxMenuService) GetWxMenuTree() (list []wechatModel.WxMenu, err error) {
	err = global.GVA_DB.Where("del_flag = ?", "0").Order("sort ASC").Find(&list).Error
	return
}

// DeleteWxMenuByIds 批量逻辑删除微信菜单
func (s *WxMenuService) DeleteWxMenuByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&wechatModel.WxMenu{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return
}
