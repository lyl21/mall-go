package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	optometryService "github.com/flipped-aurora/gin-vue-admin/server/service/optometry"
	"github.com/gin-gonic/gin"
)

type ClientVisionTestResultApi struct{}

var ClientVisionTestResultApiApp = new(ClientVisionTestResultApi)

type VisionTestResultListReq struct {
	request.PageInfo
	OptometryRecordsId *int64 `json:"optometryRecordsId" form:"optometryRecordsId"`
}

func (a *ClientVisionTestResultApi) List(c *gin.Context) {
	var req VisionTestResultListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	search := optometry.VisionTestResult{}
	if req.OptometryRecordsId != nil {
		search.OptometryRecordsId = req.OptometryRecordsId
	}

	list, total, err := optometryService.VisionTestResultServiceApp.GetVisionTestResultList(req.PageInfo, search)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientVisionTestResultApi) GetInfo(c *gin.Context) {
	resultsIdStr := c.Param("resultsId")
	if resultsIdStr == "" {
		resultsIdStr = c.Query("resultsId")
	}

	if resultsIdStr == "" {
		ClientFailWithMessage("结果ID不能为空", c)
		return
	}

	resultsId, err := strconv.ParseInt(resultsIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("结果ID格式错误", c)
		return
	}

	data, err := optometryService.VisionTestResultServiceApp.GetVisionTestResult(resultsId)
	if err != nil {
		ClientFailWithMessage("获取视力测试结果失败", c)
		return
	}

	ClientOkWithData(data, c)
}

func (a *ClientVisionTestResultApi) GetByRecordId(c *gin.Context) {
	recordsIdStr := c.Param("recordsId")
	if recordsIdStr == "" {
		recordsIdStr = c.Query("recordsId")
	}

	if recordsIdStr == "" {
		ClientFailWithMessage("记录ID不能为空", c)
		return
	}

	recordsId, err := strconv.ParseInt(recordsIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("记录ID格式错误", c)
		return
	}

	data, err := optometryService.VisionTestResultServiceApp.GetByRecordId(recordsId)
	if err != nil {
		ClientFailWithMessage("获取视力测试结果失败", c)
		return
	}

	ClientOkWithData(data, c)
}

func (a *ClientVisionTestResultApi) Add(c *gin.Context) {
	var result optometry.VisionTestResult
	if err := c.ShouldBindJSON(&result); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.VisionTestResultServiceApp.CreateVisionTestResult(result); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientVisionTestResultApi) Edit(c *gin.Context) {
	var result optometry.VisionTestResult
	if err := c.ShouldBindJSON(&result); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.VisionTestResultServiceApp.UpdateVisionTestResult(result); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientVisionTestResultApi) Remove(c *gin.Context) {
	resultsIdsStr := c.Param("resultsIds")
	if resultsIdsStr == "" {
		ClientFailWithMessage("结果ID不能为空", c)
		return
	}

	resultsIds := strings.Split(resultsIdsStr, ",")
	for _, idStr := range resultsIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		optometryService.VisionTestResultServiceApp.DeleteVisionTestResult(id)
	}

	ClientOkWithMessage("删除成功", c)
}
