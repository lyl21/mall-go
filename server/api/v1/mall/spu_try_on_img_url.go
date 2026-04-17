package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type SpuTryOnImgUrlApi struct{}

// CreateSpuTryOnImgUrl
// @Tags      SpuTryOnImgUrl
// @Summary   创建商品试戴图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.SpuTryOnImgUrl                    true  "试戴图片信息"
// @Success   200   {object}  response.Response{msg=string}              "创建商品试戴图片"
// @Router    /mall/spuTryOnImgUrl [post]
func (a *SpuTryOnImgUrlApi) CreateSpuTryOnImgUrl(c *gin.Context) {
	var img mallModel.SpuTryOnImgUrl
	err := c.ShouldBindJSON(&img)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = spuTryOnImgUrlService.CreateSpuTryOnImgUrl(img)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteSpuTryOnImgUrl
// @Tags      SpuTryOnImgUrl
// @Summary   删除商品试戴图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "试戴图片ID"
// @Success   200   {object}  response.Response{msg=string}              "删除商品试戴图片"
// @Router    /mall/spuTryOnImgUrl [delete]
func (a *SpuTryOnImgUrlApi) DeleteSpuTryOnImgUrl(c *gin.Context) {
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
	err = spuTryOnImgUrlService.DeleteSpuTryOnImgUrl(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateSpuTryOnImgUrl
// @Tags      SpuTryOnImgUrl
// @Summary   更新商品试戴图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.SpuTryOnImgUrl                    true  "试戴图片信息"
// @Success   200   {object}  response.Response{msg=string}              "更新商品试戴图片"
// @Router    /mall/spuTryOnImgUrl [put]
func (a *SpuTryOnImgUrlApi) UpdateSpuTryOnImgUrl(c *gin.Context) {
	var img mallModel.SpuTryOnImgUrl
	err := c.ShouldBindJSON(&img)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = spuTryOnImgUrlService.UpdateSpuTryOnImgUrl(img)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetSpuTryOnImgUrl
// @Tags      SpuTryOnImgUrl
// @Summary   获取商品试戴图片信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "试戴图片ID"
// @Success   200  {object}  response.Response{data=mallModel.SpuTryOnImgUrl,msg=string}  "获取商品试戴图片信息"
// @Router    /mall/spuTryOnImgUrl [get]
func (a *SpuTryOnImgUrlApi) GetSpuTryOnImgUrl(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := spuTryOnImgUrlService.GetSpuTryOnImgUrl(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetSpuTryOnImgUrlList
// @Tags      SpuTryOnImgUrl
// @Summary   分页获取商品试戴图片列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int                                    true  "页码"
// @Param     pageSize   query     int                                    true  "每页大小"
// @Param     goodsSpuId query     string                                 false "商品SPU ID"
// @Success   200        {object}  response.Response{data=response.PageResult,msg=string}  "获取商品试戴图片列表"
// @Router    /mall/spuTryOnImgUrlList [get]
func (a *SpuTryOnImgUrlApi) GetSpuTryOnImgUrlList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	goodsSpuId := c.Query("goodsSpuId")
	list, total, err := spuTryOnImgUrlService.GetSpuTryOnImgUrlList(pageInfo, goodsSpuId)
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
