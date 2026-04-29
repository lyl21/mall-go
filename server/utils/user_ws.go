package utils

import (
	"encoding/json"
	"fmt"
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

// HandleUserWS 处理用户WebSocket连接（旧版，需要客户端发送JSON消息）
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

	m.registerUserConnection(conn, userInfo.UserId, userInfo.UserType, userInfo.StoreId, userInfo.Type == "admin")
}

// HandleUserWSWithId 处理用户WebSocket连接（从URL路径获取userId，兼容Java服务）
func (m *UserWebSocketManager) HandleUserWSWithId(w http.ResponseWriter, r *http.Request, userId string) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket升级失败", zap.Error(err))
		return
	}

	global.GVA_LOG.Info("WebSocket连接请求",
		zap.String("userId", userId),
		zap.String("remoteAddr", r.RemoteAddr),
		zap.String("userAgent", r.UserAgent()))

	m.registerUserConnection(conn, userId, "", "", false)
}

// registerUserConnection 注册用户WebSocket连接
func (m *UserWebSocketManager) registerUserConnection(conn *websocket.Conn, userId string, userType string, storeId string, isAdmin bool) {
	if userId == "" {
		global.GVA_LOG.Error("用户ID为空")
		conn.Close()
		return
	}

	// 如果是后台管理连接
	if isAdmin {
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
		UserId:   userId,
		UserType: userType,
		StoreId:  storeId,
		LastPing: time.Now(),
	}

	m.mu.Lock()
	// 关闭旧连接
	if oldClient, exists := m.clients[userId]; exists {
		oldClient.Conn.Close()
	}
	m.clients[userId] = client
	m.mu.Unlock()

	global.GVA_LOG.Info("用户连接", zap.String("userId", userId), zap.String("userType", userType))

	// 广播用户上线消息
	m.broadcastToAdmin(&UserStatusMessage{
		Type:         "userStatus",
		UserId:       userId,
		UserType:     userType,
		StoreId:      storeId,
		OnlineStatus: 1,
	})

	// 处理消息
	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.mu.Lock()
			delete(m.clients, userId)
			m.mu.Unlock()
			conn.Close()
			global.GVA_LOG.Info("用户断开", zap.String("userId", userId))
			// 广播用户离线消息
			m.broadcastToAdmin(&UserStatusMessage{
				Type:         "userStatus",
				UserId:       userId,
				UserType:     userType,
				StoreId:      storeId,
				OnlineStatus: 0,
			})
			return
		}

		// 处理心跳消息（牛头app心跳）
		var msg map[string]interface{}
		if err := json.Unmarshal(message, &msg); err == nil {
			// 牛头APP心跳: {"cmd":"heartbeat","data":{"timestamp":...}}
			if cmd, ok := msg["cmd"].(string); ok && cmd == "heartbeat" {
				global.GVA_LOG.Info("收到牛头APP心跳", zap.String("userId", userId))
				client.LastPing = time.Now()
				// 原样返回心跳消息
				conn.WriteMessage(websocket.TextMessage, message)
				continue
			}
			// 旧版心跳: {"req": "niutou"}
			if req, ok := msg["req"].(string); ok && req == "niutou" {
				global.GVA_LOG.Info("收到牛头APP心跳(旧版)", zap.String("userId", userId))
				conn.WriteMessage(websocket.TextMessage, message)
				client.LastPing = time.Now()
				continue
			}
			// 标准ping: {"type": "ping"}
			if msgType, ok := msg["type"].(string); ok && msgType == "ping" {
				global.GVA_LOG.Info("收到ping心跳", zap.String("userId", userId))
				client.LastPing = time.Now()
				conn.WriteJSON(map[string]string{"type": "pong"})
				continue
			}
			// 远控请求: {"cmd":"control_request",...}
			if cmd, ok := msg["cmd"].(string); ok && cmd == "control_request" {
				global.GVA_LOG.Info("收到远控请求", zap.String("userId", userId), zap.Any("msg", msg))
				// 转发给目标用户
				if data, ok := msg["data"].(map[string]interface{}); ok {
					if targetUserId, ok := data["userId"].(float64); ok {
						targetId := fmt.Sprintf("%.0f", targetUserId)
						global.GVA_LOG.Info("转发远控请求", zap.String("from", userId), zap.String("to", targetId))
						m.sendToUser(targetId, msg)
					}
				}
				continue
			}
			// 远控响应: {"cmd":"control_response",...}
			if cmd, ok := msg["cmd"].(string); ok && cmd == "control_response" {
				global.GVA_LOG.Info("收到远控响应", zap.String("userId", userId))
				// 转发给发起者
				if data, ok := msg["data"].(map[string]interface{}); ok {
					if targetUserId, ok := data["userId"].(float64); ok {
						targetId := fmt.Sprintf("%.0f", targetUserId)
						global.GVA_LOG.Info("转发远控响应", zap.String("from", userId), zap.String("to", targetId))
						m.sendToUser(targetId, msg)
					}
				}
				continue
			}
			// 退出通知: {"cmd":"remote_customer_exit"} 或 {"cmd":"remote_optometrist_exit"}
			if cmd, ok := msg["cmd"].(string); ok && (cmd == "remote_customer_exit" || cmd == "remote_optometrist_exit") {
				global.GVA_LOG.Info("收到退出通知", zap.String("userId", userId), zap.String("cmd", cmd))
				// 广播给所有在线用户
				m.broadcastExit(cmd)
				continue
			}
			// 调试：打印未知消息
			global.GVA_LOG.Info("收到未知消息", zap.String("userId", userId), zap.Any("msg", msg))
		} else {
			// 非JSON消息
			global.GVA_LOG.Info("收到非JSON消息", zap.String("userId", userId), zap.String("message", string(message)))
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

// broadcastExit 广播退出消息给所有在线用户
func (m *UserWebSocketManager) broadcastExit(cmd string) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	msg := map[string]interface{}{
		"cmd":  cmd,
		"resp": "1",
	}
	data, _ := json.Marshal(msg)

	for _, client := range m.clients {
		if client.Conn != nil {
			client.Conn.WriteMessage(websocket.TextMessage, data)
		}
	}
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
