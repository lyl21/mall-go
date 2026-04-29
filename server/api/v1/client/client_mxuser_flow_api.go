package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/gin-gonic/gin"
)

type ClientMxUserFlowApi struct{}

var ClientMxUserFlowApiApp = new(ClientMxUserFlowApi)

type MxUserFlowListReq struct {
	request.PageInfo
	UserId *int64 `json:"userId" form:"userId"`
}

func (a *ClientMxUserFlowApi) List(c *gin.Context) {
	var req MxUserFlowListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	userId := int64(0)
	if req.UserId != nil {
		userId = *req.UserId
	}

	list, total, err := storeService.UserFlowServiceApp.GetMxUserFlowList(req.PageInfo, userId)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientMxUserFlowApi) Add(c *gin.Context) {
	var flowList []store.MxUserFlow
	if err := c.ShouldBindJSON(&flowList); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	for _, flow := range flowList {
		if err := storeService.UserFlowServiceApp.CreateMxUserFlow(flow); err != nil {
			ClientFailWithMessage("创建失败", c)
			return
		}
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientMxUserFlowApi) Edit(c *gin.Context) {
	var flow store.MxUserFlow
	if err := c.ShouldBindJSON(&flow); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := storeService.UserFlowServiceApp.UpdateMxUserFlow(flow); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientMxUserFlowApi) Remove(c *gin.Context) {
	flowIdsStr := c.Param("flowIds")
	if flowIdsStr == "" {
		ClientFailWithMessage("流程ID不能为空", c)
		return
	}

	flowIds := strings.Split(flowIdsStr, ",")
	for _, idStr := range flowIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		flow := store.MxUserFlow{FlowId: id}
		storeService.UserFlowServiceApp.DeleteMxUserFlow(flow)
	}

	ClientOkWithMessage("删除成功", c)
}
