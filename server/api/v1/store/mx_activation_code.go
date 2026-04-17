package store

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type ActivationCodeApi struct{}

// CreateMxActivationCode
// @Tags      MxActivationCode
// @Summary   创建激活码
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxActivationCode        true  "激活码信息"
// @Success   200   {object}  response.Response{msg=string}      "创建激活码"
// @Router    /store/mxActivationCode [post]
func (a *ActivationCodeApi) CreateMxActivationCode(c *gin.Context) {
	var code storeModel.MxActivationCode
	err := c.ShouldBindJSON(&code)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = activationCodeService.CreateMxActivationCode(code)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteMxActivationCode
// @Tags      MxActivationCode
// @Summary   删除激活码
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxActivationCode        true  "激活码信息"
// @Success   200   {object}  response.Response{msg=string}      "删除激活码"
// @Router    /store/mxActivationCode [delete]
func (a *ActivationCodeApi) DeleteMxActivationCode(c *gin.Context) {
	var code storeModel.MxActivationCode
	err := c.ShouldBindJSON(&code)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = activationCodeService.DeleteMxActivationCode(code)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxActivationCode
// @Tags      MxActivationCode
// @Summary   更新激活码
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxActivationCode        true  "激活码信息"
// @Success   200   {object}  response.Response{msg=string}      "更新激活码"
// @Router    /store/mxActivationCode [put]
func (a *ActivationCodeApi) UpdateMxActivationCode(c *gin.Context) {
	var code storeModel.MxActivationCode
	err := c.ShouldBindJSON(&code)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = activationCodeService.UpdateMxActivationCode(code)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxActivationCode
// @Tags      MxActivationCode
// @Summary   获取激活码
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     activationId  query     int64                                                 true  "激活码ID"
// @Success   200           {object}  response.Response{data=storeModel.MxActivationCode,msg=string}  "获取激活码"
// @Router    /store/mxActivationCode [get]
func (a *ActivationCodeApi) GetMxActivationCode(c *gin.Context) {
	idStr := c.Query("activationId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := activationCodeService.GetMxActivationCode(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxActivationCodeList
// @Tags      MxActivationCode
// @Summary   分页获取激活码列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取激活码列表"
// @Router    /store/mxActivationCodeList [get]
func (a *ActivationCodeApi) GetMxActivationCodeList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := activationCodeService.GetMxActivationCodeList(pageInfo)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(response.PageResult{
		List:     list,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}

// GenerateActivationCode
// @Tags      MxActivationCode
// @Summary   生成激活码
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     app  query     string                            true  "应用名称"
// @Param     equipment  query     string                            true  "设备ID"
// @Success   200        {object}  response.Response{data=string,msg=string}  "生成激活码"
// @Router    /store/mxActivationCode/generate [post]
func (a *ActivationCodeApi) GenerateActivationCode(c *gin.Context) {
	app := c.Query("app")
	equipment := c.Query("equipment")
	if app == "" {
		response.FailWithMessage("应用名称不能为空", c)
		return
	}
	if equipment == "" {
		response.FailWithMessage("设备ID不能为空", c)
		return
	}
	code, err := activationCodeService.GenerateActivationCode(app, equipment)
	if err != nil {
		global.GVA_LOG.Error("生成失败!", zap.Error(err))
		response.FailWithMessage("生成失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(code, "生成成功", c)
}
