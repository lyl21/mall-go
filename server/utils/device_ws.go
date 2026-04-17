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
	Conn       *websocket.Conn
	Equipment  string
	App        string
	LastPing   time.Time
}

// DeviceStatusMessage 设备状态消息
type DeviceStatusMessage struct {
	Type           string `json:"type"`
	Equipment      string `json:"equipment"`
	OnlineStatus   int    `json:"onlineStatus"`
	LastOnlineTime string `json:"lastOnlineTime"`
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

	// 读取第一条消息获取设备信息
	_, message, err := conn.ReadMessage()
	if err != nil {
		global.GVA_LOG.Error("读取设备信息失败", zap.Error(err))
		conn.Close()
		return
	}

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
	client := &DeviceClient{
		Conn:      conn,
		Equipment: deviceInfo.Equipment,
		App:       deviceInfo.App,
		LastPing:  time.Now(), // 初始化为当前时间
	}

	m.mu.Lock()
	// 关闭旧连接
	if oldClient, exists := m.clients[deviceInfo.Equipment]; exists {
		oldClient.Conn.Close()
	}
	m.clients[deviceInfo.Equipment] = client
	m.mu.Unlock()

	// 更新设备在线状态
	m.updateDeviceStatus(deviceInfo.Equipment, 1)

	global.GVA_LOG.Info("设备连接", zap.String("equipment", deviceInfo.Equipment))

	// 广播设备上线消息
	m.broadcastToAdmin(&DeviceStatusMessage{
		Type:           "deviceStatus",
		Equipment:      deviceInfo.Equipment,
		OnlineStatus:   1,
		LastOnlineTime: time.Now().Format("2006-01-02 15:04:05"),
	})

	// 处理消息
	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.mu.Lock()
			delete(m.clients, deviceInfo.Equipment)
			m.mu.Unlock()
			conn.Close()
			// 更新设备离线状态
			m.updateDeviceStatus(deviceInfo.Equipment, 0)
			global.GVA_LOG.Info("设备断开", zap.String("equipment", deviceInfo.Equipment))
			// 广播设备离线消息
			m.broadcastToAdmin(&DeviceStatusMessage{
				Type:           "deviceStatus",
				Equipment:      deviceInfo.Equipment,
				OnlineStatus:   0,
				LastOnlineTime: time.Now().Format("2006-01-02 15:04:05"),
			})
			return
		}

		// 处理心跳消息
		var msg struct {
			Type string `json:"type"`
		}
		if err := json.Unmarshal(message, &msg); err == nil && msg.Type == "ping" {
			client.LastPing = time.Now()
			conn.WriteJSON(map[string]string{"type": "pong"})
		}
	}
}

// 更新设备在线状态到数据库
func (m *DeviceWebSocketManager) updateDeviceStatus(equipment string, status int) {
	now := common.DateTime{Time: time.Now()}
	updateData := map[string]interface{}{
		"online_status":    status,
		"last_online_time": &now,
	}
	if err := global.GVA_DB.Model(&store.MxActivationCode{}).Where("equipment = ?", equipment).Updates(updateData).Error; err != nil {
		global.GVA_LOG.Error("更新设备状态失败", zap.Error(err))
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

// 心跳检测
func (m *DeviceWebSocketManager) heartbeatChecker() {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.mu.Lock()
		now := time.Now()
		for equipment, client := range m.clients {
			if now.Sub(client.LastPing) > 2*time.Minute {
				// 超过2分钟没有心跳，认为离线
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
