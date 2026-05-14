package utils

import (
	"encoding/json"
	"net/http"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

var (
	DeviceWSManager *DeviceWebSocketManager
	upgrader        = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}
)

// DeviceWebSocketManager 设备WebSocket管理器
type DeviceWebSocketManager struct {
	clients    map[string]*DeviceClient // equipment -> client
	adminConns map[*websocket.Conn]bool // 后台管理连接
	mu         sync.RWMutex
}

// DeviceClient 设备客户端连接
type DeviceClient struct {
	Conn      *websocket.Conn
	Equipment string
	App       string
	LastPing  time.Time
}

// DeviceStatusMessage 设备状态消息
type DeviceStatusMessage struct {
	Type           string `json:"type"`
	Equipment      string `json:"equipment"`
	OnlineStatus   int    `json:"onlineStatus"`
	LastOnlineTime string `json:"lastOnlineTime"`
	IpAddress      string `json:"ipAddress"`
	IpLocation     string `json:"ipLocation"`
}

// InitDeviceWSManager 初始化设备WebSocket管理器
func InitDeviceWSManager() {
	DeviceWSManager = &DeviceWebSocketManager{
		clients:    make(map[string]*DeviceClient),
		adminConns: make(map[*websocket.Conn]bool),
	}
	// 启动心跳检测
	go DeviceWSManager.heartbeatChecker()
}

// HandleDeviceWS 处理设备WebSocket连接
func (m *DeviceWebSocketManager) HandleDeviceWS(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket升级失败", zap.Error(err))
		return
	}

	// 读取第一条消息获取设备信息（设置5秒超时，避免客户端连而不发的僵尸连接）
	conn.SetReadDeadline(time.Now().Add(5 * time.Second))
	_, message, err := conn.ReadMessage()
	if err != nil {
		// close 1001/1005 是浏览器正常关闭，用 Warn 级别；其他异常用 Error
		if websocket.IsCloseError(err, websocket.CloseGoingAway, websocket.CloseNoStatusReceived) {
			global.GVA_LOG.Warn("客户端在发送设备信息前断开", zap.Error(err))
		} else {
			global.GVA_LOG.Error("读取设备信息失败", zap.Error(err))
		}
		conn.Close()
		return
	}
	// 清除读超时，后续由消息循环自己控制
	conn.SetReadDeadline(time.Time{})

	var deviceInfo struct {
		Equipment string `json:"equipment"`
		App       string `json:"app"`
		Type      string `json:"type"`
	}
	if err := json.Unmarshal(message, &deviceInfo); err != nil {
		global.GVA_LOG.Error("解析设备信息失败", zap.Error(err))
		conn.Close()
		return
	}

	// 如果是后台管理连接
	if deviceInfo.Type == "admin" {
		m.mu.Lock()
		m.adminConns[conn] = true
		m.mu.Unlock()

		// 发送当前所有设备状态
		m.sendAllDeviceStatus(conn)

		// 保持连接
		for {
			_, _, err := conn.ReadMessage()
			if err != nil {
				m.mu.Lock()
				delete(m.adminConns, conn)
				m.mu.Unlock()
				conn.Close()
				return
			}
		}
	}

	// 设备连接
	clientIP := GetClientIP(r)
	client := &DeviceClient{
		Conn:      conn,
		Equipment: deviceInfo.Equipment,
		App:       deviceInfo.App,
		LastPing:  time.Now(),
	}

	// 处理 WebSocket 协议层 ping
	conn.SetPingHandler(func(data string) error {
		client.LastPing = time.Now()
		conn.SetWriteDeadline(time.Now().Add(5 * time.Second))
		err := conn.WriteMessage(websocket.PongMessage, []byte(data))
		conn.SetWriteDeadline(time.Time{})
		return err
	})

	m.mu.Lock()
	if oldClient, exists := m.clients[deviceInfo.Equipment]; exists {
		oldClient.Conn.Close()
	}
	m.clients[deviceInfo.Equipment] = client
	m.mu.Unlock()

	m.updateDeviceStatus(deviceInfo.Equipment, 1)
	go UpdateDeviceIPAndLocation(deviceInfo.Equipment, clientIP)

	location := IPToLocation(clientIP)
	global.GVA_LOG.Info("设备连接", zap.String("equipment", deviceInfo.Equipment), zap.String("ip", clientIP))

	m.broadcastToAdmin(&DeviceStatusMessage{
		Type:           "deviceStatus",
		Equipment:      deviceInfo.Equipment,
		OnlineStatus:   1,
		LastOnlineTime: time.Now().Format("2006-01-02 15:04:05"),
		IpAddress:      clientIP,
		IpLocation:     location,
	})

	for {
		conn.SetReadDeadline(time.Now().Add(10 * time.Second))
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.handleDeviceDisconnect(deviceInfo.Equipment, "断开")
			return
		}
		var msg struct {
			Type string `json:"type"`
		}
		if err := json.Unmarshal(message, &msg); err == nil && msg.Type == "ping" {
			client.LastPing = time.Now()
			conn.SetWriteDeadline(time.Now().Add(5 * time.Second))
			conn.WriteJSON(map[string]string{"type": "pong"})
			conn.SetWriteDeadline(time.Time{})
		} else {
			client.LastPing = time.Now()
		}
	}
}

// 更新设备在线状态到数据库
func (m *DeviceWebSocketManager) updateDeviceStatus(equipment string, status int) {
	SyncDeviceStatus(equipment, status)
}

// SyncDeviceStatus 公开的设备状态同步（供外部调用，如牛头APP用户WS）
func SyncDeviceStatus(equipment string, status int) {
	now := common.DateTime{Time: time.Now()}
	updateData := map[string]interface{}{
		"online_status":    status,
		"last_online_time": &now,
	}
	if err := global.GVA_DB.Model(&store.MxActivationCode{}).Where("equipment = ?", equipment).Updates(updateData).Error; err != nil {
		global.GVA_LOG.Error("更新设备状态失败", zap.Error(err))
	}
}

// EnsureDeviceRecord 确保设备记录存在（牛头APP用户首次连接时创建）
func EnsureDeviceRecord(equipment string, app string, deviceName string) {
	var count int64
	global.GVA_DB.Model(&store.MxActivationCode{}).Where("equipment = ? AND app = ?", equipment, app).Count(&count)
	if count == 0 {
		now := common.DateTime{Time: time.Now()}
		record := store.MxActivationCode{
			Equipment:      equipment,
			App:            app,
			DeviceName:     deviceName,
			OnlineStatus:   1,
			LastOnlineTime: &now,
		}
		global.GVA_DB.Create(&record)
	}
}

// 广播消息给所有后台管理连接
func (m *DeviceWebSocketManager) broadcastToAdmin(msg *DeviceStatusMessage) {
	data, _ := json.Marshal(msg)
	m.mu.RLock()
	defer m.mu.RUnlock()
	for conn := range m.adminConns {
		if err := conn.WriteMessage(websocket.TextMessage, data); err != nil {
			global.GVA_LOG.Error("发送消息失败", zap.Error(err))
		}
	}
}

// 发送所有设备状态给新连接的管理端
func (m *DeviceWebSocketManager) sendAllDeviceStatus(conn *websocket.Conn) {
	var devices []store.MxActivationCode
	if err := global.GVA_DB.Find(&devices).Error; err != nil {
		global.GVA_LOG.Error("获取设备列表失败", zap.Error(err))
		return
	}

	for _, device := range devices {
		lastOnlineTime := ""
		if device.LastOnlineTime != nil {
			lastOnlineTime = device.LastOnlineTime.Format("2006-01-02 15:04:05")
		}
		msg := &DeviceStatusMessage{
			Type:           "deviceStatus",
			Equipment:      device.Equipment,
			OnlineStatus:   device.OnlineStatus,
			LastOnlineTime: lastOnlineTime,
			IpAddress:      device.IpAddress,
			IpLocation:     device.IpLocation,
		}
		data, _ := json.Marshal(msg)
		conn.WriteMessage(websocket.TextMessage, data)
	}
}

// SendToDevice 发送消息给指定设备
func (m *DeviceWebSocketManager) SendToDevice(equipment string, data interface{}) bool {
	m.mu.RLock()
	client, exists := m.clients[equipment]
	m.mu.RUnlock()

	if !exists {
		return false
	}

	msg, _ := json.Marshal(data)
	if err := client.Conn.WriteMessage(websocket.TextMessage, msg); err != nil {
		global.GVA_LOG.Error("发送消息给设备失败", zap.Error(err))
		return false
	}
	return true
}

// IsDeviceOnline 检查设备是否在线
func (m *DeviceWebSocketManager) IsDeviceOnline(equipment string) bool {
	m.mu.RLock()
	defer m.mu.RUnlock()
	_, exists := m.clients[equipment]
	return exists
}

// GetOnlineDevices 获取在线设备列表
func (m *DeviceWebSocketManager) GetOnlineDevices() []string {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var devices []string
	for equipment := range m.clients {
		devices = append(devices, equipment)
	}
	return devices
}

// HandleDeviceWSByPath 处理设备WebSocket连接（从URL路径获取设备ID和app）
func (m *DeviceWebSocketManager) HandleDeviceWSByPath(w http.ResponseWriter, r *http.Request, equipment string, app string) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket升级失败", zap.Error(err))
		return
	}

	clientIP := GetClientIP(r)

	if app == "" {
		app = r.URL.Query().Get("app")
	}
	if app == "" {
		var device store.MxActivationCode
		if err := global.GVA_DB.Where("equipment = ?", equipment).First(&device).Error; err == nil && device.App != "" {
			app = device.App
		}
	}
	if app == "" {
		app = "未知设备"
	}

	client := &DeviceClient{
		Conn:      conn,
		Equipment: equipment,
		App:       app,
		LastPing:  time.Now(),
	}

	// 处理 WebSocket 协议层 ping：自动回复 pong 并刷新心跳
	conn.SetPingHandler(func(data string) error {
		client.LastPing = time.Now()
		conn.SetWriteDeadline(time.Now().Add(5 * time.Second))
		err := conn.WriteMessage(websocket.PongMessage, []byte(data))
		conn.SetWriteDeadline(time.Time{})
		return err
	})

	m.mu.Lock()
	if oldClient, exists := m.clients[equipment]; exists {
		oldClient.Conn.Close()
	}
	m.clients[equipment] = client
	m.mu.Unlock()

	m.updateDeviceStatus(equipment, 1)
	go UpdateDeviceIPAndLocation(equipment, clientIP)

	location := IPToLocation(clientIP)
	global.GVA_LOG.Info("设备连接(路径)", zap.String("equipment", equipment), zap.String("app", app), zap.String("ip", clientIP))

	m.broadcastToAdmin(&DeviceStatusMessage{
		Type:           "deviceStatus",
		Equipment:      equipment,
		OnlineStatus:   1,
		LastOnlineTime: time.Now().Format("2006-01-02 15:04:05"),
		IpAddress:      clientIP,
		IpLocation:     location,
	})

	// 消息循环：ReadDeadline 10s，断网时快速感知
	for {
		conn.SetReadDeadline(time.Now().Add(10 * time.Second))
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.handleDeviceDisconnect(equipment, "断开(路径)")
			return
		}
		var msg struct {
			Type string `json:"type"`
		}
		if err := json.Unmarshal(message, &msg); err == nil && msg.Type == "ping" {
			client.LastPing = time.Now()
			conn.SetWriteDeadline(time.Now().Add(5 * time.Second))
			conn.WriteJSON(map[string]string{"type": "pong"})
			conn.SetWriteDeadline(time.Time{})
		} else {
			// 任何消息都视为心跳
			client.LastPing = time.Now()
		}
	}
}

// handleDeviceDisconnect 统一处理设备断开
func (m *DeviceWebSocketManager) handleDeviceDisconnect(equipment string, reason string) {
	m.mu.Lock()
	delete(m.clients, equipment)
	m.mu.Unlock()
	m.updateDeviceStatus(equipment, 0)
	global.GVA_LOG.Info("设备"+reason, zap.String("equipment", equipment))
	m.broadcastToAdmin(&DeviceStatusMessage{
		Type:           "deviceStatus",
		Equipment:      equipment,
		OnlineStatus:   0,
		LastOnlineTime: time.Now().Format("2006-01-02 15:04:05"),
	})
}

// 心跳检测（兜底，ReadDeadline 正常情况下 10s 内就能检测断线）
func (m *DeviceWebSocketManager) heartbeatChecker() {
	ticker := time.NewTicker(20 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.mu.Lock()
		now := time.Now()
		for equipment, client := range m.clients {
			if now.Sub(client.LastPing) > 30*time.Second {
				client.Conn.Close()
				delete(m.clients, equipment)
				m.updateDeviceStatus(equipment, 0)
				global.GVA_LOG.Info("设备心跳超时", zap.String("equipment", equipment))
				m.broadcastToAdmin(&DeviceStatusMessage{
					Type:           "deviceStatus",
					Equipment:      equipment,
					OnlineStatus:   0,
					LastOnlineTime: now.Format("2006-01-02 15:04:05"),
				})
			}
		}
		m.mu.Unlock()
	}
}
