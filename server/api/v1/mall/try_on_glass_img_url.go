package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type TryOnGlassImgUrlApi struct{}

// CreateTryOnGlassImgUrl
// @Tags      TryOnGlassImgUrl
// @Summary   创建试戴眼镜图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.TryOnGlassImgUrl                   true  "试戴图片信息"
// @Success   200   {object}  response.Response{msg=string}              "创建试戴眼镜图片"
// @Router    /mall/tryOnGlassImgUrl [post]
func (a *TryOnGlassImgUrlApi) CreateTryOnGlassImgUrl(c *gin.Context) {
	var img mallModel.TryOnGlassImgUrl
	err := c.ShouldBindJSON(&img)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = tryOnGlassImgUrlService.CreateTryOnGlassImgUrl(img)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteTryOnGlassImgUrl
// @Tags      TryOnGlassImgUrl
// @Summary   删除试戴眼镜图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      map[string]string                           true  "试戴图片ID"
// @Success   200   {object}  response.Response{msg=string}              "删除试戴眼镜图片"
// @Router    /mall/tryOnGlassImgUrl [delete]
func (a *TryOnGlassImgUrlApi) DeleteTryOnGlassImgUrl(c *gin.Context) {
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
	err = tryOnGlassImgUrlService.DeleteTryOnGlassImgUrl(id)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateTryOnGlassImgUrl
// @Tags      TryOnGlassImgUrl
// @Summary   更新试戴眼镜图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      mallModel.TryOnGlassImgUrl                   true  "试戴图片信息"
// @Success   200   {object}  response.Response{msg=string}              "更新试戴眼镜图片"
// @Router    /mall/tryOnGlassImgUrl [put]
func (a *TryOnGlassImgUrlApi) UpdateTryOnGlassImgUrl(c *gin.Context) {
	var img mallModel.TryOnGlassImgUrl
	err := c.ShouldBindJSON(&img)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = tryOnGlassImgUrlService.UpdateTryOnGlassImgUrl(img)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetTryOnGlassImgUrl
// @Tags      TryOnGlassImgUrl
// @Summary   获取试戴眼镜图片信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     id  query     string                                        true  "试戴图片ID"
// @Success   200  {object}  response.Response{data=mallModel.TryOnGlassImgUrl,msg=string}  "获取试戴眼镜图片信息"
// @Router    /mall/tryOnGlassImgUrl [get]
func (a *TryOnGlassImgUrlApi) GetTryOnGlassImgUrl(c *gin.Context) {
	id := c.Query("id")
	if id == "" {
		response.FailWithMessage("缺少参数id", c)
		return
	}
	data, err := tryOnGlassImgUrlService.GetTryOnGlassImgUrl(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetTryOnGlassImgUrlList
// @Tags      TryOnGlassImgUrl
// @Summary   分页获取试戴眼镜图片列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int                                    true  "页码"
// @Param     pageSize   query     int                                    true  "每页大小"
// @Param     wxUserId   query     string                                 false "微信用户ID"
// @Param     goodsSpuId query     string                                 false "商品SPU ID"
// @Success   200        {object}  response.Response{data=response.PageResult,msg=string}  "获取试戴眼镜图片列表"
// @Router    /mall/tryOnGlassImgUrlList [get]
func (a *TryOnGlassImgUrlApi) GetTryOnGlassImgUrlList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	wxUserId := c.Query("wxUserId")
	goodsSpuId := c.Query("goodsSpuId")
	list, total, err := tryOnGlassImgUrlService.GetTryOnGlassImgUrlList(pageInfo, wxUserId, goodsSpuId)
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
