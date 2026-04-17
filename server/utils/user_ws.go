package utils

import (
	"encoding/json"
	"net/http"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

var (
	UserWSManager *UserWebSocketManager
)

// UserWebSocketManager 用户WebSocket管理器
type UserWebSocketManager struct {
	clients    map[string]*UserClient // userId -> client
	adminConns map[*websocket.Conn]bool // 后台管理连接
	mu         sync.RWMutex
}

// UserClient 用户客户端连接
type UserClient struct {
	Conn     *websocket.Conn
	UserId   string
	UserType string // customer, optometrist, manager
	StoreId  string
	LastPing time.Time
}

// UserStatusMessage 用户状态消息
type UserStatusMessage struct {
	Type         string `json:"type"`
	UserId       string `json:"userId"`
	UserType     string `json:"userType"`
	StoreId      string `json:"storeId"`
	OnlineStatus int    `json:"onlineStatus"` // 1在线 0离线
}

// RemoteControlMessage 远程控制消息
type RemoteControlMessage struct {
	Type      string `json:"type"`      // remoteControl
	Action    string `json:"action"`    // openDoor, startOptometry, etc.
	TargetId  string `json:"targetId"`  // 目标设备/用户ID
	SourceId  string `json:"sourceId"`  // 发起者ID
	Data      map[string]interface{} `json:"data"`
}

// InitUserWSManager 初始化用户WebSocket管理器
func InitUserWSManager() {
	UserWSManager = &UserWebSocketManager{
		clients:    make(map[string]*UserClient),
		adminConns: make(map[*websocket.Conn]bool),
	}
	// 启动心跳检测
	go UserWSManager.heartbeatChecker()
}

// HandleUserWS 处理用户WebSocket连接
func (m *UserWebSocketManager) HandleUserWS(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket升级失败", zap.Error(err))
		return
	}

	// 读取第一条消息获取用户信息
	_, message, err := conn.ReadMessage()
	if err != nil {
		global.GVA_LOG.Error("读取用户信息失败", zap.Error(err))
		conn.Close()
		return
	}

	var userInfo struct {
		UserId   string `json:"userId"`
		UserType string `json:"userType"`
		StoreId  string `json:"storeId"`
		Type     string `json:"type"`
	}
	if err := json.Unmarshal(message, &userInfo); err != nil {
		global.GVA_LOG.Error("解析用户信息失败", zap.Error(err))
		conn.Close()
		return
	}

	// 如果是后台管理连接
	if userInfo.Type == "admin" {
		m.mu.Lock()
		m.adminConns[conn] = true
		m.mu.Unlock()

		// 发送当前所有用户状态
		m.sendAllUserStatus(conn)

		// 保持连接
		for {
			_, message, err := conn.ReadMessage()
			if err != nil {
				m.mu.Lock()
				delete(m.adminConns, conn)
				m.mu.Unlock()
				conn.Close()
				return
			}

			// 处理远程控制命令
			var cmd RemoteControlMessage
			if err := json.Unmarshal(message, &cmd); err == nil && cmd.Type == "remoteControl" {
				m.handleRemoteControl(&cmd)
			}
		}
	}

	// 用户连接
	client := &UserClient{
		Conn:     conn,
		UserId:   userInfo.UserId,
		UserType: userInfo.UserType,
		StoreId:  userInfo.StoreId,
		LastPing: time.Now(),
	}

	m.mu.Lock()
	// 关闭旧连接
	if oldClient, exists := m.clients[userInfo.UserId]; exists {
		oldClient.Conn.Close()
	}
	m.clients[userInfo.UserId] = client
	m.mu.Unlock()

	global.GVA_LOG.Info("用户连接", zap.String("userId", userInfo.UserId), zap.String("userType", userInfo.UserType))

	// 广播用户上线消息
	m.broadcastToAdmin(&UserStatusMessage{
		Type:         "userStatus",
		UserId:       userInfo.UserId,
		UserType:     userInfo.UserType,
		StoreId:      userInfo.StoreId,
		OnlineStatus: 1,
	})

	// 处理消息
	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.mu.Lock()
			delete(m.clients, userInfo.UserId)
			m.mu.Unlock()
			conn.Close()
			global.GVA_LOG.Info("用户断开", zap.String("userId", userInfo.UserId))
			// 广播用户离线消息
			m.broadcastToAdmin(&UserStatusMessage{
				Type:         "userStatus",
				UserId:       userInfo.UserId,
				UserType:     userInfo.UserType,
				StoreId:      userInfo.StoreId,
				OnlineStatus: 0,
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

		// 处理远程控制响应
		var resp RemoteControlMessage
		if err := json.Unmarshal(message, &resp); err == nil && resp.Type == "remoteControlResponse" {
			m.handleRemoteControlResponse(&resp)
		}
	}
}

// 处理远程控制命令
func (m *UserWebSocketManager) handleRemoteControl(cmd *RemoteControlMessage) {
	m.mu.RLock()
	targetClient, exists := m.clients[cmd.TargetId]
	m.mu.RUnlock()

	if !exists {
		global.GVA_LOG.Warn("远程控制目标不在线", zap.String("targetId", cmd.TargetId))
		// 通知发起者目标不在线
		m.sendToUser(cmd.SourceId, map[string]interface{}{
			"type":   "remoteControlResponse",
			"action": cmd.Action,
			"status": "offline",
			"msg":    "目标用户不在线",
		})
		return
	}

	// 转发命令给目标
	data, _ := json.Marshal(cmd)
	if err := targetClient.Conn.WriteMessage(websocket.TextMessage, data); err != nil {
		global.GVA_LOG.Error("发送远程控制命令失败", zap.Error(err))
	}
}

// 处理远程控制响应
func (m *UserWebSocketManager) handleRemoteControlResponse(resp *RemoteControlMessage) {
	// 转发响应给发起者
	m.sendToUser(resp.SourceId, resp)
}

// SendToUser 发送消息给指定用户（公开方法）
func (m *UserWebSocketManager) SendToUser(userId string, data interface{}) bool {
	return m.sendToUser(userId, data)
}

// 发送消息给指定用户
func (m *UserWebSocketManager) sendToUser(userId string, data interface{}) bool {
	m.mu.RLock()
	client, exists := m.clients[userId]
	m.mu.RUnlock()

	if !exists {
		return false
	}

	msg, _ := json.Marshal(data)
	if err := client.Conn.WriteMessage(websocket.TextMessage, msg); err != nil {
		global.GVA_LOG.Error("发送消息给用户失败", zap.Error(err))
		return false
	}
	return true
}

// 广播消息给所有后台管理连接
func (m *UserWebSocketManager) broadcastToAdmin(msg *UserStatusMessage) {
	data, _ := json.Marshal(msg)
	m.mu.RLock()
	defer m.mu.RUnlock()
	for conn := range m.adminConns {
		if err := conn.WriteMessage(websocket.TextMessage, data); err != nil {
			global.GVA_LOG.Error("发送消息失败", zap.Error(err))
		}
	}
}

// 发送所有用户状态给新连接的管理端
func (m *UserWebSocketManager) sendAllUserStatus(conn *websocket.Conn) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, client := range m.clients {
		msg := &UserStatusMessage{
			Type:         "userStatus",
			UserId:       client.UserId,
			UserType:     client.UserType,
			StoreId:      client.StoreId,
			OnlineStatus: 1,
		}
		data, _ := json.Marshal(msg)
		conn.WriteMessage(websocket.TextMessage, data)
	}
}

// 心跳检测
func (m *UserWebSocketManager) heartbeatChecker() {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.mu.Lock()
		now := time.Now()
		for userId, client := range m.clients {
			if now.Sub(client.LastPing) > 2*time.Minute {
				// 超过2分钟没有心跳，认为离线
				client.Conn.Close()
				delete(m.clients, userId)
				global.GVA_LOG.Info("用户心跳超时", zap.String("userId", userId))
				m.broadcastToAdmin(&UserStatusMessage{
					Type:         "userStatus",
					UserId:       client.UserId,
					UserType:     client.UserType,
					StoreId:      client.StoreId,
					OnlineStatus: 0,
				})
			}
		}
		m.mu.Unlock()
	}
}

// GetOnlineUsers 获取在线用户列表
func (m *UserWebSocketManager) GetOnlineUsers() []map[string]string {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var users []map[string]string
	for _, client := range m.clients {
		users = append(users, map[string]string{
			"userId":   client.UserId,
			"userType": client.UserType,
			"storeId":  client.StoreId,
		})
	}
	return users
}

// IsUserOnline 检查用户是否在线
func (m *UserWebSocketManager) IsUserOnline(userId string) bool {
	m.mu.RLock()
	defer m.mu.RUnlock()
	_, exists := m.clients[userId]
	return exists
}
