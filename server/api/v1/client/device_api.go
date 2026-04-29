package client

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// ClientDeviceApi APP设备管理API
type ClientDeviceApi struct{}

// GetAppVersion 获取APP安装包版本
// @Tags      ClientDevice
// @Summary   APP获取安装包版本
// @Produce   application/json
// @Success   200  {object}  response.Response{data=store.InstallingPackage}  "获取成功"
// @Router    /client/code/app [get]
func (a *ClientDeviceApi) GetAppVersion(c *gin.Context) {
	var pkg store.InstallingPackage
	err := global.GVA_DB.Where("installing_id = ?", 1).First(&pkg).Error
	if err != nil {
		global.GVA_LOG.Error("获取APP版本失败", zap.Error(err))
		ClientFailWithMessage("获取失败", c)
		return
	}
	ClientOkWithData(pkg, c)
}

// GetKeyboardVersion 获取键盘安装包版本
// @Tags      ClientDevice
// @Summary   键盘获取安装包版本
// @Produce   application/json
// @Success   200  {object}  response.Response{data=store.InstallingPackage}  "获取成功"
// @Router    /client/code/keyboard [get]
func (a *ClientDeviceApi) GetKeyboardVersion(c *gin.Context) {
	var pkg store.InstallingPackage
	err := global.GVA_DB.Where("installing_id = ?", 2).First(&pkg).Error
	if err != nil {
		global.GVA_LOG.Error("获取键盘版本失败", zap.Error(err))
		ClientFailWithMessage("获取失败", c)
		return
	}
	ClientOkWithData(pkg, c)
}

// GetOptometerVersion 获取验光仪APP安装包版本
// @Tags      ClientDevice
// @Summary   验光仪获取安装包版本
// @Produce   application/json
// @Success   200  {object}  response.Response{data=store.InstallingPackage}  "获取成功"
// @Router    /client/code/app/optometer [get]
func (a *ClientDeviceApi) GetOptometerVersion(c *gin.Context) {
	var pkg store.InstallingPackage
	err := global.GVA_DB.Where("installing_id = ?", 3).First(&pkg).Error
	if err != nil {
		global.GVA_LOG.Error("获取验光仪版本失败", zap.Error(err))
		ClientFailWithMessage("获取失败", c)
		return
	}
	ClientOkWithData(pkg, c)
}

// GetOptometerManualVersion 获取手动验光仪APP安装包版本
// @Tags      ClientDevice
// @Summary   手动验光仪获取安装包版本
// @Produce   application/json
// @Success   200  {object}  response.Response{data=store.InstallingPackage}  "获取成功"
// @Router    /client/code/app/optometer/manual [get]
func (a *ClientDeviceApi) GetOptometerManualVersion(c *gin.Context) {
	var pkg store.InstallingPackage
	err := global.GVA_DB.Where("installing_id = ?", 4).First(&pkg).Error
	if err != nil {
		global.GVA_LOG.Error("获取手动验光仪版本失败", zap.Error(err))
		ClientFailWithMessage("获取失败", c)
		return
	}
	ClientOkWithData(pkg, c)
}

// RegisterDeviceRequest 设备注册请求
type RegisterDeviceRequest struct {
	App            string `json:"app" binding:"required"`
	Equipment      string `json:"equipment" binding:"required"`
	ActivationCode string `json:"activationCode" binding:"required"`
	DeviceName     string `json:"deviceName"`
	DeviceLocation string `json:"deviceLocation"`
}

// RegisterDevice 设备注册/激活
// @Tags      ClientDevice
// @Summary   设备注册激活
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      RegisterDeviceRequest  true  "设备信息"
// @Success   200   {object}  response.Response{data=store.MxActivationCode}  "注册成功"
// @Router    /client/code/equipment [post]
func (a *ClientDeviceApi) RegisterDevice(c *gin.Context) {
	var req RegisterDeviceRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 检查设备是否已存在
	var existing store.MxActivationCode
	err := global.GVA_DB.Where("equipment = ? AND app = ?", req.Equipment, req.App).First(&existing).Error
	if err == nil {
		// 设备已存在，更新信息
		existing.ActivationCode = req.ActivationCode
		if req.DeviceName != "" {
			existing.DeviceName = req.DeviceName
		}
		if req.DeviceLocation != "" {
			existing.DeviceLocation = req.DeviceLocation
		}
		existing.OnlineStatus = 1
		now := common.DateTime{Time: time.Now()}
		existing.LastOnlineTime = &now

		if err := global.GVA_DB.Save(&existing).Error; err != nil {
			global.GVA_LOG.Error("更新设备失败", zap.Error(err))
			ClientFailWithMessage("注册失败", c)
			return
		}
		ClientOkWithData(existing, c)
		return
	}

	// 创建设备记录
	device := store.MxActivationCode{
		App:            req.App,
		Equipment:      req.Equipment,
		ActivationCode: req.ActivationCode,
		DeviceName:     req.DeviceName,
		DeviceLocation: req.DeviceLocation,
		OnlineStatus:   1,
	}
	now := common.DateTime{Time: time.Now()}
	device.LastOnlineTime = &now

	if err := global.GVA_DB.Create(&device).Error; err != nil {
		global.GVA_LOG.Error("创建设备失败", zap.Error(err))
		ClientFailWithMessage("注册失败", c)
		return
	}

	ClientOkWithData(device, c)
}

// UploadErrorLogRequest 上传错误日志请求
type UploadErrorLogRequest struct {
	EquipmentID string `json:"equipmentId" binding:"required"`
	LogContent  string `json:"logContent" binding:"required"`
}

// UploadErrorLog 上传错误日志
// @Tags      ClientDevice
// @Summary   设备上传错误日志
// @Accept    application/json
// @Produce   application/json
// @Param     data  body      UploadErrorLogRequest  true  "日志信息"
// @Success   200   {object}  response.Response{msg=string}  "上传成功"
// @Router    /client/code/upload [post]
func (a *ClientDeviceApi) UploadErrorLog(c *gin.Context) {
	var req UploadErrorLogRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("参数错误: "+err.Error(), c)
		return
	}

	// 保存日志到文件或数据库
	log := store.ErrorReportLog{
		LogId:       uuid.New().String(),
		EquipmentId: req.EquipmentID,
		LogPath:     req.LogContent, // 实际应该保存到文件，这里简化处理
		CreateTime:  time.Now(),
	}

	if err := global.GVA_DB.Create(&log).Error; err != nil {
		global.GVA_LOG.Error("保存错误日志失败", zap.Error(err))
		ClientFailWithMessage("上传失败", c)
		return
	}

	ClientOkWithMessage("上传成功", c)
}
