package store

import (
	"strconv"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type PictureApi struct{}

// CreateMxPicture
// @Tags      MxPicture
// @Summary   创建图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxPicture              true  "图片信息"
// @Success   200   {object}  response.Response{msg=string}    "创建图片"
// @Router    /store/mxPicture [post]
func (p *PictureApi) CreateMxPicture(c *gin.Context) {
	var picture storeModel.MxPicture
	err := c.ShouldBindJSON(&picture)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = pictureService.CreateMxPicture(picture)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteMxPicture
// @Tags      MxPicture
// @Summary   删除图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxPicture              true  "图片信息"
// @Success   200   {object}  response.Response{msg=string}    "删除图片"
// @Router    /store/mxPicture [delete]
func (p *PictureApi) DeleteMxPicture(c *gin.Context) {
	var picture storeModel.MxPicture
	err := c.ShouldBindJSON(&picture)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = pictureService.DeleteMxPicture(picture)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxPicture
// @Tags      MxPicture
// @Summary   更新图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxPicture              true  "图片信息"
// @Success   200   {object}  response.Response{msg=string}    "更新图片"
// @Router    /store/mxPicture [put]
func (p *PictureApi) UpdateMxPicture(c *gin.Context) {
	var picture storeModel.MxPicture
	err := c.ShouldBindJSON(&picture)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = pictureService.UpdateMxPicture(picture)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxPicture
// @Tags      MxPicture
// @Summary   获取图片
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     pictureId  query     int64                                      true  "图片ID"
// @Success   200        {object}  response.Response{data=storeModel.MxPicture,msg=string}  "获取图片"
// @Router    /store/mxPicture [get]
func (p *PictureApi) GetMxPicture(c *gin.Context) {
	idStr := c.Query("pictureId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := pictureService.GetMxPicture(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxPictureList
// @Tags      MxPicture
// @Summary   分页获取图片列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取图片列表"
// @Router    /store/mxPictureList [get]
func (p *PictureApi) GetMxPictureList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := pictureService.GetMxPictureList(pageInfo)
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
