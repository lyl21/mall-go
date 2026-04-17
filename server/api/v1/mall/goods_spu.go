package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"strconv"
)

type GoodsSpuApi struct{}

// CreateGoodsSpu
// @Tags      GoodsSpu
// @Summary   创建商品SPU
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsSpu                          true  "商品SPU信息"
// @Success   200   {object}  response.Response{msg=string}              "创建商品SPU"
// @Router    /mall/goodsSpu [post]
func (a *GoodsSpuApi) CreateGoodsSpu(c *gin.Context) {
	var spu mallModel.GoodsSpu
	err := c.ShouldBindJSON(&spu)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsSpuService.CreateGoodsSpu(spu)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteGoodsSpu
// @Tags      GoodsSpu
// @Summary   删除商品SPU
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "商品SPU ID"
// @Success   200   {object}  response.Response{msg=string}              "删除商品SPU"
// @Router    /mall/goodsSpu [delete]
func (a *GoodsSpuApi) DeleteGoodsSpu(c *gin.Context) {
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
	err = goodsSpuService.DeleteGoodsSpu(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateGoodsSpu
// @Tags      GoodsSpu
// @Summary   更新商品SPU
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsSpu                          true  "商品SPU信息"
// @Success   200   {object}  response.Response{msg=string}              "更新商品SPU"
// @Router    /mall/goodsSpu [put]
func (a *GoodsSpuApi) UpdateGoodsSpu(c *gin.Context) {
	var spu mallModel.GoodsSpu
	err := c.ShouldBindJSON(&spu)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsSpuService.UpdateGoodsSpu(spu)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetGoodsSpu
// @Tags      GoodsSpu
// @Summary   获取商品SPU信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "商品SPU ID"
// @Success   200  {object}  response.Response{data=mallModel.GoodsSpu,msg=string}  "获取商品SPU信息"
// @Router    /mall/goodsSpu [get]
func (a *GoodsSpuApi) GetGoodsSpu(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := goodsSpuService.GetGoodsSpu(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetGoodsSpuList
// @Tags      GoodsSpu
// @Summary   分页获取商品SPU列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page           query     int                               true  "页码"
// @Param     pageSize       query     int                               true  "每页大小"
// @Param     name           query     string                            false "商品名称"
// @Param     categoryFirst  query     string                            false "一级分类ID"
// @Param     shelf          query     string                            false "是否上架"
// @Success   200            {object}  response.Response{data=response.PageResult,msg=string}  "获取商品SPU列表"
// @Router    /mall/goodsSpuList [get]
func (a *GoodsSpuApi) GetGoodsSpuList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	name := c.Query("name")
	categoryFirst := c.Query("categoryFirst")
	shelfStr := c.Query("shelf")
	shelf := 0
	if shelfStr != "" {
		shelf, _ = strconv.Atoi(shelfStr)
	}
	list, total, err := goodsSpuService.GetGoodsSpuList(pageInfo, name, categoryFirst, shelf)
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
