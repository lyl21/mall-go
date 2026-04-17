package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type OrderItemApi struct{}

// CreateOrderItem
// @Tags      OrderItem
// @Summary   创建订单项
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.OrderItem                         true  "订单项信息"
// @Success   200   {object}  response.Response{msg=string}              "创建订单项"
// @Router    /mall/orderItem [post]
func (a *OrderItemApi) CreateOrderItem(c *gin.Context) {
	var item mallModel.OrderItem
	err := c.ShouldBindJSON(&item)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderItemService.CreateOrderItem(item)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteOrderItem
// @Tags      OrderItem
// @Summary   删除订单项
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "订单项ID"
// @Success   200   {object}  response.Response{msg=string}              "删除订单项"
// @Router    /mall/orderItem [delete]
func (a *OrderItemApi) DeleteOrderItem(c *gin.Context) {
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
	err = orderItemService.DeleteOrderItem(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateOrderItem
// @Tags      OrderItem
// @Summary   更新订单项
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.OrderItem                         true  "订单项信息"
// @Success   200   {object}  response.Response{msg=string}              "更新订单项"
// @Router    /mall/orderItem [put]
func (a *OrderItemApi) UpdateOrderItem(c *gin.Context) {
	var item mallModel.OrderItem
	err := c.ShouldBindJSON(&item)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderItemService.UpdateOrderItem(item)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetOrderItem
// @Tags      OrderItem
// @Summary   获取订单项信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "订单项ID"
// @Success   200  {object}  response.Response{data=mallModel.OrderItem,msg=string}  "获取订单项信息"
// @Router    /mall/orderItem [get]
func (a *OrderItemApi) GetOrderItem(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := orderItemService.GetOrderItem(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetOrderItemList
// @Tags      OrderItem
// @Summary   分页获取订单项列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                    true  "页码"
// @Param     pageSize  query     int                                    true  "每页大小"
// @Param     orderId   query     string                                 false "订单ID"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取订单项列表"
// @Router    /mall/orderItemList [get]
func (a *OrderItemApi) GetOrderItemList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	orderId := c.Query("orderId")
	list, total, err := orderItemService.GetOrderItemList(pageInfo, orderId)
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
