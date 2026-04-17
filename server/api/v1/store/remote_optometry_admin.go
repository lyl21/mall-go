package store

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// RemoteOptometryAdminApi 远程验光后台管理API
type RemoteOptometryAdminApi struct{}

// GetRemoteOptometryStatusList 获取远程验光实时状态列表
// @Tags      RemoteOptometryAdmin
// @Summary   获取远程验光实时状态列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int     false  "页码"
// @Param     pageSize   query     int     false  "每页大小"
// @Param     equipment  query     string  false  "设备号"
// @Param     userId     query     string  false  "用户ID"
// @Param     isOnline   query     bool    false  "是否在线"
// @Success   200        {object}  response.Response{data=response.PageResult}  "获取成功"
// @Router    /store/remoteOptometry/statusList [get]
func (a *RemoteOptometryAdminApi) GetRemoteOptometryStatusList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	equipment := c.Query("equipment")
	userId := c.Query("userId")
	isOnline := c.Query("isOnline")

	// 从WebSocket管理器获取实时状态
	if utils.RemoteOptometryManager == nil {
		response.OkWithDetailed(response.PageResult{
			List:     []store.RemoteOptometryStatus{},
			Total:    0,
			Page:     pageInfo.Page,
			PageSize: pageInfo.PageSize,
		}, "获取成功", c)
		return
	}

	// 获取所有会话状态
	stats := utils.RemoteOptometryManager.GetStats()
	sessions, ok := stats["sessions"].([]map[string]interface{})
	if !ok {
		response.OkWithDetailed(response.PageResult{
			List:     []store.RemoteOptometryStatus{},
			Total:    0,
			Page:     pageInfo.Page,
			PageSize: pageInfo.PageSize,
		}, "获取成功", c)
		return
	}

	var statusList []store.RemoteOptometryStatus
	for _, sessionInfo := range sessions {
		status := store.RemoteOptometryStatus{
			SessionId:       getString(sessionInfo["sessionId"]),
			IsOnline:        getBool(sessionInfo["hasMainControl"]) || getBool(sessionInfo["hasControlled"]),
			IsControlActive: getBool(sessionInfo["isControlActive"]),
			StartTime:       parseTime(sessionInfo["createdAt"]),
			LastActiveTime:  time.Now(),
		}

		// 过滤条件
		if equipment != "" && status.Equipment != equipment {
			continue
		}
		if isOnline == "true" && !status.IsOnline {
			continue
		}
		if isOnline == "false" && status.IsOnline {
			continue
		}
		if userId != "" && (status.UserId == nil || int64ToStr(*status.UserId) != userId) {
			continue
		}

		statusList = append(statusList, status)
	}

	// 分页
	total := len(statusList)
	start := (pageInfo.Page - 1) * pageInfo.PageSize
	end := start + pageInfo.PageSize
	if start > total {
		start = total
	}
	if end > total {
		end = total
	}
	pageList := statusList[start:end]

	response.OkWithDetailed(response.PageResult{
		List:     pageList,
		Total:    int64(total),
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}

// GetRemoteOptometryLogList 获取远程验光日志列表
// @Tags      RemoteOptometryAdmin
// @Summary   获取远程验光日志列表
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int     false  "页码"
// @Param     pageSize   query     int     false  "每页大小"
// @Param     equipment  query     string  false  "设备号"
// @Param     userId     query     string  false  "用户ID"
// @Param     sessionId  query     string  false  "会话ID"
// @Success   200        {object}  response.Response{data=response.PageResult}  "获取成功"
// @Router    /store/remoteOptometry/logList [get]
func (a *RemoteOptometryAdminApi) GetRemoteOptometryLogList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	equipment := c.Query("equipment")
	userId := c.Query("userId")
	sessionId := c.Query("sessionId")

	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)

	db := global.GVA_DB.Model(&store.RemoteOptometryLog{})
	if equipment != "" {
		db = db.Where("equipment = ?", equipment)
	}
	if userId != "" {
		db = db.Where("user_id = ?", userId)
	}
	if sessionId != "" {
		db = db.Where("session_id = ?", sessionId)
	}

	var total int64
	if err := db.Count(&total).Error; err != nil {
		global.GVA_LOG.Error("查询远程验光日志失败", zap.Error(err))
		response.FailWithMessage("查询失败", c)
		return
	}

	var logList []store.RemoteOptometryLog
	if err := db.Limit(limit).Offset(offset).Order("start_time DESC").Find(&logList).Error; err != nil {
		global.GVA_LOG.Error("查询远程验光日志失败", zap.Error(err))
		response.FailWithMessage("查询失败", c)
		return
	}

	response.OkWithDetailed(response.PageResult{
		List:     logList,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}

// GetRemoteOptometryDetail 获取远程验光会话详情
// @Tags      RemoteOptometryAdmin
// @Summary   获取远程验光会话详情
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     sessionId  query     string  true  "会话ID"
// @Success   200        {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /store/remoteOptometry/detail [get]
func (a *RemoteOptometryAdminApi) GetRemoteOptometryDetail(c *gin.Context) {
	sessionId := c.Query("sessionId")
	if sessionId == "" {
		response.FailWithMessage("会话ID不能为空", c)
		return
	}

	// 查询日志详情
	var log store.RemoteOptometryLog
	if err := global.GVA_DB.Where("session_id = ?", sessionId).First(&log).Error; err != nil {
		global.GVA_LOG.Error("查询远程验光详情失败", zap.Error(err))
		response.FailWithMessage("查询失败", c)
		return
	}

	response.OkWithDetailed(log, "获取成功", c)
}

// GetNiuTouDeviceStatus 获取牛头设备状态
// @Tags      RemoteOptometryAdmin
// @Summary   获取牛头设备状态
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     equipment  query     string  true  "设备号"
// @Success   200        {object}  response.Response{data=map[string]interface{}}  "获取成功"
// @Router    /store/remoteOptometry/deviceStatus [get]
func (a *RemoteOptometryAdminApi) GetNiuTouDeviceStatus(c *gin.Context) {
	equipment := c.Query("equipment")
	if equipment == "" {
		response.FailWithMessage("设备号不能为空", c)
		return
	}

	// 查询设备激活信息
	var activation store.MxActivationCode
	if err := global.GVA_DB.Where("equipment = ?", equipment).First(&activation).Error; err != nil {
		global.GVA_LOG.Error("查询设备信息失败", zap.Error(err))
		response.FailWithMessage("设备不存在", c)
		return
	}

	// 查询最新的远控日志
	var latestLog store.RemoteOptometryLog
	db := global.GVA_DB.Where("equipment = ?", equipment).Order("start_time DESC").First(&latestLog)

	// 查询设备是否在线（有活跃会话）
	isInControl := false
	controlSessionId := ""
	if utils.RemoteOptometryManager != nil {
		// 遍历所有会话检查设备是否在线
		stats := utils.RemoteOptometryManager.GetStats()
		if sessions, ok := stats["sessions"].([]map[string]interface{}); ok {
			for _, session := range sessions {
				if getBool(session["hasControlled"]) || getBool(session["hasMainControl"]) {
					isInControl = true
					controlSessionId = getString(session["sessionId"])
					break
				}
			}
		}
	}

	result := gin.H{
		"equipment":        activation.Equipment,
		"deviceName":       activation.DeviceName,
		"deviceLocation":   activation.DeviceLocation,
		"onlineStatus":     activation.OnlineStatus,
		"lastOnlineTime":   activation.LastOnlineTime,
		"isInControl":      isInControl,
		"controlSessionId": controlSessionId,
	}

	if db.Error == nil {
		result["latestControlStatus"] = latestLog.ControlStatus
		result["niuTouConnected"] = latestLog.NiuTouConnected
		result["lensMode"] = latestLog.LensMode
		result["leftS"] = latestLog.LeftS
		result["rightS"] = latestLog.RightS
		result["lastActiveTime"] = latestLog.LastActiveTime
	}

	response.OkWithDetailed(result, "获取成功", c)
}

// GetNiuTouDeviceList 获取牛头设备列表（带远控状态）
// @Tags      RemoteOptometryAdmin
// @Summary   获取牛头设备列表（带远控状态）
// @Security  ApiKeyAuth
// @accept    application/json
// @Produce   application/json
// @Param     page       query     int     false  "页码"
// @Param     pageSize   query     int     false  "每页大小"
// @Param     onlineStatus query   int     false  "在线状态 0离线 1在线"
// @Success   200        {object}  response.Response{data=response.PageResult}  "获取成功"
// @Router    /store/remoteOptometry/deviceList [get]
func (a *RemoteOptometryAdminApi) GetNiuTouDeviceList(c *gin.Context) {
	var pageInfo request.PageInfo
	err := c.ShouldBindQuery(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	onlineStatus := c.Query("onlineStatus")

	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)

	db := global.GVA_DB.Model(&store.MxActivationCode{}).Where("app = ?", "牛头APP")
	if onlineStatus != "" {
		db = db.Where("online_status = ?", onlineStatus)
	}

	var total int64
	if err := db.Count(&total).Error; err != nil {
		global.GVA_LOG.Error("查询设备列表失败", zap.Error(err))
		response.FailWithMessage("查询失败", c)
		return
	}

	var devices []store.MxActivationCode
	if err := db.Limit(limit).Offset(offset).Order("last_online_time DESC").Find(&devices).Error; err != nil {
		global.GVA_LOG.Error("查询设备列表失败", zap.Error(err))
		response.FailWithMessage("查询失败", c)
		return
	}

	// 获取远控统计信息
	var deviceList []gin.H
	for _, device := range devices {
		deviceInfo := gin.H{
			"equipment":      device.Equipment,
			"deviceName":     device.DeviceName,
			"deviceLocation": device.DeviceLocation,
			"onlineStatus":   device.OnlineStatus,
			"lastOnlineTime": device.LastOnlineTime,
		}

		// 查询最新的远控记录
		var latestLog store.RemoteOptometryLog
		if err := global.GVA_DB.Where("equipment = ?", device.Equipment).
			Order("start_time DESC").First(&latestLog).Error; err == nil {
			deviceInfo["isInControl"] = latestLog.IsControlActive
			deviceInfo["controlStatus"] = latestLog.ControlStatus
			deviceInfo["niuTouConnected"] = latestLog.NiuTouConnected
			deviceInfo["lensMode"] = latestLog.LensMode
			deviceInfo["lastActiveTime"] = latestLog.LastActiveTime
		}

		deviceList = append(deviceList, deviceInfo)
	}

	response.OkWithDetailed(response.PageResult{
		List:     deviceList,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}

// Helper functions
func getString(v interface{}) string {
	if s, ok := v.(string); ok {
		return s
	}
	return ""
}

func getBool(v interface{}) bool {
	if b, ok := v.(bool); ok {
		return b
	}
	return false
}

func parseTime(v interface{}) time.Time {
	if s, ok := v.(string); ok {
		t, _ := time.Parse("2006-01-02 15:04:05", s)
		return t
	}
	return time.Now()
}

func int64ToStr(i int64) string {
	return string(rune(i))
}
