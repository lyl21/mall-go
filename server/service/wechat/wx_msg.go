package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"go.uber.org/zap"
)

type WxMsgService struct{}

var WxMsgServiceApp = new(WxMsgService)

func (s *WxMsgService) CreateWxMsg(msg wechatModel.WxMsg) (err error) {
	err = global.GVA_DB.Create(&msg).Error
	return err
}

func (s *WxMsgService) DeleteWxMsg(msg wechatModel.WxMsg) (err error) {
	err = global.GVA_DB.Model(&msg).Where("id = ?", msg.Id).Update("del_flag", "1").Error
	return err
}

func (s *WxMsgService) UpdateWxMsg(msg wechatModel.WxMsg) (err error) {
	err = global.GVA_DB.Save(&msg).Error
	return err
}

func (s *WxMsgService) GetWxMsg(id string) (msg wechatModel.WxMsg, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&msg).Error
	return
}

func (s *WxMsgService) GetWxMsgList(info request.PageInfo, nickName string, msgType string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&wechatModel.WxMsg{}).Where("del_flag = ?", "0")
	if nickName != "" {
		db = db.Where("nick_name LIKE ?", "%"+nickName+"%")
	}
	if msgType != "" {
		db = db.Where("type = ?", msgType)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var msgList []wechatModel.WxMsg
	err = db.Limit(limit).Offset(offset).Find(&msgList).Error
	return msgList, total, err
}

func (s *WxMsgService) GetWxMsgListByUserId(userId string) (list []wechatModel.WxMsg, err error) {
	err = global.GVA_DB.Where("wx_user_id = ? AND del_flag = ?", userId, "0").Find(&list).Error
	return
}

// DeleteWxMsgByIds 批量逻辑删除微信消息
func (s *WxMsgService) DeleteWxMsgByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&wechatModel.WxMsg{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return
}
