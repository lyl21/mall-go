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

type InstallingPackageApi struct{}

// CreateInstallingPackage
// @Tags      InstallingPackage
// @Summary   创建安装包
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.InstallingPackage        true  "安装包信息"
// @Success   200   {object}  response.Response{msg=string}      "创建安装包"
// @Router    /store/installingPackage [post]
func (i *InstallingPackageApi) CreateInstallingPackage(c *gin.Context) {
	var pkg storeModel.InstallingPackage
	err := c.ShouldBindJSON(&pkg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = installingPkgService.CreateInstallingPackage(pkg)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteInstallingPackage
// @Tags      InstallingPackage
// @Summary   删除安装包
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.InstallingPackage        true  "安装包信息"
// @Success   200   {object}  response.Response{msg=string}      "删除安装包"
// @Router    /store/installingPackage [delete]
func (i *InstallingPackageApi) DeleteInstallingPackage(c *gin.Context) {
	var pkg storeModel.InstallingPackage
	err := c.ShouldBindJSON(&pkg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = installingPkgService.DeleteInstallingPackage(pkg)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateInstallingPackage
// @Tags      InstallingPackage
// @Summary   更新安装包
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.InstallingPackage        true  "安装包信息"
// @Success   200   {object}  response.Response{msg=string}      "更新安装包"
// @Router    /store/installingPackage [put]
func (i *InstallingPackageApi) UpdateInstallingPackage(c *gin.Context) {
	var pkg storeModel.InstallingPackage
	err := c.ShouldBindJSON(&pkg)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = installingPkgService.UpdateInstallingPackage(pkg)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetInstallingPackage
// @Tags      InstallingPackage
// @Summary   获取安装包
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     installingId  query     int64                                                  true  "安装包ID"
// @Success   200           {object}  response.Response{data=storeModel.InstallingPackage,msg=string}  "获取安装包"
// @Router    /store/installingPackage [get]
func (i *InstallingPackageApi) GetInstallingPackage(c *gin.Context) {
	idStr := c.Query("installingId")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := installingPkgService.GetInstallingPackage(id)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetInstallingPackageList
// @Tags      InstallingPackage
// @Summary   分页获取安装包列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取安装包列表"
// @Router    /store/installingPackageList [get]
func (i *InstallingPackageApi) GetInstallingPackageList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	list, total, err := installingPkgService.GetInstallingPackageList(pageInfo)
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
