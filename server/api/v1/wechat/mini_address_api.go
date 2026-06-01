package wechat

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// MiniAddressApi 小程序地址管理API
type MiniAddressApi struct{}

// GetAddressPage 获取地址列表（从JWT获取用户身份）
// @Tags      MiniAddress
// @Summary   小程序获取地址列表
// @Produce   application/json
// @Param     page      query     int     false  "页码"
// @Param     pageSize  query     int     false  "每页数量"
// @Success   200  {object}  response.Response{data=[]mall.UserAddress}  "获取成功"
// @Router    /weixin/api/ma/useraddress/page [get]
func (a *MiniAddressApi) GetAddressPage(c *gin.Context) {
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}
	page := utils.GetIntQuery(c, "page", 1)
	pageSize := utils.GetIntQuery(c, "pageSize", 100)
	offset := (page - 1) * pageSize

	var total int64
	db := global.GVA_DB.Model(&mall.UserAddress{}).Where("user_id = ? AND del_flag = ?", userId, "0")
	db.Count(&total)

	var list []mall.UserAddress
	err := db.Order("is_default DESC, create_time DESC").Limit(pageSize).Offset(offset).Find(&list).Error
	if err != nil {
		global.GVA_LOG.Error("获取地址列表失败", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithData(gin.H{"list": list, "total": total}, c)
}

// AddAddress 添加/更新地址（前端只调 POST，id 存在时走更新逻辑）
// @Tags      MiniAddress
// @Summary   小程序新增/保存地址
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      mall.UserAddress  true  "地址信息"
// @Success   200   {object}  response.Response{msg=string}  "保存成功"
// @Router    /weixin/api/ma/useraddress [post]
func (a *MiniAddressApi) AddAddress(c *gin.Context) {
	var addr mall.UserAddress
	if err := c.ShouldBindJSON(&addr); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}
	addr.UserId = userId // JWT 强制覆盖

	// 校验必填字段
	if addr.UserName == "" {
		response.FailWithMessage("收货人姓名不能为空", c)
		return
	}
	if addr.TelNum == "" {
		response.FailWithMessage("手机号不能为空", c)
		return
	}
	if addr.DetailInfo == "" {
		response.FailWithMessage("详细地址不能为空", c)
		return
	}

	// 如果设置为默认地址，取消其他默认地址
	if addr.IsDefault == "1" {
		global.GVA_DB.Model(&mall.UserAddress{}).Where("user_id = ?", addr.UserId).Update("is_default", "0")
	}

	// 如果带了 id 且属于当前用户，走更新逻辑
	if addr.Id != "" {
		var existing mall.UserAddress
		if err := global.GVA_DB.Where("id = ? AND user_id = ? AND del_flag = ?", addr.Id, userId, "0").First(&existing).Error; err == nil {
			addr.DelFlag = "0"
			if err := global.GVA_DB.Model(&existing).Updates(&addr).Error; err != nil {
				global.GVA_LOG.Error("更新地址失败", zap.Error(err))
				response.FailWithMessage("更新失败", c)
				return
			}
			response.OkWithData(existing, c)
			return
		}
	}

	addr.Id = uuid.New().String()
	addr.DelFlag = "0"

	if err := global.GVA_DB.Create(&addr).Error; err != nil {
		global.GVA_LOG.Error("添加地址失败", zap.Error(err))
		response.FailWithMessage("添加失败", c)
		return
	}

	response.OkWithData(addr, c)
}

// UpdateAddress 更新地址
// @Tags      MiniAddress
// @Summary   小程序更新地址
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      mall.UserAddress  true  "地址信息"
// @Success   200   {object}  response.Response{msg=string}  "更新成功"
// @Router    /weixin/api/ma/useraddress [put]
func (a *MiniAddressApi) UpdateAddress(c *gin.Context) {
	var addr mall.UserAddress
	if err := c.ShouldBindJSON(&addr); err != nil {
		response.FailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	if addr.Id == "" {
		response.FailWithMessage("地址ID不能为空", c)
		return
	}

	// 校验用户身份，防止越权修改
	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	// 验证地址属于当前用户
	var existing mall.UserAddress
	if err := global.GVA_DB.Where("id = ? AND user_id = ? AND del_flag = ?", addr.Id, userId, "0").First(&existing).Error; err != nil {
		response.FailWithMessage("地址不存在或无权修改", c)
		return
	}

	// 如果设置为默认地址，取消其他默认地址
	if addr.IsDefault == "1" {
		global.GVA_DB.Model(&mall.UserAddress{}).Where("user_id = ? AND id != ?", userId, addr.Id).Update("is_default", "0")
	}

	updateData := map[string]interface{}{
		"user_name":     addr.UserName,
		"postal_code":   addr.PostalCode,
		"province_name": addr.ProvinceName,
		"city_name":     addr.CityName,
		"county_name":   addr.CountyName,
		"detail_info":   addr.DetailInfo,
		"tel_num":       addr.TelNum,
		"is_default":    addr.IsDefault,
	}

	// 更新时增加 user_id 条件，防止越权
	if err := global.GVA_DB.Model(&mall.UserAddress{}).Where("id = ? AND user_id = ?", addr.Id, userId).Updates(updateData).Error; err != nil {
		global.GVA_LOG.Error("更新地址失败", zap.Error(err))
		response.FailWithMessage("更新失败", c)
		return
	}

	response.OkWithMessage("更新成功", c)
}

// DeleteAddress 删除地址
// @Tags      MiniAddress
// @Summary   小程序删除地址
// @Produce   application/json
// @Param     id   path      string  true  "地址ID"
// @Success   200  {object}  response.Response{msg=string}  "删除成功"
// @Router    /weixin/api/ma/useraddress/{id} [delete]
func (a *MiniAddressApi) DeleteAddress(c *gin.Context) {
	id := c.Param("id")
	if id == "" {
		response.FailWithMessage("地址ID不能为空", c)
		return
	}

	userId := getWxUserIdFromContext(c)
	if userId == "" {
		response.FailWithMessage("请先登录", c)
		return
	}

	if err := global.GVA_DB.Model(&mall.UserAddress{}).Where("id = ? AND user_id = ?", id, userId).Update("del_flag", "1").Error; err != nil {
		global.GVA_LOG.Error("删除地址失败", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}

	response.OkWithMessage("删除成功", c)
}
