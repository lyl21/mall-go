package client

import (
	"strings"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/flipped-aurora/gin-vue-admin/server/utils/upload"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// fillDownloadUrl 补全下载地址协议+主机前缀,避免APP拿到相对路径无法下载
// 数据库存的是相对路径(如uploads/file/xxx.apk),需拼接为完整URL
func fillDownloadUrl(c *gin.Context, pkg *store.InstallingPackage) {
	if pkg.Url != "" && !strings.HasPrefix(pkg.Url, "http") {
		scheme := "http"
		if c.Request.TLS != nil || c.GetHeader("X-Forwarded-Proto") == "https" {
			scheme = "https"
		}
		pkg.Url = scheme + "://" + c.Request.Host + "/" + pkg.Url
	}
}

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
	fillDownloadUrl(c, &pkg)
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
	fillDownloadUrl(c, &pkg)
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
	fillDownloadUrl(c, &pkg)
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
	fillDownloadUrl(c, &pkg)
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

// UploadErrorLog 上传错误日志（与ry原始逻辑一致：文件上传方式）
// @Tags      ClientDevice
// @Summary   设备上传错误日志
// @Accept    multipart/form-data
// @Produce   application/json
// @Param     equipmentID  formData  string                  true  "设备ID"
// @Param     file         formData  file                    true  "日志文件"
// @Success   200          {object}  response.Response{msg=string}  "上传成功"
// @Router    /client/code/upload [post]
func (a *ClientDeviceApi) UploadErrorLog(c *gin.Context) {
	// 与ry原始MxActivationCodeController.uploadFile一致：表单方式接收equipmentID和文件
	equipmentID := c.PostForm("equipmentID")
	file, err := c.FormFile("file")
	if err != nil {
		ClientFailWithMessage("日志文件为空", c)
		return
	}

	// 使用项目统一的文件上传工具保存文件
	oss := upload.NewOss()
	filePath, _, uploadErr := oss.UploadFile(file)
	if uploadErr != nil {
		global.GVA_LOG.Error("上传错误日志文件失败", zap.Error(uploadErr))
		ClientFailWithMessage("上传失败", c)
		return
	}

	// 记录到数据库
	log := store.ErrorReportLog{
		LogId:       uuid.New().String(),
		EquipmentId: equipmentID,
		LogPath:     filePath,
	}

	if err := global.GVA_DB.Create(&log).Error; err != nil {
		global.GVA_LOG.Error("保存错误日志记录失败", zap.Error(err))
		ClientFailWithMessage("上传失败", c)
		return
	}

	ClientOkWithMessage("日志上传成功:"+filePath, c)
}
