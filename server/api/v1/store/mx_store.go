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

type StoreApi struct{}

// CreateMxStore
// @Tags      MxStore
// @Summary   创建门店
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{store=storeModel.MxStore,member=storeModel.MxStoreMember}  true  "门店信息+成员信息"
// @Success   200   {object}  response.Response{msg=string}  "创建门店"
// @Router    /store/mxStore [post]
func (s *StoreApi) CreateMxStore(c *gin.Context) {
	var req struct {
		Store  storeModel.MxStore      `json:"store"`
		Member storeModel.MxStoreMember `json:"member"`
	}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = storeService.CreateMxStore(req.Store, req.Member)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteMxStore
// @Tags      MxStore
// @Summary   删除门店
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxStore              true  "门店ID"
// @Success   200   {object}  response.Response{msg=string}  "删除门店"
// @Router    /store/mxStore [delete]
func (s *StoreApi) DeleteMxStore(c *gin.Context) {
	var store storeModel.MxStore
	err := c.ShouldBindJSON(&store)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = storeService.DeleteMxStore(store)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxStore
// @Tags      MxStore
// @Summary   更新门店
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxStore              true  "门店信息"
// @Success   200   {object}  response.Response{msg=string}  "更新门店"
// @Router    /store/mxStore [put]
func (s *StoreApi) UpdateMxStore(c *gin.Context) {
	var store storeModel.MxStore
	err := c.ShouldBindJSON(&store)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = storeService.UpdateMxStore(store)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxStore
// @Tags      MxStore
// @Summary   获取门店信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     storeId  query     int64                                   true  "门店ID"
// @Success   200      {object}  response.Response{data=storeModel.MxStore,msg=string}  "获取门店信息"
// @Router    /store/mxStore [get]
func (s *StoreApi) GetMxStore(c *gin.Context) {
	storeIdStr := c.Query("storeId")
	storeId, err := strconv.ParseInt(storeIdStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := storeService.GetMxStore(storeId)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxStoreList
// @Tags      MxStore
// @Summary   分页获取门店列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                true  "页码"
// @Param     pageSize  query     int                                true  "每页大小"
// @Param     search    query     string                             false "搜索关键词"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取门店列表"
// @Router    /store/mxStoreList [get]
func (s *StoreApi) GetMxStoreList(c *gin.Context) {
	var pageInfo request.PageInfo
	var search string
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	search = c.Query("search")
	list, total, err := storeService.GetMxStoreList(pageInfo, search)
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
