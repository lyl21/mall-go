package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/gin-gonic/gin"
)

type ClientMxUserApi struct{}

var ClientMxUserApiApp = new(ClientMxUserApi)

type MxUserListReq struct {
	request.PageInfo
	Name     string `json:"name" form:"name"`
	UserId   *int64 `json:"userId" form:"userId"`
}

func (a *ClientMxUserApi) List(c *gin.Context) {
	var req MxUserListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	user := store.MxUser{}
	if req.Name != "" {
		user.Name = req.Name
	}
	if req.UserId != nil {
		user.UserId = *req.UserId
	}

	list, total, err := storeService.UserServiceApp.GetMxUserList(req.PageInfo, req.Name)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientMxUserApi) GetInfo(c *gin.Context) {
	userIdStr := c.Query("userId")
	if userIdStr == "" {
		userIdStr = c.Param("userId")
	}

	if userIdStr == "" {
		userIdVal, exists := c.Get("clientUserId")
		if !exists {
			ClientFailWithMessage("用户ID不能为空", c)
			return
		}
		if userId, ok := userIdVal.(int64); ok {
			user, err := storeService.UserServiceApp.GetMxUser(userId)
			if err != nil {
				ClientFailWithMessage("获取用户信息失败", c)
				return
			}
			ClientOkWithData(user, c)
			return
		}
	}

	userId, err := strconv.ParseInt(userIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("用户ID格式错误", c)
		return
	}

	user, err := storeService.UserServiceApp.GetMxUser(userId)
	if err != nil {
		ClientFailWithMessage("获取用户信息失败", c)
		return
	}

	ClientOkWithData(user, c)
}

func (a *ClientMxUserApi) Add(c *gin.Context) {
	var req struct {
		store.MxUser
		StoreId   *int64 `json:"storeId"`
		Post      *int   `json:"post"`
		StoreName string `json:"storeName"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if req.MxUser.Password == "" {
		req.MxUser.Password = "123456"
	}

	if err := storeService.UserServiceApp.CreateMxUser(req.MxUser); err != nil {
		ClientFailWithMessage("创建用户失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientMxUserApi) Edit(c *gin.Context) {
	var user store.MxUser
	if err := c.ShouldBindJSON(&user); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := storeService.UserServiceApp.UpdateMxUser(user); err != nil {
		ClientFailWithMessage("更新用户失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientMxUserApi) Remove(c *gin.Context) {
	userIdsStr := c.Param("userIds")
	if userIdsStr == "" {
		ClientFailWithMessage("用户ID不能为空", c)
		return
	}

	userIds := strings.Split(userIdsStr, ",")
	for _, idStr := range userIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		user := store.MxUser{UserId: id}
		storeService.UserServiceApp.DeleteMxUser(user)
	}

	ClientOkWithMessage("删除成功", c)
}
