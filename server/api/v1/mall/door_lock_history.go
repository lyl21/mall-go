package mall

import (
	"fmt"
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type DoorLockHistoryApi struct{}

// CreateDoorLockHistory
// @Tags      DoorLockHistory
// @Summary   创建门锁操作历史
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.DoorLockHistory                   true  "门锁历史信息"
// @Success   200   {object}  response.Response{msg=string}              "创建门锁操作历史"
// @Router    /mall/doorLockHistory [post]
func (a *DoorLockHistoryApi) CreateDoorLockHistory(c *gin.Context) {
	var history mallModel.DoorLockHistory
	err := c.ShouldBindJSON(&history)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = doorLockHistoryService.CreateDoorLockHistory(history)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteDoorLockHistory
// @Tags      DoorLockHistory
// @Summary   删除门锁操作历史
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]interface{}                      true  "历史ID"
// @Success   200   {object}  response.Response{msg=string}              "删除门锁操作历史"
// @Router    /mall/doorLockHistory [delete]
func (a *DoorLockHistoryApi) DeleteDoorLockHistory(c *gin.Context) {
	var req map[string]interface{}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	idVal, ok := req["id"]
	if !ok {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	id, err := strconv.ParseInt(fmt.Sprintf("%v", idVal), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	err = doorLockHistoryService.DeleteDoorLockHistory(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateDoorLockHistory
// @Tags      DoorLockHistory
// @Summary   更新门锁操作历史
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.DoorLockHistory                   true  "门锁历史信息"
// @Success   200   {object}  response.Response{msg=string}              "更新门锁操作历史"
// @Router    /mall/doorLockHistory [put]
func (a *DoorLockHistoryApi) UpdateDoorLockHistory(c *gin.Context) {
	var history mallModel.DoorLockHistory
	err := c.ShouldBindJSON(&history)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = doorLockHistoryService.UpdateDoorLockHistory(history)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetDoorLockHistory
// @Tags      DoorLockHistory
// @Summary   获取门锁操作历史信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     int64                                         true  "历史ID"
// @Success   200  {object}  response.Response{data=mallModel.DoorLockHistory,msg=string}  "获取门锁操作历史信息"
// @Router    /mall/doorLockHistory [get]
func (a *DoorLockHistoryApi) GetDoorLockHistory(c *gin.Context) {
	idStr := c.Query("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := doorLockHistoryService.GetDoorLockHistory(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetDoorLockHistoryList
// @Tags      DoorLockHistory
// @Summary   分页获取门锁操作历史列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                    true  "页码"
// @Param     pageSize  query     int                                    true  "每页大小"
// @Param     doorGuid  query     string                                 false "门禁ID"
// @Param     openId    query     string                                 false "用户标识"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取门锁操作历史列表"
// @Router    /mall/doorLockHistoryList [get]
func (a *DoorLockHistoryApi) GetDoorLockHistoryList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	doorGuid := c.Query("doorGuid")
	openId := c.Query("openId")
	list, total, err := doorLockHistoryService.GetDoorLockHistoryList(pageInfo, doorGuid, openId)
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
