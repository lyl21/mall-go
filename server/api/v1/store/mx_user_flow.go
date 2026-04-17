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

type UserFlowApi struct{}

// CreateMxUserFlow
// @Tags      MxUserFlow
// @Summary   创建用户流程
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUserFlow            true  "流程信息"
// @Success   200   {object}  response.Response{msg=string}   "创建流程"
// @Router    /store/mxUserFlow [post]
func (u *UserFlowApi) CreateMxUserFlow(c *gin.Context) {
	var flow storeModel.MxUserFlow
	err := c.ShouldBindJSON(&flow)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userFlowService.CreateMxUserFlow(flow)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteMxUserFlow
// @Tags      MxUserFlow
// @Summary   删除用户流程
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUserFlow            true  "流程信息"
// @Success   200   {object}  response.Response{msg=string}   "删除流程"
// @Router    /store/mxUserFlow [delete]
func (u *UserFlowApi) DeleteMxUserFlow(c *gin.Context) {
	var flow storeModel.MxUserFlow
	err := c.ShouldBindJSON(&flow)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userFlowService.DeleteMxUserFlow(flow)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxUserFlow
// @Tags      MxUserFlow
// @Summary   更新用户流程
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUserFlow            true  "流程信息"
// @Success   200   {object}  response.Response{msg=string}   "更新流程"
// @Router    /store/mxUserFlow [put]
func (u *UserFlowApi) UpdateMxUserFlow(c *gin.Context) {
	var flow storeModel.MxUserFlow
	err := c.ShouldBindJSON(&flow)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userFlowService.UpdateMxUserFlow(flow)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxUserFlow
// @Tags      MxUserFlow
// @Summary   获取用户流程
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     flowId  query     int64                                      true  "流程ID"
// @Success   200     {object}  response.Response{data=storeModel.MxUserFlow,msg=string}  "获取流程"
// @Router    /store/mxUserFlow [get]
func (u *UserFlowApi) GetMxUserFlow(c *gin.Context) {
	flowIdStr := c.Query("flowId")
	flowId, err := strconv.ParseInt(flowIdStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := userFlowService.GetMxUserFlow(flowId)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxUserFlowList
// @Tags      MxUserFlow
// @Summary   分页获取用户流程列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Param     userId   query     int64                              true  "用户ID"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取流程列表"
// @Router    /store/mxUserFlowList [get]
func (u *UserFlowApi) GetMxUserFlowList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	userId, err := strconv.ParseInt(c.Query("userId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	list, total, err := userFlowService.GetMxUserFlowList(pageInfo, userId)
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

// UpsertMxUserFlow
// @Tags      MxUserFlow
// @Summary   创建或更新用户流程
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUserFlow            true  "流程信息"
// @Success   200   {object}  response.Response{msg=string}   "创建或更新流程"
// @Router    /store/mxUserFlow/upsert [post]
func (u *UserFlowApi) UpsertMxUserFlow(c *gin.Context) {
	var flow storeModel.MxUserFlow
	err := c.ShouldBindJSON(&flow)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userFlowService.UpsertMxUserFlow(flow)
	if err != nil {
		global.GVA_LOG.Error("操作失败!", zap.Error(err))
		response.FailWithMessage("操作失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("操作成功", c)
}
