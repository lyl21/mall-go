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

type VisionTestResultApi struct{}

func (a *VisionTestResultApi) CreateVisionTestResult(c *gin.Context) {
	var result optometryModel.VisionTestResult
	if err := c.ShouldBindJSON(&result); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := visionTestResultService.CreateVisionTestResult(result); err != nil {
		global.GVA_LOG.Error("创建视图验光结果失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

func (a *VisionTestResultApi) DeleteVisionTestResult(c *gin.Context) {
	var req struct {
		ResultsId int64 `json:"resultsId"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	if err := visionTestResultService.DeleteVisionTestResult(req.ResultsId); err != nil {
		global.GVA_LOG.Error("删除视图验光结果失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (a *VisionTestResultApi) UpdateVisionTestResult(c *gin.Context) {
	var result optometryModel.VisionTestResult
	if err := c.ShouldBindJSON(&result); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := visionTestResultService.UpdateVisionTestResult(result); err != nil {
		global.GVA_LOG.Error("更新视图验光结果失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

func (a *VisionTestResultApi) GetVisionTestResult(c *gin.Context) {
	idStr := c.Query("resultsId")
	if idStr == "" {
		idStr = c.Query("id")
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	result, err := visionTestResultService.GetVisionTestResult(id)
	if err != nil {
		global.GVA_LOG.Error("获取视图验光结果失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(result, "获取成功", c)
}

func (a *VisionTestResultApi) GetVisionTestResultList(c *gin.Context) {
	var req struct {
		request.PageInfo
		optometryModel.VisionTestResult
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := visionTestResultService.GetVisionTestResultList(req.PageInfo, req.VisionTestResult)
	if err != nil {
		global.GVA_LOG.Error("获取视图验光结果列表失败!", zap.Error(err))
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

// GetVisionTestAndTryOn 返回指定验光记录的视力检测结果和试戴数据
func (a *VisionTestResultApi) GetVisionTestAndTryOn(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	if idStr == "" {
		idStr = c.Query("recordsId")
	}
	recordsId, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || recordsId == 0 {
		response.FailWithMessage("参数错误:optometryRecordsId必传", c)
		return
	}
	result, err := visionTestResultService.GetVisionTestAndTryOn(recordsId)
	if err != nil {
		global.GVA_LOG.Error("获取视力检测及试戴数据失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(result, "获取成功", c)
}
