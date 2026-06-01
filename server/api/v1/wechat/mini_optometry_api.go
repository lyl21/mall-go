package wechat

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"

	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
)

type MiniOptometryApi struct{}

// GetOptometryListByOpenid 获取用户验光记录列表
// @Tags      MiniOptometry
// @Summary   获取用户验光记录列表
// @Produce   application/json
// @Param     openid  query     string  true   "用户openid"
// @Success   200     {object}  response.Response{data=[]optometryModel.OptometryRecord}  "获取成功"
// @Router    /mini/optometry/list [get]
func (a *MiniOptometryApi) GetOptometryListByOpenid(c *gin.Context) {
	openid := c.Query("openid")
	if openid == "" {
		response.FailWithMessage("参数错误", c)
		return
	}
	var list []optometryModel.OptometryRecord
	err := global.GVA_DB.Where("open_id = ? AND is_delete = ?", openid, 0).Order("create_time DESC").Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取验光记录列表失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(list, "获取成功", c)
}

// GetOptometryDetail 获取验光记录详情
// @Tags      MiniOptometry
// @Summary   获取验光记录详情
// @Produce   application/json
// @Param     optometryRecordsId  path     int  true   "验光记录ID"
// @Success   200                 {object}  response.Response{data=optometryModel.OptometryRecord}  "获取成功"
// @Router    /mini/optometry/{optometryRecordsId} [get]
func (a *MiniOptometryApi) GetOptometryDetail(c *gin.Context) {
	idStr := c.Param("optometryRecordsId")
	if idStr == "" {
		idStr = c.Query("optometryRecordsId")
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	var record optometryModel.OptometryRecord
	err = global.GVA_DB.Where("optometry_records_id = ? AND is_delete = ?", id, 0).First(&record).Error
	if err != nil {
		global.GVA_LOG.Error("获取验光记录失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(record, "获取成功", c)
}

// GetOptometryDataList 获取验光数据列表
// @Tags      MiniOptometry
// @Summary   获取验光数据列表
// @Produce   application/json
// @Param     optometryRecordsId  query     int  true   "验光记录ID"
// @Success   200                 {object}  response.Response{data=[]optometryModel.OptometryData}  "获取成功"
// @Router    /mini/optometry/data/list [get]
func (a *MiniOptometryApi) GetOptometryDataList(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	var list []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ?", id).Order("type ASC, left_right_eyes ASC").Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取验光数据列表失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(list, "获取成功", c)
}

// GetOptometryHead 获取验光头数据
// @Tags      MiniOptometry
// @Summary   获取验光头数据
// @Produce   application/json
// @Param     optometryRecordsId  query     int  true   "验光记录ID"
// @Success   200                 {object}  response.Response{data=[]optometryModel.OptometryData}  "获取成功"
// @Router    /mini/optometry/data/t2 [get]
func (a *MiniOptometryApi) GetOptometryHead(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	var list []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ? AND type = ?", id, 3).Order("left_right_eyes ASC").Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取验光头数据失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(list, "获取成功", c)
}

// GetOptometryFinal 获取最终配镜数据
// @Tags      MiniOptometry
// @Summary   获取最终配镜数据
// @Produce   application/json
// @Param     optometryRecordsId  query     int  true   "验光记录ID"
// @Success   200                 {object}  response.Response{data=[]optometryModel.OptometryData}  "获取成功"
// @Router    /mini/optometry/data/t3 [get]
func (a *MiniOptometryApi) GetOptometryFinal(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	var list []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ? AND type = ?", id, 4).Order("left_right_eyes ASC").Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取最终配镜数据失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(list, "获取成功", c)
}

// GetOptometryByRecordsId 获取验光单二
// @Tags      MiniOptometry
// @Summary   获取验光单二
// @Produce   application/json
// @Param     optometryRecordsId  query     int  true   "验光记录ID"
// @Success   200                 {object}  response.Response{data=interface{}}  "获取成功"
// @Router    /mini/optometry/vision [get]
func (a *MiniOptometryApi) GetOptometryByRecordsId(c *gin.Context) {
	idStr := c.Query("optometryRecordsId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}

	type Result struct {
		TryOptometryList  []optometryModel.TryOptometry    `json:"tryOptometryList"`
		VisionTestResults *optometryModel.VisionTestResult `json:"visionTestResults"`
	}

	result := Result{}

	// 查询试戴数据
	err = global.GVA_DB.Where("optometry_records_id = ?", id).Find(&result.TryOptometryList).Error
	if err != nil {
		global.GVA_LOG.Error("获取试戴数据失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}

	// 查询视力测试结果
	err = global.GVA_DB.Where("optometry_records_id = ?", id).First(&result.VisionTestResults).Error
	if err != nil && err.Error() != "record not found" {
		global.GVA_LOG.Error("获取视力测试结果失败", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}

	response.OkWithDetailed(result, "获取成功", c)
}
