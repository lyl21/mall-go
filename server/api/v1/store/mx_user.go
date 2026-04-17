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

type UserApi struct{}

// CreateMxUser
// @Tags      MxUser
// @Summary   创建用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUser               true  "用户信息"
// @Success   200   {object}  response.Response{msg=string}   "创建用户"
// @Router    /store/mxUser [post]
func (u *UserApi) CreateMxUser(c *gin.Context) {
	var user storeModel.MxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userService.CreateMxUser(user)
	if err != nil {
		global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("创建成功", c)
}

// DeleteMxUser
// @Tags      MxUser
// @Summary   删除用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUser               true  "用户信息"
// @Success   200   {object}  response.Response{msg=string}   "删除用户"
// @Router    /store/mxUser [delete]
func (u *UserApi) DeleteMxUser(c *gin.Context) {
	var user storeModel.MxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userService.DeleteMxUser(user)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// UpdateMxUser
// @Tags      MxUser
// @Summary   更新用户
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     data  body      storeModel.MxUser               true  "用户信息"
// @Success   200   {object}  response.Response{msg=string}   "更新用户"
// @Router    /store/mxUser [put]
func (u *UserApi) UpdateMxUser(c *gin.Context) {
	var user storeModel.MxUser
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	err = userService.UpdateMxUser(user)
	if err != nil {
		global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败:"+err.Error(), c)
		return
	}
	response.OkWithMessage("更新成功", c)
}

// GetMxUser
// @Tags      MxUser
// @Summary   获取用户信息
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     userId  query     int64                                   true  "用户ID"
// @Success   200     {object}  response.Response{data=storeModel.MxUser,msg=string}  "获取用户信息"
// @Router    /store/mxUser [get]
func (u *UserApi) GetMxUser(c *gin.Context) {
	userIdStr := c.Query("userId")
	userId, err := strconv.ParseInt(userIdStr, 10, 64)
	if err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}
	data, err := userService.GetMxUser(userId)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(data, "获取成功", c)
}

// GetMxUserList
// @Tags      MxUser
// @Summary   分页获取用户列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page     query     int                                true  "页码"
// @Param     pageSize query     int                                true  "每页大小"
// @Param     search   query     string                             false "搜索关键词"
// @Success   200      {object}  response.Response{data=response.PageResult,msg=string}  "获取用户列表"
// @Router    /store/mxUserList [get]
func (u *UserApi) GetMxUserList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	search := c.Query("search")
	list, total, err := userService.GetMxUserList(pageInfo, search)
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
