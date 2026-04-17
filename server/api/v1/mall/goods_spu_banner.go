package mall

import (
	"fmt"
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type GoodsSpuBannerApi struct{}

// CreateGoodsSpuBanner
// @Tags      GoodsSpuBanner
// @Summary   创建商品轮播图
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsSpuBanner                    true  "轮播图信息"
// @Success   200   {object}  response.Response{msg=string}              "创建商品轮播图"
// @Router    /mall/goodsSpuBanner [post]
func (a *GoodsSpuBannerApi) CreateGoodsSpuBanner(c *gin.Context) {
	var banner mallModel.GoodsSpuBanner
	err := c.ShouldBindJSON(&banner)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsSpuBannerService.CreateGoodsSpuBanner(banner)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteGoodsSpuBanner
// @Tags      GoodsSpuBanner
// @Summary   删除商品轮播图
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]interface{}                      true  "轮播图ID"
// @Success   200   {object}  response.Response{msg=string}              "删除商品轮播图"
// @Router    /mall/goodsSpuBanner [delete]
func (a *GoodsSpuBannerApi) DeleteGoodsSpuBanner(c *gin.Context) {
	var req map[string]interface{}
	err := c.ShouldBindJSON(&req)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	idVal, ok := req["id"]
	if !ok {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	id, err := strconv.ParseInt(fmt.Sprintf("%v", idVal), 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	err = goodsSpuBannerService.DeleteGoodsSpuBanner(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateGoodsSpuBanner
// @Tags      GoodsSpuBanner
// @Summary   更新商品轮播图
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.GoodsSpuBanner                    true  "轮播图信息"
// @Success   200   {object}  response.Response{msg=string}              "更新商品轮播图"
// @Router    /mall/goodsSpuBanner [put]
func (a *GoodsSpuBannerApi) UpdateGoodsSpuBanner(c *gin.Context) {
	var banner mallModel.GoodsSpuBanner
	err := c.ShouldBindJSON(&banner)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = goodsSpuBannerService.UpdateGoodsSpuBanner(banner)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetGoodsSpuBanner
// @Tags      GoodsSpuBanner
// @Summary   获取商品轮播图信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     int64                                         true  "轮播图ID"
// @Success   200  {object}  response.Response{data=mallModel.GoodsSpuBanner,msg=string}  "获取商品轮播图信息"
// @Router    /mall/goodsSpuBanner [get]
func (a *GoodsSpuBannerApi) GetGoodsSpuBanner(c *gin.Context) {
	idStr := c.Query("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := goodsSpuBannerService.GetGoodsSpuBanner(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetGoodsSpuBannerList
// @Tags      GoodsSpuBanner
// @Summary   分页获取商品轮播图列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page        query     int                                    true  "页码"
// @Param     pageSize    query     int                                    true  "每页大小"
// @Param     goodsSpuId  query     string                                 false "商品SPU ID"
// @Success   200         {object}  response.Response{data=response.PageResult,msg=string}  "获取商品轮播图列表"
// @Router    /mall/goodsSpuBannerList [get]
func (a *GoodsSpuBannerApi) GetGoodsSpuBannerList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	goodsSpuId := c.Query("goodsSpuId")
	list, total, err := goodsSpuBannerService.GetGoodsSpuBannerList(pageInfo, goodsSpuId)
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
