package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type GoodsCategoryApi struct{}

// CreateGoodsCategory
// @Tags      GoodsCategory
// @Summary   创建商品分类
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsCategory                     true  "商品分类信息"
// @Success   200   {object}  response.Response{msg=string}              "创建商品分类"
// @Router    /mall/goodsCategory [post]
func (a *GoodsCategoryApi) CreateGoodsCategory(c *gin.Context) {
	var category mallModel.GoodsCategory
	err := c.ShouldBindJSON(&category)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsCategoryService.CreateGoodsCategory(category)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteGoodsCategory
// @Tags      GoodsCategory
// @Summary   删除商品分类
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "分类ID"
// @Success   200   {object}  response.Response{msg=string}              "删除商品分类"
// @Router    /mall/goodsCategory [delete]
func (a *GoodsCategoryApi) DeleteGoodsCategory(c *gin.Context) {
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
	err = goodsCategoryService.DeleteGoodsCategory(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateGoodsCategory
// @Tags      GoodsCategory
// @Summary   更新商品分类
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsCategory                     true  "商品分类信息"
// @Success   200   {object}  response.Response{msg=string}              "更新商品分类"
// @Router    /mall/goodsCategory [put]
func (a *GoodsCategoryApi) UpdateGoodsCategory(c *gin.Context) {
	var category mallModel.GoodsCategory
	err := c.ShouldBindJSON(&category)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsCategoryService.UpdateGoodsCategory(category)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetGoodsCategory
// @Tags      GoodsCategory
// @Summary   获取商品分类信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "分类ID"
// @Success   200  {object}  response.Response{data=mallModel.GoodsCategory,msg=string}  "获取商品分类信息"
// @Router    /mall/goodsCategory [get]
func (a *GoodsCategoryApi) GetGoodsCategory(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := goodsCategoryService.GetGoodsCategory(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetGoodsCategoryList
// @Tags      GoodsCategory
// @Summary   分页获取商品分类列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page      query     int                                    true  "页码"
// @Param     pageSize  query     int                                    true  "每页大小"
// @Param     name      query     string                                 false "分类名称"
// @Param     parentId  query     string                                 false "父分类ID"
// @Success   200       {object}  response.Response{data=response.PageResult,msg=string}  "获取商品分类列表"
// @Router    /mall/goodsCategoryList [get]
func (a *GoodsCategoryApi) GetGoodsCategoryList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	if pageInfo.Page == 0 {
		pageInfo.Page = 1
	}
	if pageInfo.PageSize == 0 {
		pageInfo.PageSize = 10
	}
	name := c.Query("name")
	parentId := c.Query("parentId")
	list, total, err := goodsCategoryService.GetGoodsCategoryList(pageInfo, name, parentId)
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

// GetGoodsCategoryTree
// @Tags      GoodsCategory
// @Summary   获取商品分类树
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Success   200  {object}  response.Response{data=[]mallModel.GoodsCategory,msg=string}  "获取商品分类树"
// @Router    /mall/goodsCategoryTree [get]
func (a *GoodsCategoryApi) GetGoodsCategoryTree(c *gin.Context) {
	list, err := goodsCategoryService.GetGoodsCategoryTree()
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败:"+err.Error(), c)
		return
	}
	response.OkWithDetailed(list, "获取成功", c)
}
