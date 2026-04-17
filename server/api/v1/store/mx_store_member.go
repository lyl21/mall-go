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

type StoreMemberApi struct{}

// CreateMxStoreMember
// @Tags      MxStoreMember
// @Summary   添加门店成员
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxStoreMember        true  "成员信息"
// @Success   200   {object}  response.Response{msg=string}  "添加成员"
// @Router    /store/mxStoreMember [post]
func (s *StoreMemberApi) CreateMxStoreMember(c *gin.Context) {
	var member storeModel.MxStoreMember
	err := c.ShouldBindJSON(&member)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = storeMemberService.CreateMxStoreMember(member)
	if err != nil {
		global.GVA_LOG.Error("添加失败!", zap.Error(err))
		response.FailWithMessage("添加失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("添加成功", c)
}

// DeleteMxStoreMember
// @Tags      MxStoreMember
// @Summary   删除门店成员
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     storeId  query     int64                              true  "门店ID"
// @Param     userId   query     int64                              true  "用户ID"
// @Success   200      {object}  response.Response{msg=string}      "删除成员"
// @Router    /store/mxStoreMember [delete]
func (s *StoreMemberApi) DeleteMxStoreMember(c *gin.Context) {
	storeId, err := strconv.ParseInt(c.Query("storeId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	userId, err := strconv.ParseInt(c.Query("userId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	err = storeMemberService.DeleteMxStoreMember(storeId, userId)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxStoreMember
// @Tags      MxStoreMember
// @Summary   更新门店成员
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxStoreMember        true  "成员信息"
// @Success   200   {object}  response.Response{msg=string}  "更新成员"
// @Router    /store/mxStoreMember [put]
func (s *StoreMemberApi) UpdateMxStoreMember(c *gin.Context) {
	var member storeModel.MxStoreMember
	err := c.ShouldBindJSON(&member)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = storeMemberService.UpdateMxStoreMember(member)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxStoreMember
// @Tags      MxStoreMember
// @Summary   获取门店成员
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     storeId  query     int64                                         true  "门店ID"
// @Param     userId   query     int64                                         true  "用户ID"
// @Success   200      {object}  response.Response{data=storeModel.MxStoreMember,msg=string}  "获取成员"
// @Router    /store/mxStoreMember [get]
func (s *StoreMemberApi) GetMxStoreMember(c *gin.Context) {
	storeId, err := strconv.ParseInt(c.Query("storeId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	userId, err := strconv.ParseInt(c.Query("userId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := storeMemberService.GetMxStoreMember(storeId, userId)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxStoreMemberList
// @Tags      MxStoreMember
// @Summary   分页获取门店成员列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Param     storeId  query     int64                              true  "门店ID"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取成员列表"
// @Router    /store/mxStoreMemberList [get]
func (s *StoreMemberApi) GetMxStoreMemberList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	storeId, err := strconv.ParseInt(c.Query("storeId"), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	list, total, err := storeMemberService.GetMxStoreMemberList(pageInfo, storeId)
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
