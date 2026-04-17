package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type WxAutoReplyApi struct{}

// CreateWxAutoReply
// @Tags      WxAutoReply
// @Summary   创建微信自动回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxAutoReply         true  "微信自动回复信息"
// @Success   200   {object}  response.Response{msg=string}   "创建微信自动回复"
// @Router    /wxAutoReply/createWxAutoReply [post]
func (a *WxAutoReplyApi) CreateWxAutoReply(c *gin.Context) {
	var reply wechatModel.WxAutoReply
	err := c.ShouldBindJSON(&reply)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxAutoReplyService.CreateWxAutoReply(reply)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteWxAutoReply
// @Tags      WxAutoReply
// @Summary   删除微信自动回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxAutoReply         true  "微信自动回复"
// @Success   200   {object}  response.Response{msg=string}   "删除微信自动回复"
// @Router    /wxAutoReply/deleteWxAutoReply [delete]
func (a *WxAutoReplyApi) DeleteWxAutoReply(c *gin.Context) {
	var reply wechatModel.WxAutoReply
	err := c.ShouldBindJSON(&reply)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxAutoReplyService.DeleteWxAutoReply(reply)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateWxAutoReply
// @Tags      WxAutoReply
// @Summary   更新微信自动回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxAutoReply         true  "微信自动回复信息"
// @Success   200   {object}  response.Response{msg=string}   "更新微信自动回复"
// @Router    /wxAutoReply/updateWxAutoReply [put]
func (a *WxAutoReplyApi) UpdateWxAutoReply(c *gin.Context) {
	var reply wechatModel.WxAutoReply
	err := c.ShouldBindJSON(&reply)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxAutoReplyService.UpdateWxAutoReply(reply)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetWxAutoReply
// @Tags      WxAutoReply
// @Summary   获取微信自动回复信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                       true  "自动回复ID"
// @Success   200  {object}  response.Response{data=wechatModel.WxAutoReply,msg=string}  "获取微信自动回复信息"
// @Router    /wxAutoReply/getWxAutoReply [get]
func (a *WxAutoReplyApi) GetWxAutoReply(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := wxAutoReplyService.GetWxAutoReply(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetWxAutoReplyList
// @Tags      WxAutoReply
// @Summary   分页获取微信自动回复列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                true  "页码"
// @Param     pageSize  query     int                                true  "每页大小"
// @Param     type      query     string                             false "回复类型"
// @Param     reqKey    query     string                             false "关键词搜索"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取微信自动回复列表"
// @Router    /wxAutoReply/getWxAutoReplyList [get]
func (a *WxAutoReplyApi) GetWxAutoReplyList(c *gin.Context) {
	var req struct {
		request.PageInfo
		Type   string `json:"type"`
		ReqKey string `json:"reqKey"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := wxAutoReplyService.GetWxAutoReplyList(req.PageInfo, req.Type, req.ReqKey)
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

// GetReplyByKeyword
// @Tags      WxAutoReply
// @Summary   根据关键词获取自动回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     keyword  query     string                                           true  "关键词"
// @Param     reqType  query     string                                           false "请求消息类型"
// @Success   200      {object}  response.Response{data=wechatModel.WxAutoReply,msg=string}  "获取自动回复"
// @Router    /wxAutoReply/getReplyByKeyword [get]
func (a *WxAutoReplyApi) GetReplyByKeyword(c *gin.Context) {
	keyword := c.Query("keyword")
	if keyword == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	reqType := c.Query("reqType")
	data, err := wxAutoReplyService.GetReplyByKeyword(keyword, reqType)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetFollowReply
// @Tags      WxAutoReply
// @Summary   获取关注时回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{data=wechatModel.WxAutoReply,msg=string}  "获取关注时回复"
// @Router    /wxAutoReply/getFollowReply [get]
func (a *WxAutoReplyApi) GetFollowReply(c *gin.Context) {
	data, err := wxAutoReplyService.GetFollowReply()
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetDefaultReply
// @Tags      WxAutoReply
// @Summary   获取默认消息回复
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{data=wechatModel.WxAutoReply,msg=string}  "获取默认消息回复"
// @Router    /wxAutoReply/getDefaultReply [get]
func (a *WxAutoReplyApi) GetDefaultReply(c *gin.Context) {
	data, err := wxAutoReplyService.GetDefaultReply()
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}
