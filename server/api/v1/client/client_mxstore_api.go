package client

import (
	"strconv"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/gin-gonic/gin"
)

type ClientMxStoreApi struct{}

var ClientMxStoreApiApp = new(ClientMxStoreApi)

type MxStoreListReq struct {
	request.PageInfo
	Name        string `json:"name" form:"name"`
	PhoneNumber string `json:"phoneNumber" form:"phoneNumber"`
	StoreNumber string `json:"storeNumber" form:"storeNumber"`
}

func (a *ClientMxStoreApi) List(c *gin.Context) {
	var req MxStoreListReq
	if err := c.ShouldBindQuery(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	search := store.MxStore{}
	if req.Name != "" {
		search.StoreNameEnglish = req.Name
	}
	if req.PhoneNumber != "" {
		search.StorePhone = req.PhoneNumber
	}
	if req.StoreNumber != "" {
		search.StoreNumber = req.StoreNumber
	}

	list, total, err := storeService.StoreServiceApp.GetMxStoreList(req.PageInfo, search)
	if err != nil {
		ClientFailWithMessage("获取列表失败", c)
		return
	}

	ClientPageResult(list, total, "查询成功", c)
}

func (a *ClientMxStoreApi) GetInfo(c *gin.Context) {
	storeIdStr := c.Param("storeId")
	if storeIdStr == "" {
		storeIdStr = c.Query("storeId")
	}

	if storeIdStr == "" {
		ClientFailWithMessage("门店ID不能为空", c)
		return
	}

	storeId, err := strconv.ParseInt(storeIdStr, 10, 64)
	if err != nil {
		ClientFailWithMessage("门店ID格式错误", c)
		return
	}

	storeInfo, err := storeService.StoreServiceApp.GetMxStore(storeId)
	if err != nil {
		ClientFailWithMessage("获取门店信息失败", c)
		return
	}

	ClientOkWithData(storeInfo, c)
}

func (a *ClientMxStoreApi) Add(c *gin.Context) {
	var req struct {
		store.MxStore
		UserId   int64 `json:"userId"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	member := store.MxStoreMember{
		UserId: req.UserId,
		Post:   1,
	}

	if err := storeService.StoreServiceApp.CreateMxStore(req.MxStore, member); err != nil {
		ClientFailWithMessage("创建失败", c)
		return
	}

	ClientOkWithMessage("创建成功", c)
}

func (a *ClientMxStoreApi) Edit(c *gin.Context) {
	var store store.MxStore
	if err := c.ShouldBindJSON(&store); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	if err := storeService.StoreServiceApp.UpdateMxStore(store); err != nil {
		ClientFailWithMessage("更新失败", c)
		return
	}

	ClientOkWithMessage("更新成功", c)
}

func (a *ClientMxStoreApi) Remove(c *gin.Context) {
	storeIdsStr := c.Param("storeIds")
	if storeIdsStr == "" {
		ClientFailWithMessage("门店ID不能为空", c)
		return
	}

	storeIds := strings.Split(storeIdsStr, ",")
	for _, idStr := range storeIds {
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			continue
		}
		store := store.MxStore{StoreId: id}
		storeService.StoreServiceApp.DeleteMxStore(store)
	}

	ClientOkWithMessage("删除成功", c)
}
