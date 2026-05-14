package optometry

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type ErrorReportLogApi struct{}

// GetErrorReportLogList 获取验光仪错误报告日志列表
// @Tags      ErrorReportLog
// @Summary   获取验光仪错误报告日志列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page        query     int     false  "页码"
// @Param     pageSize    query     int     false  "每页大小"
// @Param     equipmentId query     string  false  "设备ID"
// @Param     createTime  query     string  false  "创建日期(yyyy-MM-dd)"
// @Success   200         {object}  response.Response{data=response.PageResult}  "获取成功"
// @Router    /optometry/errorReportLogList [get]
func (a *ErrorReportLogApi) GetErrorReportLogList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	equipmentId := c.Query("equipmentId")
	createTime := c.Query("createTime")

	list, total, err := errorReportLogService.GetErrorReportLogList(pageInfo, equipmentId, createTime)
	if err != nil {
		global.GVA_LOG.Error("获取验光仪错误报告日志列表失败!", zap.Error(err))
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

// GetErrorReportLog 获取验光仪错误报告日志详情
// @Tags      ErrorReportLog
// @Summary   获取验光仪错误报告日志详情
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query  int64  true  "日志ID"
// @Success   200  {object}  response.Response{data=object}  "获取成功"
// @Router    /optometry/errorReportLog [get]
func (a *ErrorReportLogApi) GetErrorReportLog(c *gin.Context) {
	idStr := c.Query("id")
	if idStr == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	log, err := errorReportLogService.GetErrorReportLog(id)
	if err != nil {
		global.GVA_LOG.Error("获取验光仪错误报告日志详情失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(log, "获取成功", c)
}

// DeleteErrorReportLog 删除验光仪错误报告日志
// @Tags      ErrorReportLog
// @Summary   删除验光仪错误报告日志
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      request.GetById  true  "日志ID"
// @Success   200   {object}  response.Response{msg=string}  "删除成功"
// @Router    /optometry/errorReportLog [delete]
func (a *ErrorReportLogApi) DeleteErrorReportLog(c *gin.Context) {
	var idReq request.GetById
	err := c.ShouldBindJSON(&idReq)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = errorReportLogService.DeleteErrorReportLog(int64(idReq.ID))
	if err != nil {
		global.GVA_LOG.Error("删除验光仪错误报告日志失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// DeleteErrorReportLogByIds 批量删除验光仪错误报告日志
// @Tags      ErrorReportLog
// @Summary   批量删除验光仪错误报告日志
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      request.IdsReq  true  "日志ID数组"
// @Success   200   {object}  response.Response{msg=string}  "删除成功"
// @Router    /optometry/errorReportLogBatch [delete]
func (a *ErrorReportLogApi) DeleteErrorReportLogByIds(c *gin.Context) {
	var idsReq request.IdsReq
	err := c.ShouldBindJSON(&idsReq)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	ids := make([]int64, len(idsReq.Ids))
	for i, v := range idsReq.Ids {
		ids[i] = int64(v)
	}
	err = errorReportLogService.DeleteErrorReportLogByIds(ids)
	if err != nil {
		global.GVA_LOG.Error("批量删除验光仪错误报告日志失败!", zap.Error(err))
		response.FailWithMessage("批量删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("批量删除成功", c)
}
