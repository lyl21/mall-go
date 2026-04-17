package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// MiniCartApi 小程序购物车API
type MiniCartApi struct{}

// GetCartPage 获取购物车列表
// @Tags      MiniCart
// @Summary   小程序获取购物车列表
// @Produce   application/json
// @Param     userId    query     string  true   "用户ID"
// @Param     page      query     int     false  "页码"
// @Param     pageSize  query     int     false  "每页数量"
// @Success   200  {object}  response.Response{data=[]mall.ShoppingCart}  "获取成功"
// @Router    /weixin/api/ma/shoppingcart/page [get]
func (a *MiniCartApi) GetCartPage(c *gin.Context) {
	userId := c.Query("userId")
	if userId == "" {
		response.FailWithMessage("用户ID不能为空", c)
		return
	}
	page := utils.GetIntQuery(c, "page", 1)
	pageSize := utils.GetIntQuery(c, "pageSize", 100)
	offset := (page - 1) * pageSize

	var total int64
	db := global.GVA_DB.Model(&mall.ShoppingCart{}).Where("user_id = ? AND del_flag = ?", userId, "0")
	db.Count(&total)

	var list []mall.ShoppingCart
	err := db.Preload("GoodsSpu").Order("create_time DESC").Limit(pageSize).Offset(offset).Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取购物车失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithData(gin.H{"list": list, "total": total}, c)
}

// GetCartCount 获取购物车商品数量
// @Tags      MiniCart
// @Summary   小程序获取购物车数量
// @Produce   application/json
// @Param     userId  query     string  true  "用户ID"
// @Success   200  {object}  response.Response{data=int}  "获取成功"
// @Router    /weixin/api/ma/shoppingcart/count [get]
func (a *MiniCartApi) GetCartCount(c *gin.Context) {
	userId := c.Query("userId")
	if userId == "" {
		response.FailWithMessage("用户ID不能为空", c)
		return
	}

	var count int64
	err := global.GVA_DB.Model(&mall.ShoppingCart{}).Where("user_id = ? AND del_flag = ?", userId, "0").Count(&count).Error
	if err != nil {
		global.GVA_LOG.Error("获取购物车数量失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithData(count, c)
}

// AddCart 添加商品到购物车
// @Tags      MiniCart
// @Summary   小程序添加商品到购物车
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      mall.ShoppingCart  true  "购物车信息"
// @Success   200   {object}  response.Response{msg=string}  "添加成功"
// @Router    /weixin/api/ma/shoppingcart [post]
func (a *MiniCartApi) AddCart(c *gin.Context) {
	var cart mall.ShoppingCart
	if err := c.ShouldBindJSON(&cart); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	if cart.UserId == "" || cart.SpuId == "" {
		response.FailWithMessage("用户ID和商品ID不能为空", c)
		return
	}

	// 检查商品是否已在购物车
	var existing mall.ShoppingCart
	err := global.GVA_DB.Where("user_id = ? AND spu_id = ? AND del_flag = ?", cart.UserId, cart.SpuId, "0").First(&existing).Error
	if err == nil {
		// 已存在，更新数量
		existing.Quantity += cart.Quantity
		if err := global.GVA_DB.Save(&existing).Error; err != nil {
			global.GVA_LOG.Error("更新购物车失败", zap.Error(err))
			response.FailWithMessage("添加失败", c)
			return
		}
		response.OkWithMessage("添加成功", c)
		return
	}

	// 获取商品信息
	var goods mall.GoodsSpu
	if err := global.GVA_DB.Where("id = ?", cart.SpuId).First(&goods).Error; err == nil {
		cart.SpuName = goods.Name
		if goods.SalesPrice != nil {
			cart.AddPrice = *goods.SalesPrice
		}
		// 解析图片URL
		if goods.PicUrls != "" {
			cart.PicUrl = utils.ParseFirstImage(goods.PicUrls)
		}
	}

	cart.Id = uuid.New().String()
	cart.DelFlag = "0"

	if err := global.GVA_DB.Create(&cart).Error; err != nil {
		global.GVA_LOG.Error("添加购物车失败", zap.Error(err))
		response.FailWithMessage("添加失败", c)
		return
	}

	response.OkWithMessage("添加成功", c)
}

// UpdateCart 更新购物车商品数量
// @Tags      MiniCart
// @Summary   小程序更新购物车
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      mall.ShoppingCart  true  "购物车信息"
// @Success   200   {object}  response.Response{msg=string}  "更新成功"
// @Router    /weixin/api/ma/shoppingcart [put]
func (a *MiniCartApi) UpdateCart(c *gin.Context) {
	var cart mall.ShoppingCart
	if err := c.ShouldBindJSON(&cart); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	if cart.Id == "" {
		response.FailWithMessage("购物车ID不能为空", c)
		return
	}

	updateData := map[string]interface{}{
		"quantity": cart.Quantity,
	}
	if err := global.GVA_DB.Model(&mall.ShoppingCart{}).Where("id = ?", cart.Id).Updates(updateData).Error; err != nil {
		global.GVA_LOG.Error("更新购物车失败", zap.Error(err))
		response.FailWithMessage("更新失败", c)
		return
	}

	response.OkWithMessage("更新成功", c)
}

// DeleteCart 删除购物车商品
// @Tags      MiniCart
// @Summary   小程序删除购物车商品
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      object{id=string}  true  "购物车ID"
// @Success   200   {object}  response.Response{msg=string}  "删除成功"
// @Router    /weixin/api/ma/shoppingcart/del [post]
func (a *MiniCartApi) DeleteCart(c *gin.Context) {
	var req struct {
		Id string `json:"id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	if err := global.GVA_DB.Model(&mall.ShoppingCart{}).Where("id = ?", req.Id).Update("del_flag", "1").Error; err != nil {
		global.GVA_LOG.Error("删除购物车失败", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}

	response.OkWithMessage("删除成功", c)
}
