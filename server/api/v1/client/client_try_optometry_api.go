package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	optometryService "github.com/flipped-aurora/gin-vue-admin/server/service/optometry"
	"github.com/gin-gonic/gin"
)

type ClientTryOptometryApi struct{}

var ClientTryOptometryApiApp = new(ClientTryOptometryApi)

type TryOptometryListReq struct {
	request.PageInfo
	ResultsId *int64 `json:"resultsId" form:"resultsId"`
}

func (a *ClientTryOptometryApi) List(c *gin.Context) {
	var req TryOptometryListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	search := optometry.TryOptometry{}
	if req.ResultsId != nil {
		search.ResultsId = req.ResultsId
	}

	list, total, err := optometryService.TryOptometryServiceApp.GetTryOptometryList(req.PageInfo, search)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientTryOptometryApi) GetInfo(c *gin.Context) {
	tryOptometryIdStr := c.Param("tryOptometryId")
	if tryOptometryIdStr == "" {
		tryOptometryIdStr = c.Query("tryOptometryId")
	}

	if tryOptometryIdStr == "" {
		ClientFailWithMessage("试戴验光ID不能为空", c)
		return
	}

	tryOptometryId, err := strconv.ParseInt(tryOptometryIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("试戴验光ID格式错误", c)
		return
	}

	data, err := optometryService.TryOptometryServiceApp.GetTryOptometry(tryOptometryId)
	if err != nil {
		ClientFailWithMessage("获取试戴验光数据失败", c)
		return
	}

	ClientOkWithData(data, c)
}

func (a *ClientTryOptometryApi) GetByResultsId(c *gin.Context) {
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

	list, err := optometryService.TryOptometryServiceApp.GetByResultsId(resultsId)
	if err != nil {
		ClientFailWithMessage("获取试戴验光数据失败", c)
		return
	}

	ClientOkWithData(list, c)
}

func (a *ClientTryOptometryApi) Add(c *gin.Context) {
	var data optometry.TryOptometry
	if err := c.ShouldBindJSON(&data); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.TryOptometryServiceApp.CreateTryOptometry(data); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientTryOptometryApi) Edit(c *gin.Context) {
	var data optometry.TryOptometry
	if err := c.ShouldBindJSON(&data); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := optometryService.TryOptometryServiceApp.UpdateTryOptometry(data); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientTryOptometryApi) Remove(c *gin.Context) {
	tryOptometryIdsStr := c.Param("tryOptometryIds")
	if tryOptometryIdsStr == "" {
		ClientFailWithMessage("试戴验光ID不能为空", c)
		return
	}

	tryOptometryIds := strings.Split(tryOptometryIdsStr, ",")
	for _, idStr := range tryOptometryIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		optometryService.TryOptometryServiceApp.DeleteTryOptometry(id)
	}

	ClientOkWithMessage("删除成功", c)
}
