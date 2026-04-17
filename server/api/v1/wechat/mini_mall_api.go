package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// MiniMallApi 小程序商城API
type MiniMallApi struct{}

// GetGoodsCategoryTree 获取商品分类树
// @Tags      MiniMall
// @Summary   小程序获取商品分类树
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]mall.GoodsCategory}  "获取成功"
// @Router    /weixin/api/ma/goodscategory/tree [get]
func (a *MiniMallApi) GetGoodsCategoryTree(c *gin.Context) {
	var list []mall.GoodsCategory
	err := global.GVA_DB.Where("del_flag = ?", "0").Order("sort ASC").Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取分类树失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithData(list, c)
}

// GetGoodsSpuPage 分页查询商品列表
// @Tags      MiniMall
// @Summary   小程序分页查询商品
// @Produce   application/json
// @Param     page      query     int     false  "页码"
// @Param     pageSize  query     int     false  "每页数量"
// @Param     categoryId query    string  false  "分类ID"
// @Param     name      query     string  false  "商品名称"
// @Success   200  {object}  response.Response{data=[]mall.GoodsSpu}  "获取成功"
// @Router    /weixin/api/ma/goodsspu/page [get]
func (a *MiniMallApi) GetGoodsSpuPage(c *gin.Context) {
	page := utils.GetIntQuery(c, "page", 1)
	pageSize := utils.GetIntQuery(c, "pageSize", 10)
	categoryId := c.Query("categoryId")
	name := c.Query("name")

	offset := (page - 1) * pageSize
	db := global.GVA_DB.Model(&mall.GoodsSpu{}).Where("del_flag = ? AND shelf = 1", "0")

	if categoryId != "" {
		db = db.Where("category_first = ? OR category_second = ?", categoryId, categoryId)
	}
	if name != "" {
		db = db.Where("name LIKE ?", "%"+name+"%")
	}

	var total int64
	db.Count(&total)

	var list []mall.GoodsSpu
	err := db.Order("sort DESC, create_time DESC").Limit(pageSize).Offset(offset).Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取商品列表失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithData(gin.H{"list": list, "total": total}, c)
}

// GetGoodsSpuById 根据ID查询商品详情
// @Tags      MiniMall
// @Summary   小程序获取商品详情
// @Produce   application/json
// @Param     id   query     string  true  "商品ID"
// @Success   200  {object}  response.Response{data=mall.GoodsSpu}  "获取成功"
// @Router    /weixin/api/ma/goodsspu/id [get]
func (a *MiniMallApi) GetGoodsSpuById(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("商品ID不能为空", c)
		return
	}

	var goods mall.GoodsSpu
	err := global.GVA_DB.Where("id = ? AND del_flag = ? AND shelf = 1", id, "0").First(&goods).Error
	if err != nil {
		global.GVA_LOG.Error("获取商品详情失败", zap.Error(err))
		response.FailWithMessage("商品不存在", c)
		return
	}

	// 加载轮播图
	var banners []mall.GoodsSpuBanner
	global.GVA_DB.Where("goods_spu_id = ?", id).Find(&banners)
	goods.Banners = banners

	response.OkWithData(goods, c)
}

// GetBannerList 获取首页Banner列表
// @Tags      MiniMall
// @Summary   小程序获取Banner列表
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]mall.GoodsSpuBanner}  "获取成功"
// @Router    /weixin/api/ma/banner/list [get]
func (a *MiniMallApi) GetBannerList(c *gin.Context) {
	var list []mall.GoodsSpuBanner
	// 获取最新的6个Banner
	err := global.GVA_DB.Order("create_time DESC").Limit(6).Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取Banner列表失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithData(list, c)
}
