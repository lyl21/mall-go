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

type TryOptometryApi struct{}

func (a *TryOptometryApi) CreateTryOptometry(c *gin.Context) {
	var data optometryModel.TryOptometry
	if err := c.ShouldBindJSON(&data); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := tryOptometryService.CreateTryOptometry(data); err != nil {
		global.GVA_LOG.Error("创建试戴验光失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

func (a *TryOptometryApi) DeleteTryOptometry(c *gin.Context) {
	var req struct {
		TryOptometryId int64 `json:"tryOptometryId"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	if err := tryOptometryService.DeleteTryOptometry(req.TryOptometryId); err != nil {
		global.GVA_LOG.Error("删除试戴验光失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (a *TryOptometryApi) UpdateTryOptometry(c *gin.Context) {
	var data optometryModel.TryOptometry
	if err := c.ShouldBindJSON(&data); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if err := tryOptometryService.UpdateTryOptometry(data); err != nil {
		global.GVA_LOG.Error("更新试戴验光失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

func (a *TryOptometryApi) GetTryOptometry(c *gin.Context) {
	idStr := c.Query("tryOptometryId")
	if idStr == "" {
		idStr = c.Query("id")
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil || id == 0 {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := tryOptometryService.GetTryOptometry(id)
	if err != nil {
		global.GVA_LOG.Error("获取试戴验光失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

func (a *TryOptometryApi) GetTryOptometryList(c *gin.Context) {
	var req struct {
		request.PageInfo
		optometryModel.TryOptometry
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := tryOptometryService.GetTryOptometryList(req.PageInfo, req.TryOptometry)
	if err != nil {
		global.GVA_LOG.Error("获取试戴验光列表失败!", zap.Error(err))
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
