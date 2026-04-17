package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type WxUserApi struct{}

// CreateWxUser
// @Tags      WxUser
// @Summary   创建微信用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxUser              true  "微信用户信息"
// @Success   200   {object}  response.Response{msg=string}   "创建微信用户"
// @Router    /wxUser/createWxUser [post]
func (u *WxUserApi) CreateWxUser(c *gin.Context) {
	var user wechatModel.WxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxUserService.CreateWxUser(user)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteWxUser
// @Tags      WxUser
// @Summary   删除微信用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxUser              true  "微信用户"
// @Success   200   {object}  response.Response{msg=string}   "删除微信用户"
// @Router    /wxUser/deleteWxUser [delete]
func (u *WxUserApi) DeleteWxUser(c *gin.Context) {
	var user wechatModel.WxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxUserService.DeleteWxUser(user)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateWxUser
// @Tags      WxUser
// @Summary   更新微信用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxUser              true  "微信用户信息"
// @Success   200   {object}  response.Response{msg=string}   "更新微信用户"
// @Router    /wxUser/updateWxUser [put]
func (u *WxUserApi) UpdateWxUser(c *gin.Context) {
	var user wechatModel.WxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxUserService.UpdateWxUser(user)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetWxUser
// @Tags      WxUser
// @Summary   获取微信用户信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                   true  "微信用户ID"
// @Success   200  {object}  response.Response{data=wechatModel.WxUser,msg=string}  "获取微信用户信息"
// @Router    /wxUser/getWxUser [get]
func (u *WxUserApi) GetWxUser(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := wxUserService.GetWxUser(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetWxUserList
// @Tags      WxUser
// @Summary   分页获取微信用户列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                true  "页码"
// @Param     pageSize  query     int                                true  "每页大小"
// @Param     nickName  query     string                             false "昵称搜索"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取微信用户列表"
// @Router    /wxUser/getWxUserList [get]
func (u *WxUserApi) GetWxUserList(c *gin.Context) {
	var req struct {
		request.PageInfo
		NickName string `json:"nickName"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := wxUserService.GetWxUserList(req.PageInfo, req.NickName)
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
