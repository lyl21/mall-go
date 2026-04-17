package optometry

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type OptometryRecordApi struct{}

func (a *OptometryRecordApi) DeleteOptometryRecord(c *gin.Context) {
	var req struct {
		OptometryRecordsId int64 `json:"optometryRecordsId"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	if err := optometryRecordService.DeleteOptometryRecord(req.OptometryRecordsId); err != nil {
		global.GVA_LOG.Error("删除验光记录失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (a *OptometryRecordApi) UpdateOptometryRecord(c *gin.Context) {
	var record optometryModel.OptometryRecord
	if err := c.ShouldBindJSON(&record); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := optometryRecordService.UpdateOptometryRecord(record); err != nil {
		global.GVA_LOG.Error("更新验光记录失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

func (a *OptometryRecordApi) GetOptometryRecord(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	if idStr == "" {
		idStr = c.Query("id")
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	record, err := optometryRecordService.GetOptometryRecord(id)
	if err != nil {
		global.GVA_LOG.Error("获取验光记录失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(record, "获取成功", c)
}

func (a *OptometryRecordApi) GetOptometryRecordList(c *gin.Context) {
	var req struct {
		request.PageInfo
		optometryModel.OptometryRecord
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := optometryRecordService.GetOptometryRecordList(req.PageInfo, req.OptometryRecord)
	if err != nil {
		global.GVA_LOG.Error("获取验光记录列表失败!", zap.Error(err))
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
