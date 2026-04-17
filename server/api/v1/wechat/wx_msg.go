package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type WxMsgApi struct{}

// CreateWxMsg
// @Tags      WxMsg
// @Summary   创建微信消息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMsg                true  "微信消息信息"
// @Success   200   {object}  response.Response{msg=string}   "创建微信消息"
// @Router    /wxMsg/createWxMsg [post]
func (m *WxMsgApi) CreateWxMsg(c *gin.Context) {
	var msg wechatModel.WxMsg
	err := c.ShouldBindJSON(&msg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMsgService.CreateWxMsg(msg)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteWxMsg
// @Tags      WxMsg
// @Summary   删除微信消息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMsg                true  "微信消息"
// @Success   200   {object}  response.Response{msg=string}   "删除微信消息"
// @Router    /wxMsg/deleteWxMsg [delete]
func (m *WxMsgApi) DeleteWxMsg(c *gin.Context) {
	var msg wechatModel.WxMsg
	err := c.ShouldBindJSON(&msg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMsgService.DeleteWxMsg(msg)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateWxMsg
// @Tags      WxMsg
// @Summary   更新微信消息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMsg                true  "微信消息信息"
// @Success   200   {object}  response.Response{msg=string}   "更新微信消息"
// @Router    /wxMsg/updateWxMsg [put]
func (m *WxMsgApi) UpdateWxMsg(c *gin.Context) {
	var msg wechatModel.WxMsg
	err := c.ShouldBindJSON(&msg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMsgService.UpdateWxMsg(msg)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetWxMsg
// @Tags      WxMsg
// @Summary   获取微信消息信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                 true  "微信消息ID"
// @Success   200  {object}  response.Response{data=wechatModel.WxMsg,msg=string}  "获取微信消息信息"
// @Router    /wxMsg/getWxMsg [get]
func (m *WxMsgApi) GetWxMsg(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := wxMsgService.GetWxMsg(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetWxMsgList
// @Tags      WxMsg
// @Summary   分页获取微信消息列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                true  "页码"
// @Param     pageSize  query     int                                true  "每页大小"
// @Param     nickName  query     string                             false "昵称搜索"
// @Param     type      query     string                             false "消息类型"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取微信消息列表"
// @Router    /wxMsg/getWxMsgList [get]
func (m *WxMsgApi) GetWxMsgList(c *gin.Context) {
	var req struct {
		request.PageInfo
		NickName string `json:"nickName"`
		Type     string `json:"type"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := wxMsgService.GetWxMsgList(req.PageInfo, req.NickName, req.Type)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(response.PageResult{
		List:     list,
		Total:    total,
		Page:     req.Page,
		PageSize: req.PageSize,
	}, "获取成功", c)
}

// GetWxMsgListByUserId
// @Tags      WxMsg
// @Summary   根据用户ID获取消息列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     userId  query     string                                        true  "微信用户ID"
// @Success   200     {object}  response.Response{data=[]wechatModel.WxMsg,msg=string}  "获取消息列表"
// @Router    /wxMsg/getWxMsgListByUserId [get]
func (m *WxMsgApi) GetWxMsgListByUserId(c *gin.Context) {
	userId := c.Query("userId")
	if userId == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := wxMsgService.GetWxMsgListByUserId(userId)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}
