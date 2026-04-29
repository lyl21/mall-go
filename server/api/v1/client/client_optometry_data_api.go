package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	optometryService "github.com/flipped-aurora/gin-vue-admin/server/service/optometry"
	"github.com/gin-gonic/gin"
)

type ClientOptometryDataApi struct{}

var ClientOptometryDataApiApp = new(ClientOptometryDataApi)

type OptometryDataListReq struct {
	request.PageInfo
	OptometryRecordsId *int64 `json:"optometryRecordsId" form:"optometryRecordsId"`
	Type               int    `json:"type" form:"type"`
	LeftRightEyes      int    `json:"leftRightEyes" form:"leftRightEyes"`
}

func (a *ClientOptometryDataApi) List(c *gin.Context) {
	var req OptometryDataListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	search := optometry.OptometryData{}
	if req.OptometryRecordsId != nil {
		search.OptometryRecordsId = req.OptometryRecordsId
	}
	if req.Type != 0 {
		search.Type = req.Type
	}
	if req.LeftRightEyes != 0 {
		search.LeftRightEyes = req.LeftRightEyes
	}

	list, total, err := optometryService.OptometryDataServiceApp.GetOptometryDataList(req.PageInfo, search)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientOptometryDataApi) GetInfo(c *gin.Context) {
	optometryIdStr := c.Param("optometryId")
	if optometryIdStr == "" {
		optometryIdStr = c.Query("optometryId")
	}

	if optometryIdStr == "" {
		ClientFailWithMessage("验光数据ID不能为空", c)
		return
	}

	optometryId, err := strconv.ParseInt(optometryIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("验光数据ID格式错误", c)
		return
	}

	data, err := optometryService.OptometryDataServiceApp.GetOptometryData(optometryId)
	if err != nil {
		ClientFailWithMessage("获取验光数据失败", c)
		return
	}

	ClientOkWithData(data, c)
}

func (a *ClientOptometryDataApi) GetByRecordId(c *gin.Context) {
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

	list, err := optometryService.OptometryDataServiceApp.GetByRecordId(recordsId)
	if err != nil {
		ClientFailWithMessage("获取验光数据失败", c)
		return
	}

	ClientOkWithData(list, c)
}

func (a *ClientOptometryDataApi) Add(c *gin.Context) {
	var data optometry.OptometryData
	if err := c.ShouldBindJSON(&data); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.OptometryDataServiceApp.CreateOptometryData(data); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientOptometryDataApi) Edit(c *gin.Context) {
	var data optometry.OptometryData
	if err := c.ShouldBindJSON(&data); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.OptometryDataServiceApp.UpdateOptometryData(data); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientOptometryDataApi) Remove(c *gin.Context) {
	optometryIdsStr := c.Param("optometryIds")
	if optometryIdsStr == "" {
		ClientFailWithMessage("验光数据ID不能为空", c)
		return
	}

	optometryIds := strings.Split(optometryIdsStr, ",")
	for _, idStr := range optometryIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		optometryService.OptometryDataServiceApp.DeleteOptometryData(id)
	}

	ClientOkWithMessage("删除成功", c)
}
