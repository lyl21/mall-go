package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"go.uber.org/zap"
)

type WxAutoReplyService struct{}

var WxAutoReplyServiceApp = new(WxAutoReplyService)

func (s *WxAutoReplyService) CreateWxAutoReply(reply wechatModel.WxAutoReply) (err error) {
	err = global.GVA_DB.Create(&reply).Error
	return err
}

func (s *WxAutoReplyService) DeleteWxAutoReply(reply wechatModel.WxAutoReply) (err error) {
	err = global.GVA_DB.Model(&reply).Where("id = ?", reply.Id).Update("del_flag", "1").Error
	return err
}

func (s *WxAutoReplyService) UpdateWxAutoReply(reply wechatModel.WxAutoReply) (err error) {
	err = global.GVA_DB.Save(&reply).Error
	return err
}

func (s *WxAutoReplyService) GetWxAutoReply(id string) (reply wechatModel.WxAutoReply, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&reply).Error
	return
}

func (s *WxAutoReplyService) GetWxAutoReplyList(info request.PageInfo, replyType string, reqKey string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&wechatModel.WxAutoReply{}).Where("del_flag = ?", "0")
	if replyType != "" {
		db = db.Where("type = ?", replyType)
	}
	if reqKey != "" {
		db = db.Where("req_key LIKE ?", "%"+reqKey+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var replyList []wechatModel.WxAutoReply
	err = db.Limit(limit).Offset(offset).Find(&replyList).Error
	return replyList, total, err
}

// GetReplyByKeyword 根据关键词获取自动回复（type=3 关键词回复）
func (s *WxAutoReplyService) GetReplyByKeyword(keyword string, reqType string) (reply wechatModel.WxAutoReply, err error) {
	db := global.GVA_DB.Model(&wechatModel.WxAutoReply{}).Where("del_flag = ?", "0").Where("type = ?", "3")
	if reqType != "" {
		db = db.Where("req_type = ?", reqType)
	}
	// 先查全匹配（repMate=1）
	err = db.Where("rep_mate = ? AND req_key = ?", "1", keyword).First(&reply).Error
	if err == nil {
		return
	}
	// 再查半匹配（repMate=2, LIKE）
	err = db.Where("rep_mate = ? AND req_key LIKE ?", "2", "%"+keyword+"%").First(&reply).Error
	return
}

// GetFollowReply 获取关注时回复（type=1）
func (s *WxAutoReplyService) GetFollowReply() (reply wechatModel.WxAutoReply, err error) {
	err = global.GVA_DB.Where("del_flag = ? AND type = ?", "0", "1").First(&reply).Error
	return
}

// GetDefaultReply 获取默认消息回复（type=2）
func (s *WxAutoReplyService) GetDefaultReply() (reply wechatModel.WxAutoReply, err error) {
	err = global.GVA_DB.Where("del_flag = ? AND type = ?", "0", "2").First(&reply).Error
	return
}

// DeleteWxAutoReplyByIds 批量逻辑删除自动回复
func (s *WxAutoReplyService) DeleteWxAutoReplyByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&wechatModel.WxAutoReply{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return
}
