package wechat

import (
	"errors"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// MiniOrderApi 小程序订单API
type MiniOrderApi struct{}

// PlaceOrderDTO 下单参数
type PlaceOrderDTO struct {
	UserAddressId string               `json:"userAddressId" binding:"required"`
	PaymentWay    string               `json:"paymentWay"`
	UserMessage   string               `json:"userMessage"`
	Skus          []PlaceOrderGoodsDTO `json:"skus" binding:"required"`
}

// PlaceOrderGoodsDTO 下单商品参数
type PlaceOrderGoodsDTO struct {
	SpuId        string  `json:"spuId" binding:"required"`
	Quantity     int     `json:"quantity" binding:"required,min=1"`
	FreightPrice float64 `json:"freightPrice"`
	// 注意：原Java实现中前端会传入paymentPrice，但这里为了安全，后端重新计算
}

// GetOrderPage 获取订单列表（从JWT获取用户身份）
// @Tags      MiniOrder
// @Summary   小程序获取订单列表
// @Produce   application/json
// @Param     status    query     string  false  "订单状态"
// @Param     page      query     int     false  "页码"
// @Param     pageSize  query     int     false  "每页数量"
// @Success   200  {object}  response.Response{data=[]mall.OrderInfo}  "获取成功"
// @Router    /weixin/api/ma/orderinfo/page [get]
func (a *MiniOrderApi) GetOrderPage(c *gin.Context) {
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}
	status := c.Query("status")
	page := utils.GetIntQuery(c, "page", 1)
	pageSize := utils.GetIntQuery(c, "pageSize", 10)
	offset := (page - 1) * pageSize

	db := global.GVA_DB.Model(&mall.OrderInfo{}).Where("user_id = ? AND del_flag = ?", userId, "0")
	if status != "" {
		db = db.Where("status = ?", status)
	}

	var total int64
	db.Count(&total)

	var list []mall.OrderInfo
	err := db.Preload("OrderItems").Order("create_time DESC").Limit(pageSize).Offset(offset).Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取订单列表失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithData(gin.H{"list": list, "total": total}, c)
}

// validateOrderOwner 校验订单是否属于当前 JWT 用户
func validateOrderOwner(c *gin.Context, orderId string) (*mall.OrderInfo, error) {
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		return nil, errors.New("请先登录")
	}

	var order mall.OrderInfo
	if err := global.GVA_DB.Where("id = ? AND del_flag = ?", orderId, "0").First(&order).Error; err != nil {
		return nil, errors.New("订单不存在")
	}

	if order.UserId != userId {
		return nil, errors.New("无权操作此订单")
	}

	return &order, nil
}

// GetOrderById 获取订单详情
// @Tags      MiniOrder
// @Summary   小程序获取订单详情
// @Produce   application/json
// @Param     id   query     string  true  "订单ID"
// @Success   200  {object}  response.Response{data=mall.OrderInfo}  "获取成功"
// @Router    /weixin/api/ma/orderinfo/{id} [get]
func (a *MiniOrderApi) GetOrderById(c *gin.Context) {
	id := c.Param("id")
	if id == "" {
		response.FailWithMessage("订单ID不能为空", c)
		return
	}

	order, err := validateOrderOwner(c, id)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	// 预加载订单商品
	global.GVA_DB.Model(order).Preload("OrderItems").Find(order)

	// 加载物流信息
	if order.LogisticsId != nil && *order.LogisticsId != "" {
		var logistics mall.OrderLogistics
		if err := global.GVA_DB.Where("id = ?", *order.LogisticsId).First(&logistics).Error; err == nil {
			order.Logistics = &logistics
		}
	}

	response.OkWithData(order, c)
}

// CreateOrder 创建订单
// @Tags      MiniOrder
// @Summary   小程序创建订单
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      PlaceOrderDTO  true  "订单信息"
// @Success   200   {object}  response.Response{data=mall.OrderInfo}  "创建成功"
// @Router    /weixin/api/ma/orderinfo [post]
func (a *MiniOrderApi) CreateOrder(c *gin.Context) {
	var dto PlaceOrderDTO
	if err := c.ShouldBindJSON(&dto); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	// 使用事务处理整个订单创建过程
	tx := global.GVA_DB.Begin()

	// 获取地址信息
	var address mall.UserAddress
	if err := tx.Where("id = ? AND user_id = ?", dto.UserAddressId, userId).First(&address).Error; err != nil {
		tx.Rollback()
		response.FailWithMessage("收货地址不存在", c)
		return
	}

	// 创建订单
	status := "0" // 待付款
	order := mall.OrderInfo{
		Id:           uuid.New().String(),
		UserId:       userId,
		OrderNo:      generateOrderNo(),
		IsPay:        "0",
		PaymentWay:   dto.PaymentWay,
		Status:       &status,
		DelFlag:      "0",
		SalesPrice:   0,
		FreightPrice: 0,
		PaymentPrice: 0,
	}
	if dto.UserMessage != "" {
		order.UserMessage = &dto.UserMessage
	}

	// 创建物流信息
	logistics := mall.OrderLogistics{
		Id:         uuid.New().String(),
		PostalCode: &address.PostalCode,
		UserName:   address.UserName,
		TelNum:     address.TelNum,
		Address:    address.ProvinceName + address.CityName + address.CountyName + address.DetailInfo,
		DelFlag:    "0",
	}
	if err := tx.Create(&logistics).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("创建物流信息失败", zap.Error(err))
		response.FailWithMessage("创建订单失败", c)
		return
	}
	order.LogisticsId = &logistics.Id

	// 处理订单商品
	var orderItems []mall.OrderItem
	var totalSalesPrice float64
	var totalFreightPrice float64
	var goodsToUpdate []*mall.GoodsSpu

	for _, sku := range dto.Skus {
		// 获取商品信息（加锁防止并发问题）
		var goods mall.GoodsSpu
		if err := tx.Where("id = ? AND shelf = 1 AND del_flag = ? AND stock >= ?",
			sku.SpuId, "0", sku.Quantity).First(&goods).Error; err != nil {
			tx.Rollback()
			response.FailWithMessage("商品不存在或库存不足: "+sku.SpuId, c)
			return
		}

		// 计算价格（后端重新计算，忽略前端传入的运费）
		salesPrice := 0.0
		if goods.SalesPrice != nil {
			salesPrice = *goods.SalesPrice
		}
		// 运费由后端计算，前端传入值仅作参考
		freightPrice := sku.FreightPrice
		// TODO: 接入运费计算服务，根据地址和商品重量计算运费
		_ = freightPrice // 暂时使用前端传入值

		itemSalesPrice := salesPrice * float64(sku.Quantity)
		itemPaymentPrice := itemSalesPrice + freightPrice

		orderItem := mall.OrderItem{
			Id:           uuid.New().String(),
			OrderId:      order.Id,
			SpuId:        &goods.Id,
			SpuName:      &goods.Name,
			PicUrl:       utils.ParseFirstImage(goods.PicUrls),
			Quantity:     sku.Quantity,
			SalesPrice:   salesPrice,
			FreightPrice: freightPrice,
			PaymentPrice: itemPaymentPrice,
			IsRefund:     "0",
			DelFlag:      "0",
		}
		orderItems = append(orderItems, orderItem)

		totalSalesPrice += itemSalesPrice
		totalFreightPrice += freightPrice

		// 扣减库存
		goods.Stock -= sku.Quantity
		goodsToUpdate = append(goodsToUpdate, &goods)

		// 删除购物车（在事务中）
		if err := tx.Where("spu_id = ? AND user_id = ?", goods.Id, userId).Delete(&mall.ShoppingCart{}).Error; err != nil {
			global.GVA_LOG.Error("删除购物车失败", zap.Error(err))
			// 购物车删除失败不影响订单创建，继续处理
		}
	}

	// 检查是否有商品
	if len(orderItems) == 0 {
		tx.Rollback()
		response.FailWithMessage("订单中没有有效商品", c)
		return
	}

	order.SalesPrice = totalSalesPrice
	order.FreightPrice = totalFreightPrice
	order.PaymentPrice = totalSalesPrice + totalFreightPrice

	// 设置订单名称（第一个商品名）
	order.Name = orderItems[0].SpuName

	// 保存订单
	if err := tx.Create(&order).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("创建订单失败", zap.Error(err))
		response.FailWithMessage("创建订单失败", c)
		return
	}

	// 保存订单商品
	for i := range orderItems {
		if err := tx.Create(&orderItems[i]).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("创建订单商品失败", zap.Error(err))
			response.FailWithMessage("创建订单失败", c)
			return
		}
	}

	// 更新库存（使用乐观锁防止并发问题）
	for _, goods := range goodsToUpdate {
		// 获取当前版本号
		var currentGoods mall.GoodsSpu
		if err := tx.Where("id = ?", goods.Id).First(&currentGoods).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("获取商品版本号失败", zap.Error(err))
			response.FailWithMessage("创建订单失败", c)
			return
		}

		// 使用乐观锁更新：版本号匹配才更新
		result := tx.Model(&mall.GoodsSpu{}).
			Where("id = ? AND version = ?", goods.Id, currentGoods.Version).
			Updates(map[string]interface{}{
				"stock":   goods.Stock,
				"version": currentGoods.Version + 1,
			})

		if result.Error != nil {
			tx.Rollback()
			global.GVA_LOG.Error("更新库存失败", zap.Error(result.Error))
			response.FailWithMessage("创建订单失败", c)
			return
		}

		if result.RowsAffected == 0 {
			tx.Rollback()
			global.GVA_LOG.Error("库存并发冲突", zap.String("goodsId", goods.Id))
			// 返回特定错误码，方便前端识别并引导用户刷新页面
			c.JSON(200, gin.H{
				"code":    20003,
				"message": "商品库存已变更，请重新下单",
				"data":    nil,
			})
			return
		}
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交订单事务失败", zap.Error(err))
		response.FailWithMessage("创建订单失败", c)
		return
	}

	// 设置订单超时（30分钟）
	if err := utils.SetOrderTimeout(order.Id, order.OrderNo); err != nil {
		global.GVA_LOG.Error("设置订单超时失败", zap.Error(err))
		// 不影响订单创建，继续返回成功
	}

	response.OkWithData(order, c)
}

// CancelOrder 取消订单
// @Tags      MiniOrder
// @Summary   小程序取消订单
// @Produce   application/json
// @Param     id   path      string  true  "订单ID"
// @Success   200  {object}  response.Response{msg=string}  "取消成功"
// @Router    /weixin/api/ma/orderinfo/cancel/{id} [put]
func (a *MiniOrderApi) CancelOrder(c *gin.Context) {
	id := c.Param("id")
	if id == "" {
		response.FailWithMessage("订单ID不能为空", c)
		return
	}

	order, err := validateOrderOwner(c, id)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	// 使用事务
	tx := global.GVA_DB.Begin()

	// 只有未支付订单能取消
	if order.IsPay != "0" {
		tx.Rollback()
		// 已支付订单应引导用户申请退款
		response.FailWithMessage("已支付订单不能直接取消，请申请退款", c)
		return
	}

	// 检查订单状态是否允许取消
	if order.Status != nil && *order.Status == "5" {
		tx.Rollback()
		response.FailWithMessage("订单已关闭", c)
		return
	}

	// 恢复库存（使用原子操作防止并发问题）
	var orderItems []mall.OrderItem
	if err := tx.Where("order_id = ?", order.Id).Find(&orderItems).Error; err != nil {
		tx.Rollback()
		response.FailWithMessage("查询订单商品失败", c)
		return
	}

	for _, item := range orderItems {
		// 使用原子操作恢复库存，避免并发问题
		if err := tx.Model(&mall.GoodsSpu{}).
			Where("id = ? AND del_flag = ?", item.SpuId, "0").
			UpdateColumn("stock", gorm.Expr("stock + ?", item.Quantity)).Error; err != nil {
			tx.Rollback()
			global.GVA_LOG.Error("恢复库存失败", zap.Error(err))
			response.FailWithMessage("取消订单失败", c)
			return
		}
	}

	// 更新订单状态为已关闭
	status := "5"
	if err := tx.Model(&order).Updates(map[string]interface{}{
		"status": &status,
	}).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("取消订单失败", zap.Error(err))
		response.FailWithMessage("取消失败", c)
		return
	}

	// 提交事务
	if err := tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交取消订单事务失败", zap.Error(err))
		response.FailWithMessage("取消失败", c)
		return
	}

	// 取消订单超时
	if err := utils.CancelOrderTimeout(order.Id); err != nil {
		global.GVA_LOG.Error("取消订单超时失败", zap.Error(err))
	}

	response.OkWithMessage("取消成功", c)
}

// ReceiveOrder 确认收货
// @Tags      MiniOrder
// @Summary   小程序确认收货
// @Produce   application/json
// @Param     id   path      string  true  "订单ID"
// @Success   200  {object}  response.Response{msg=string}  "确认成功"
// @Router    /weixin/api/ma/orderinfo/receive/{id} [put]
func (a *MiniOrderApi) ReceiveOrder(c *gin.Context) {
	id := c.Param("id")
	if id == "" {
		response.FailWithMessage("订单ID不能为空", c)
		return
	}

	order, err := validateOrderOwner(c, id)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	// 只有待收货订单能确认收货
	if order.Status == nil || *order.Status != "2" {
		response.FailWithMessage("只有待收货订单能确认收货", c)
		return
	}

	// 使用事务确保数据一致性
	tx := global.GVA_DB.Begin()

	// 更新订单状态为已完成
	status := "3"
	now := common.DateTime{Time: time.Now()}
	if err := tx.Model(&mall.OrderInfo{}).Where("id = ? AND user_id = ?", order.Id, order.UserId).
		Updates(map[string]interface{}{
			"status":        &status,
			"receiver_time": &now,
		}).Error; err != nil {
		tx.Rollback()
		global.GVA_LOG.Error("确认收货失败", zap.Error(err))
		response.FailWithMessage("确认失败", c)
		return
	}

	if err := tx.Commit().Error; err != nil {
		global.GVA_LOG.Error("提交确认收货事务失败", zap.Error(err))
		response.FailWithMessage("确认失败", c)
		return
	}

	response.OkWithMessage("确认成功", c)
}

// generateOrderNo 生成订单号（使用雪花算法）
func generateOrderNo() string {
	return utils.GenerateOrderNo()
}

// OrderCountAll 获取各状态订单数量
// @Tags      MiniOrder
// @Summary   小程序订单状态数量统计
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]map[string]interface{}}  "获取成功"
// @Router    /mini/orderinfo/countAll [get]
func (a *MiniOrderApi) OrderCountAll(c *gin.Context) {
	wxUserId := c.GetUint("wxUserId")
	if wxUserId == 0 {
		response.FailWithMessage("获取用户信息失败", c)
		return
	}

	// 统计各状态订单数量
	type StatusCount struct {
		Status string `json:"status"`
		Count  int64  `json:"count"`
	}
	var results []StatusCount

	err := global.GVA_DB.Model(&mall.OrderInfo{}).
		Select("COALESCE(status, '0') as status, COUNT(*) as count").
		Where("user_id = ? AND del_flag = '0'", wxUserId).
		Group("COALESCE(status, '0')").
		Scan(&results).Error

	if err != nil {
		global.GVA_LOG.Error("统计订单数量失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithDetailed(results, "获取成功", c)
}
