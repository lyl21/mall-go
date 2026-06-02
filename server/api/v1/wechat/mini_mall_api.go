package wechat

import (
	"encoding/json"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// MiniMallApi 小程序商城API
type MiniMallApi struct{}

// GetGoodsCategoryTree 获取商品分类树（返回树形结构，含 children）
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
	tree := buildCategoryTree(list, "0")
	response.OkWithData(tree, c)
}

// buildCategoryTree 将平铺分类列表组装为树形结构
func buildCategoryTree(categories []mall.GoodsCategory, parentId string) []mall.GoodsCategory {
	var tree []mall.GoodsCategory
	for _, cat := range categories {
		pid := "0"
		if cat.ParentId != nil {
			pid = *cat.ParentId
		}
		if pid == parentId {
			cat.Children = buildCategoryTree(categories, cat.Id)
			tree = append(tree, cat)
		}
	}
	return tree
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
	// 限制 pageSize 最大值，防止内存溢出
	if pageSize > 50 {
		pageSize = 50
	}
	if pageSize < 1 {
		pageSize = 10
	}
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

	// 将 picUrls 从 JSON 字符串解析为数组，避免前端 item.picUrls[0] 取到字符串字符
	resultList := make([]map[string]interface{}, 0, len(list))
	for _, item := range list {
		itemMap := make(map[string]interface{})
		itemMap["id"] = item.Id
		itemMap["name"] = item.Name
		itemMap["sellPoint"] = item.SellPoint
		itemMap["description"] = item.Description
		itemMap["categoryFirst"] = item.CategoryFirst
		itemMap["categorySecond"] = item.CategorySecond
		itemMap["picUrls"] = parsePicUrlsToArray(item.PicUrls)
		itemMap["shelf"] = item.Shelf
		itemMap["sort"] = item.Sort
		itemMap["salesPrice"] = item.SalesPrice
		itemMap["marketPrice"] = item.MarketPrice
		itemMap["costPrice"] = item.CostPrice
		itemMap["stock"] = item.Stock
		itemMap["salesNum"] = item.SalesNum
		itemMap["createTime"] = item.CreateTime
		itemMap["updateTime"] = item.UpdateTime
		resultList = append(resultList, itemMap)
	}

	response.OkWithData(gin.H{"list": resultList, "total": total}, c)
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

	// 将 picUrls 从 JSON 字符串解析为数组返回
	resultMap := make(map[string]interface{})
	resultMap["id"] = goods.Id
	resultMap["spuCode"] = goods.SpuCode
	resultMap["name"] = goods.Name
	resultMap["sellPoint"] = goods.SellPoint
	resultMap["description"] = goods.Description
	resultMap["categoryFirst"] = goods.CategoryFirst
	resultMap["categorySecond"] = goods.CategorySecond
	resultMap["picUrls"] = parsePicUrlsToArray(goods.PicUrls)
	resultMap["shelf"] = goods.Shelf
	resultMap["sort"] = goods.Sort
	resultMap["salesPrice"] = goods.SalesPrice
	resultMap["marketPrice"] = goods.MarketPrice
	resultMap["costPrice"] = goods.CostPrice
	resultMap["stock"] = goods.Stock
	resultMap["salesNum"] = goods.SalesNum
	resultMap["createTime"] = goods.CreateTime
	resultMap["updateTime"] = goods.UpdateTime
	resultMap["banners"] = goods.Banners

	response.OkWithData(resultMap, c)
}

// parsePicUrlsToArray 将 picUrls 从 JSON 字符串解析为数组
// 数据库中 picUrls 存储为 JSON 数组字符串如 '["/uploads/xxx.jpg"]'
// 前端小程序使用 item.picUrls[0] 访问，需要返回数组而非字符串
// 同时清理路径：去除 /dev-api/ 前缀、完整URL直接返回
func parsePicUrlsToArray(picUrls string) []string {
	if picUrls == "" {
		return []string{}
	}

	// 尝试解析为 JSON 数组
	var urls []string
	if err := json.Unmarshal([]byte(picUrls), &urls); err == nil && len(urls) > 0 {
		return normalizePicUrls(urls)
	}

	// 尝试按逗号分隔
	parts := strings.Split(picUrls, ",")
	result := make([]string, 0, len(parts))
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			result = append(result, p)
		}
	}
	return normalizePicUrls(result)
}

// normalizePicUrls 规范化图片URL列表
// 1. 已是完整URL（http/https开头）直接返回，前端无需拼接 imgBasePath
// 2. 带有 /dev-api/ 前缀的路径去除前缀（旧数据兼容）
// 3. 确保相对路径以 / 开头
func normalizePicUrls(urls []string) []string {
	result := make([]string, 0, len(urls))
	for _, url := range urls {
		url = strings.TrimSpace(url)
		if url == "" {
			continue
		}
		// 已是完整URL，直接保留
		if strings.HasPrefix(url, "http://") || strings.HasPrefix(url, "https://") {
			result = append(result, url)
			continue
		}
		// 去除 /dev-api/ 前缀（旧数据兼容）
		url = strings.TrimPrefix(url, "/dev-api")
		// 确保以 / 开头
		if !strings.HasPrefix(url, "/") {
			url = "/" + url
		}
		result = append(result, url)
	}
	return result
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
