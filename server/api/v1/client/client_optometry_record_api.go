package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	optometryService "github.com/flipped-aurora/gin-vue-admin/server/service/optometry"
	"github.com/gin-gonic/gin"
)

type ClientOptometryRecordApi struct{}

var ClientOptometryRecordApiApp = new(ClientOptometryRecordApi)

type OptometryRecordListReq struct {
	request.PageInfo
	CustomerName  string `json:"customerName" form:"customerName"`
	StoreId       int64  `json:"storeId" form:"storeId"`
	OptometristId int64  `json:"optometristId" form:"optometristId"`
	CustomerId    *int64 `json:"customerId" form:"customerId"`
}

func (a *ClientOptometryRecordApi) List(c *gin.Context) {
	var req OptometryRecordListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	search := optometry.OptometryRecord{}
	if req.CustomerName != "" {
		search.CustomerName = req.CustomerName
	}
	if req.StoreId != 0 {
		search.StoreId = req.StoreId
	}
	if req.OptometristId != 0 {
		search.OptometristId = req.OptometristId
	}
	if req.CustomerId != nil {
		search.CustomerId = req.CustomerId
	}

	list, total, err := optometryService.OptometryRecordServiceApp.GetOptometryRecordList(req.PageInfo, search)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientOptometryRecordApi) GetInfo(c *gin.Context) {
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

	data, err := optometryService.OptometryRecordServiceApp.GetOptometryRecord(recordsId)
	if err != nil {
		ClientFailWithMessage("获取记录失败", c)
		return
	}

	ClientOkWithData(data, c)
}

func (a *ClientOptometryRecordApi) Add(c *gin.Context) {
	var record optometry.OptometryRecord
	if err := c.ShouldBindJSON(&record); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.OptometryRecordServiceApp.CreateOptometryRecord(record); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientOptometryRecordApi) Edit(c *gin.Context) {
	var record optometry.OptometryRecord
	if err := c.ShouldBindJSON(&record); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.OptometryRecordServiceApp.UpdateOptometryRecord(record); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientOptometryRecordApi) Remove(c *gin.Context) {
	recordsIdsStr := c.Param("recordsIds")
	if recordsIdsStr == "" {
		ClientFailWithMessage("记录ID不能为空", c)
		return
	}

	recordsIds := strings.Split(recordsIdsStr, ",")
	for _, idStr := range recordsIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		optometryService.OptometryRecordServiceApp.DeleteOptometryRecord(id)
	}

	ClientOkWithMessage("删除成功", c)
}

func (a *ClientOptometryRecordApi) ListByCustomerId(c *gin.Context) {
	customerIdStr := c.Query("customerId")
	if customerIdStr == "" {
		ClientFailWithMessage("顾客ID不能为空", c)
		return
	}

	customerId, err := strconv.ParseInt(customerIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("顾客ID格式错误", c)
		return
	}

	list, err := optometryService.OptometryRecordServiceApp.GetOptometryDataClientVoByCustomerId(customerId)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientOkWithData(list, c)
}

func (a *ClientOptometryRecordApi) GetOptometry(c *gin.Context) {
	optometryRecordsIdStr := c.Query("optometryRecordsId")
	if optometryRecordsIdStr == "" {
		ClientFailWithMessage("验光记录ID不能为空", c)
		return
	}

	optometryRecordsId, err := strconv.ParseInt(optometryRecordsIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("验光记录ID格式错误", c)
		return
	}

	dto, err := optometryService.OptometryRecordServiceApp.GetOptometryDTOByOptometryRecordsId(optometryRecordsId)
	if err != nil {
		ClientFailWithMessage("获取验光数据失败", c)
		return
	}

	ClientOkWithData(dto, c)
}

func (a *ClientOptometryRecordApi) GetVisionTestResultsTryOptomentry(c *gin.Context) {
	optometryRecordsIdStr := c.Query("optometryRecordsId")
	if optometryRecordsIdStr == "" {
		ClientFailWithMessage("验光记录ID不能为空", c)
		return
	}

	optometryRecordsId, err := strconv.ParseInt(optometryRecordsIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("验光记录ID格式错误", c)
		return
	}

	vo, err := optometryService.OptometryRecordServiceApp.GetVisionTestResultsTryOptomentryVoByOptometryRecordsId(optometryRecordsId)
	if err != nil {
		ClientFailWithMessage("获取验光数据失败", c)
		return
	}

	ClientOkWithData(vo, c)
}

func (a *ClientOptometryRecordApi) Insert(c *gin.Context) {
	var dto optometryService.OptometryRecordDTO
	if err := c.ShouldBindJSON(&dto); err != nil {
		ClientFailWithMessage("请求参数错误: "+err.Error(), c)
		return
	}

	if err := optometryService.OptometryRecordServiceApp.InsertOptometryRecordDTO(dto); err != nil {
		ClientFailWithMessage("创建验光报告失败: "+err.Error(), c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}
