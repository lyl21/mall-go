package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/gin-gonic/gin"
)

type ClientMxStoreMemberApi struct{}

var ClientMxStoreMemberApiApp = new(ClientMxStoreMemberApi)

type MxStoreMemberListReq struct {
	request.PageInfo
	StoreId int64 `json:"storeId" form:"storeId"`
}

func (a *ClientMxStoreMemberApi) List(c *gin.Context) {
	var req MxStoreMemberListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	list, total, err := storeService.StoreMemberServiceApp.GetMxStoreMemberList(req.PageInfo, req.StoreId)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientMxStoreMemberApi) GetInfo(c *gin.Context) {
	storeIdStr := c.Query("storeId")
	userIdStr := c.Query("userId")
	postStr := c.Query("post")

	if storeIdStr == "" || userIdStr == "" {
		ClientFailWithMessage("门店ID和用户ID不能为空", c)
		return
	}

	storeId, _ := strconv.ParseInt(storeIdStr, 10, 64)
	userId, _ := strconv.ParseInt(userIdStr, 10, 64)
	post := 0
	if postStr != "" {
		post, _ = strconv.Atoi(postStr)
	}

	var member store.MxStoreMember
	var err error
	if post > 0 {
		member, err = storeService.StoreMemberServiceApp.GetMxStoreMemberByStoreIdUserIdPost(storeId, userId, post)
	} else {
		member, err = storeService.StoreMemberServiceApp.GetMxStoreMember(storeId, userId)
	}
	
	if err != nil {
		ClientFailWithMessage("获取成员信息失败", c)
		return
	}

	ClientOkWithData(member, c)
}

func (a *ClientMxStoreMemberApi) Add(c *gin.Context) {
	var member store.MxStoreMember
	if err := c.ShouldBindJSON(&member); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := storeService.StoreMemberServiceApp.CreateMxStoreMember(member); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientMxStoreMemberApi) Edit(c *gin.Context) {
	var member store.MxStoreMember
	if err := c.ShouldBindJSON(&member); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := storeService.StoreMemberServiceApp.UpdateMxStoreMember(member); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientMxStoreMemberApi) Remove(c *gin.Context) {
	storeIdsStr := c.Param("storeIds")
	if storeIdsStr == "" {
		ClientFailWithMessage("门店ID不能为空", c)
		return
	}

	storeIds := strings.Split(storeIdsStr, ",")
	var ids []int64
	for _, idStr := range storeIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		ids = append(ids, id)
	}
	
	if len(ids) == 0 {
		ClientFailWithMessage("门店ID格式错误", c)
		return
	}
	
	storeService.StoreMemberServiceApp.DeleteMxStoreMemberByStoreIds(ids)

	ClientOkWithMessage("删除成功", c)
}
