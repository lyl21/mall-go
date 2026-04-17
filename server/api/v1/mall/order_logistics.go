package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type OrderLogisticsApi struct{}

// CreateOrderLogistics
// @Tags      OrderLogistics
// @Summary   创建订单物流
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.OrderLogistics                    true  "物流信息"
// @Success   200   {object}  response.Response{msg=string}              "创建订单物流"
// @Router    /mall/orderLogistics [post]
func (a *OrderLogisticsApi) CreateOrderLogistics(c *gin.Context) {
	var logistics mallModel.OrderLogistics
	err := c.ShouldBindJSON(&logistics)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderLogisticsService.CreateOrderLogistics(logistics)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteOrderLogistics
// @Tags      OrderLogistics
// @Summary   删除订单物流
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "物流ID"
// @Success   200   {object}  response.Response{msg=string}              "删除订单物流"
// @Router    /mall/orderLogistics [delete]
func (a *OrderLogisticsApi) DeleteOrderLogistics(c *gin.Context) {
	var req map[string]string
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	id := req["id"]
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	err = orderLogisticsService.DeleteOrderLogistics(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateOrderLogistics
// @Tags      OrderLogistics
// @Summary   更新订单物流
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.OrderLogistics                    true  "物流信息"
// @Success   200   {object}  response.Response{msg=string}              "更新订单物流"
// @Router    /mall/orderLogistics [put]
func (a *OrderLogisticsApi) UpdateOrderLogistics(c *gin.Context) {
	var logistics mallModel.OrderLogistics
	err := c.ShouldBindJSON(&logistics)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderLogisticsService.UpdateOrderLogistics(logistics)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetOrderLogistics
// @Tags      OrderLogistics
// @Summary   获取订单物流信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "物流ID"
// @Success   200  {object}  response.Response{data=mallModel.OrderLogistics,msg=string}  "获取订单物流信息"
// @Router    /mall/orderLogistics [get]
func (a *OrderLogisticsApi) GetOrderLogistics(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := orderLogisticsService.GetOrderLogistics(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetOrderLogisticsList
// @Tags      OrderLogistics
// @Summary   分页获取订单物流列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int                                    true  "页码"
// @Param     pageSize   query     int                                    true  "每页大小"
// @Param     logistics  query     string                                 false "物流商家"
// @Success   200        {object}  response.Response{data=response.PageResult,msg=string}  "获取订单物流列表"
// @Router    /mall/orderLogisticsList [get]
func (a *OrderLogisticsApi) GetOrderLogisticsList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	logistics := c.Query("logistics")
	list, total, err := orderLogisticsService.GetOrderLogisticsList(pageInfo, logistics)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
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
