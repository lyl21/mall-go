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

type OptometryDataApi struct{}

func (a *OptometryDataApi) CreateOptometryData(c *gin.Context) {
	var data optometryModel.OptometryData
	if err := c.ShouldBindJSON(&data); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := optometryDataService.CreateOptometryData(data); err != nil {
		global.GVA_LOG.Error("创建验光数据失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

func (a *OptometryDataApi) DeleteOptometryData(c *gin.Context) {
	var req struct {
		OptometryId int64 `json:"optometryId"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	if err := optometryDataService.DeleteOptometryData(req.OptometryId); err != nil {
		global.GVA_LOG.Error("删除验光数据失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (a *OptometryDataApi) UpdateOptometryData(c *gin.Context) {
	var data optometryModel.OptometryData
	if err := c.ShouldBindJSON(&data); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := optometryDataService.UpdateOptometryData(data); err != nil {
		global.GVA_LOG.Error("更新验光数据失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

func (a *OptometryDataApi) GetOptometryData(c *gin.Context) {
	idStr := c.Query("optometryId")
	if idStr == "" {
		idStr = c.Query("id")
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := optometryDataService.GetOptometryData(id)
	if err != nil {
		global.GVA_LOG.Error("获取验光数据失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

func (a *OptometryDataApi) GetOptometryDataList(c *gin.Context) {
	var req struct {
		request.PageInfo
		optometryModel.OptometryData
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := optometryDataService.GetOptometryDataList(req.PageInfo, req.OptometryData)
	if err != nil {
		global.GVA_LOG.Error("获取验光数据列表失败!", zap.Error(err))
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

// GetOptometryDataByType1 返回电脑验光仪(type1)和查片仪(type2)的透视表数据
func (a *OptometryDataApi) GetOptometryDataByType1(c *gin.Context) {
	recordsId, err := parseRecordsId(c)
	if err != nil {
		response.FailWithMessage("参数错误:optometryRecordsId必传", c)
		return
	}
	rows, err := optometryDataService.GetByRecordIdForType1(recordsId)
	if err != nil {
		global.GVA_LOG.Error("获取验光数据失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(gin.H{"list": rows}, "获取成功", c)
}

// GetOptometryDataByType2 返回验光头(type3)的透视表数据
func (a *OptometryDataApi) GetOptometryDataByType2(c *gin.Context) {
	recordsId, err := parseRecordsId(c)
	if err != nil {
		response.FailWithMessage("参数错误:optometryRecordsId必传", c)
		return
	}
	rows, err := optometryDataService.GetByRecordIdForType2(recordsId)
	if err != nil {
		global.GVA_LOG.Error("获取验光数据失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(gin.H{"list": rows}, "获取成功", c)
}

// GetOptometryDataByType3 返回最终配镜(type4)的透视表数据
func (a *OptometryDataApi) GetOptometryDataByType3(c *gin.Context) {
	recordsId, err := parseRecordsId(c)
	if err != nil {
		response.FailWithMessage("参数错误:optometryRecordsId必传", c)
		return
	}
	rows, err := optometryDataService.GetByRecordIdForType3(recordsId)
	if err != nil {
		global.GVA_LOG.Error("获取验光数据失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(gin.H{"list": rows}, "获取成功", c)
}

func parseRecordsId(c *gin.Context) (int64, error) {
	idStr := c.Query("optometryRecordsId")
	if idStr == "" {
		idStr = c.Query("recordsId")
	}
	return strconv.ParseInt(idStr, 10, 64)
}

