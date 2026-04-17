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

type DoorLockApi struct{}

// OpenDoorRequest 远程开门请求参数
type OpenDoorRequest struct {
	Id     int64  `json:"id" binding:"required"`     // 门锁ID
	OpenId string `json:"openId" binding:"required"` // 用户标识
}

// CreateDoorLock
// @Tags      DoorLock
// @Summary   创建门锁
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.DoorLock                          true  "门锁信息"
// @Success   200   {object}  response.Response{msg=string}              "创建门锁"
// @Router    /mall/doorLock [post]
func (a *DoorLockApi) CreateDoorLock(c *gin.Context) {
	var lock mallModel.DoorLock
	err := c.ShouldBindJSON(&lock)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = doorLockService.CreateDoorLock(lock)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteDoorLock
// @Tags      DoorLock
// @Summary   删除门锁
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]interface{}                      true  "门锁ID"
// @Success   200   {object}  response.Response{msg=string}              "删除门锁"
// @Router    /mall/doorLock [delete]
func (a *DoorLockApi) DeleteDoorLock(c *gin.Context) {
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
	err = doorLockService.DeleteDoorLock(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateDoorLock
// @Tags      DoorLock
// @Summary   更新门锁
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.DoorLock                          true  "门锁信息"
// @Success   200   {object}  response.Response{msg=string}              "更新门锁"
// @Router    /mall/doorLock [put]
func (a *DoorLockApi) UpdateDoorLock(c *gin.Context) {
	var lock mallModel.DoorLock
	err := c.ShouldBindJSON(&lock)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = doorLockService.UpdateDoorLock(lock)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetDoorLock
// @Tags      DoorLock
// @Summary   获取门锁信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     int64                                         true  "门锁ID"
// @Success   200  {object}  response.Response{data=mallModel.DoorLock,msg=string}  "获取门锁信息"
// @Router    /mall/doorLock [get]
func (a *DoorLockApi) GetDoorLock(c *gin.Context) {
	idStr := c.Query("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := doorLockService.GetDoorLock(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetDoorLockList
// @Tags      DoorLock
// @Summary   分页获取门锁列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                    true  "页码"
// @Param     pageSize  query     int                                    true  "每页大小"
// @Param     doorName  query     string                                 false "门禁名称"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取门锁列表"
// @Router    /mall/doorLockList [get]
func (a *DoorLockApi) GetDoorLockList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	doorName := c.Query("doorName")
	list, total, err := doorLockService.GetDoorLockList(pageInfo, doorName)
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

// OpenDoor
// @Tags      DoorLock
// @Summary   远程开门
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      OpenDoorRequest                             true  "开门参数"
// @Success   200   {object}  response.Response{data=string,msg=string}  "远程开门"
// @Router    /mall/doorLock/open [post]
func (a *DoorLockApi) OpenDoor(c *gin.Context) {
	var req OpenDoorRequest
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	result, err := doorLockService.OpenDoor(req.Id, req.OpenId)
	if err != nil {
		global.GVA_LOG.Error("开门失败!", zap.Error(err))
		response.FailWithMessage("开门失败:"+err.Error(), c)
		return
	}

	response.OkWithDetailed(result, "开门成功", c)
}
