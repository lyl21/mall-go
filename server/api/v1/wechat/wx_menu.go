package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type WxMenuApi struct{}

// CreateWxMenu
// @Tags      WxMenu
// @Summary   创建微信菜单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMenu               true  "微信菜单信息"
// @Success   200   {object}  response.Response{msg=string}   "创建微信菜单"
// @Router    /wxMenu/createWxMenu [post]
func (m *WxMenuApi) CreateWxMenu(c *gin.Context) {
	var menu wechatModel.WxMenu
	err := c.ShouldBindJSON(&menu)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMenuService.CreateWxMenu(menu)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteWxMenu
// @Tags      WxMenu
// @Summary   删除微信菜单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMenu               true  "微信菜单"
// @Success   200   {object}  response.Response{msg=string}   "删除微信菜单"
// @Router    /wxMenu/deleteWxMenu [delete]
func (m *WxMenuApi) DeleteWxMenu(c *gin.Context) {
	var menu wechatModel.WxMenu
	err := c.ShouldBindJSON(&menu)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMenuService.DeleteWxMenu(menu)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateWxMenu
// @Tags      WxMenu
// @Summary   更新微信菜单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      wechatModel.WxMenu               true  "微信菜单信息"
// @Success   200   {object}  response.Response{msg=string}   "更新微信菜单"
// @Router    /wxMenu/updateWxMenu [put]
func (m *WxMenuApi) UpdateWxMenu(c *gin.Context) {
	var menu wechatModel.WxMenu
	err := c.ShouldBindJSON(&menu)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = wxMenuService.UpdateWxMenu(menu)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetWxMenu
// @Tags      WxMenu
// @Summary   获取微信菜单信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                  true  "菜单ID"
// @Success   200  {object}  response.Response{data=wechatModel.WxMenu,msg=string}  "获取微信菜单信息"
// @Router    /wxMenu/getWxMenu [get]
func (m *WxMenuApi) GetWxMenu(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := wxMenuService.GetWxMenu(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetWxMenuList
// @Tags      WxMenu
// @Summary   分页获取微信菜单列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                true  "页码"
// @Param     pageSize  query     int                                true  "每页大小"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取微信菜单列表"
// @Router    /wxMenu/getWxMenuList [get]
func (m *WxMenuApi) GetWxMenuList(c *gin.Context) {
	var req request.PageInfo
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := wxMenuService.GetWxMenuList(req)
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

// GetWxMenuTree
// @Tags      WxMenu
// @Summary   获取微信菜单树
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]wechatModel.WxMenu,msg=string}  "获取微信菜单树"
// @Router    /wxMenu/getWxMenuTree [get]
func (m *WxMenuApi) GetWxMenuTree(c *gin.Context) {
	data, err := wxMenuService.GetWxMenuTree()
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}
