package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type OrderInfoApi struct{}

// CreateOrder
// @Tags      OrderInfo
// @Summary   创建订单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      object{order=mallModel.OrderInfo,items=[]mallModel.OrderItem}  true  "订单信息+订单项"
// @Success   200   {object}  response.Response{msg=string}              "创建订单"
// @Router    /mall/orderInfo [post]
func (a *OrderInfoApi) CreateOrder(c *gin.Context) {
	var req struct {
		Order mallModel.OrderInfo   `json:"order"`
		Items []mallModel.OrderItem `json:"items"`
	}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderInfoService.CreateOrder(req.Order, req.Items)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteOrderInfo
// @Tags      OrderInfo
// @Summary   删除订单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "订单ID"
// @Success   200   {object}  response.Response{msg=string}              "删除订单"
// @Router    /mall/orderInfo [delete]
func (a *OrderInfoApi) DeleteOrderInfo(c *gin.Context) {
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
	err = orderInfoService.DeleteOrderInfo(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateOrderInfo
// @Tags      OrderInfo
// @Summary   更新订单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.OrderInfo                          true  "订单信息"
// @Success   200   {object}  response.Response{msg=string}              "更新订单"
// @Router    /mall/orderInfo [put]
func (a *OrderInfoApi) UpdateOrderInfo(c *gin.Context) {
	var order mallModel.OrderInfo
	err := c.ShouldBindJSON(&order)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderInfoService.UpdateOrderInfo(order)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetOrderInfo
// @Tags      OrderInfo
// @Summary   获取订单信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "订单ID"
// @Success   200  {object}  response.Response{data=mallModel.OrderInfo,msg=string}  "获取订单信息"
// @Router    /mall/orderInfo [get]
func (a *OrderInfoApi) GetOrderInfo(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := orderInfoService.GetOrderInfo(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetOrderInfoList
// @Tags      OrderInfo
// @Summary   分页获取订单列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                    true  "页码"
// @Param     pageSize  query     int                                    true  "每页大小"
// @Param     userId    query     string                                 false "用户ID"
// @Param     status    query     string                                 false "订单状态"
// @Param     orderNo   query     string                                 false "订单号"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取订单列表"
// @Router    /mall/orderInfoList [get]
func (a *OrderInfoApi) GetOrderInfoList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	userId := c.Query("userId")
	status := c.Query("status")
	orderNo := c.Query("orderNo")
	list, total, err := orderInfoService.GetOrderInfoList(pageInfo, userId, status, orderNo)
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

// UpdateOrderStatus
// @Tags      OrderInfo
// @Summary   更新订单状态
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "订单ID和新状态"
// @Success   200   {object}  response.Response{msg=string}              "更新订单状态"
// @Router    /mall/orderStatus [put]
func (a *OrderInfoApi) UpdateOrderStatus(c *gin.Context) {
	var req map[string]string
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	id := req["id"]
	newStatus := req["status"]
	if id == "" || newStatus == "" {
		response.FailWithMessage("缺少参数id或status", c)
		return
	}
	err = orderInfoService.UpdateOrderStatus(id, newStatus)
	if err != nil {
		global.GVA_LOG.Error("更新状态失败!", zap.Error(err))
		response.FailWithMessage("更新状态失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// CancelOrder
// @Tags      OrderInfo
// @Summary   取消订单
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "订单ID"
// @Success   200   {object}  response.Response{msg=string}              "取消订单"
// @Router    /mall/cancelOrder [put]
func (a *OrderInfoApi) CancelOrder(c *gin.Context) {
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
	err = orderInfoService.CancelOrder(id)
	if err != nil {
		global.GVA_LOG.Error("取消订单失败!", zap.Error(err))
		response.FailWithMessage("取消订单失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("取消成功", c)
}

// RefundOrder
// @Tags      OrderInfo
// @Summary   订单退款
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]interface{}                           true  "订单ID和退款金额"
// @Success   200   {object}  response.Response{msg=string}              "退款申请"
// @Router    /mall/refundOrder [post]
func (a *OrderInfoApi) RefundOrder(c *gin.Context) {
	var req struct {
		Id         string  `json:"id" binding:"required"`
		RefundFee  float64 `json:"refundFee"`
		RefundDesc string  `json:"refundDesc"`
	}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderInfoService.RefundOrder(req.Id, req.RefundFee, req.RefundDesc)
	if err != nil {
		global.GVA_LOG.Error("退款申请失败!", zap.Error(err))
		response.FailWithMessage("退款申请失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("退款申请成功", c)
}

// ShipOrder
// @Tags      OrderInfo
// @Summary   订单发货
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "订单ID和物流信息"
// @Success   200   {object}  response.Response{msg=string}              "发货成功"
// @Router    /mall/shipOrder [post]
func (a *OrderInfoApi) ShipOrder(c *gin.Context) {
	var req struct {
		Id          string `json:"id" binding:"required"`
		Logistics   string `json:"logistics" binding:"required"`
		LogisticsNo string `json:"logisticsNo" binding:"required"`
	}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = orderInfoService.ShipOrder(req.Id, req.Logistics, req.LogisticsNo)
	if err != nil {
		global.GVA_LOG.Error("发货失败!", zap.Error(err))
		response.FailWithMessage("发货失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("发货成功", c)
}
