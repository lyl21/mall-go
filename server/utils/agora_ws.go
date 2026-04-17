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
	AgoraWSManager *AgoraWebSocketManager
)

// AgoraWebSocketManager 音视频WebSocket管理器
type AgoraWebSocketManager struct {
	rooms      map[string]*AgoraRoom // roomId -> room
	clients    map[string]*AgoraClient // clientId -> client
	mu         sync.RWMutex
}

// AgoraRoom 音视频房间
type AgoraRoom struct {
	RoomId      string
	ChannelName string
	HostId      string
	Members     map[string]*AgoraClient
	CreatedAt   time.Time
}

// AgoraClient 音视频客户端
type AgoraClient struct {
	Conn       *websocket.Conn
	ClientId   string
	UserId     string
	RoomId     string
	Role       string // host, participant
	LastPing   time.Time
}

// AgoraMessage 音视频消息
type AgoraMessage struct {
	Type      string                 `json:"type"`
	RoomId    string                 `json:"roomId"`
	ClientId  string                 `json:"clientId"`
	UserId    string                 `json:"userId"`
	Data      map[string]interface{} `json:"data"`
}

// AgoraTokenResponse Agora Token响应
type AgoraTokenResponse struct {
	Type      string `json:"type"`
	Channel   string `json:"channel"`
	Token     string `json:"token"`
	Uid       uint32 `json:"uid"`
	AppId     string `json:"appId"`
}

// InitAgoraWSManager 初始化音视频WebSocket管理器
func InitAgoraWSManager() {
	AgoraWSManager = &AgoraWebSocketManager{
		rooms:   make(map[string]*AgoraRoom),
		clients: make(map[string]*AgoraClient),
	}
	// 启动心跳检测
	go AgoraWSManager.heartbeatChecker()
}

// HandleAgoraWS 处理音视频WebSocket连接
func (m *AgoraWebSocketManager) HandleAgoraWS(w http.ResponseWriter, r *http.Request) {
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

	var joinMsg struct {
		Type      string `json:"type"`
		RoomId    string `json:"roomId"`
		UserId    string `json:"userId"`
		ClientId  string `json:"clientId"`
		Role      string `json:"role"`
	}
	if err := json.Unmarshal(message, &joinMsg); err != nil {
		global.GVA_LOG.Error("解析用户信息失败", zap.Error(err))
		conn.Close()
		return
	}

	if joinMsg.Type != "join" {
		conn.Close()
		return
	}

	// 创建或加入房间
	client := &AgoraClient{
		Conn:     conn,
		ClientId: joinMsg.ClientId,
		UserId:   joinMsg.UserId,
		RoomId:   joinMsg.RoomId,
		Role:     joinMsg.Role,
		LastPing: time.Now(),
	}

	m.mu.Lock()
	m.clients[joinMsg.ClientId] = client

	room, exists := m.rooms[joinMsg.RoomId]
	if !exists {
		room = &AgoraRoom{
			RoomId:      joinMsg.RoomId,
			ChannelName: "channel_" + joinMsg.RoomId,
			HostId:      joinMsg.UserId,
			Members:     make(map[string]*AgoraClient),
			CreatedAt:   time.Now(),
		}
		m.rooms[joinMsg.RoomId] = room
	}
	room.Members[joinMsg.ClientId] = client
	m.mu.Unlock()

	global.GVA_LOG.Info("用户加入音视频房间",
		zap.String("roomId", joinMsg.RoomId),
		zap.String("userId", joinMsg.UserId),
		zap.String("role", joinMsg.Role))

	// 通知房间其他成员
	m.broadcastToRoom(joinMsg.RoomId, &AgoraMessage{
		Type:     "userJoined",
		RoomId:   joinMsg.RoomId,
		ClientId: joinMsg.ClientId,
		UserId:   joinMsg.UserId,
		Data: map[string]interface{}{
			"role": joinMsg.Role,
		},
	}, joinMsg.ClientId)

	// 发送当前房间成员列表
	m.sendRoomMembers(client)

	// 处理消息
	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			m.handleDisconnect(client)
			return
		}

		var msg AgoraMessage
		if err := json.Unmarshal(message, &msg); err != nil {
			continue
		}

		// 处理心跳
		if msg.Type == "ping" {
			client.LastPing = time.Now()
			conn.WriteJSON(map[string]string{"type": "pong"})
			continue
		}

		// 处理信令消息
		switch msg.Type {
		case "offer", "answer", "ice-candidate":
			// 转发WebRTC信令
			m.forwardSignal(client, &msg)
		case "leave":
			m.handleDisconnect(client)
			return
		}
	}
}

// 处理断开连接
func (m *AgoraWebSocketManager) handleDisconnect(client *AgoraClient) {
	m.mu.Lock()
	delete(m.clients, client.ClientId)

	room, exists := m.rooms[client.RoomId]
	if exists {
		delete(room.Members, client.ClientId)
		// 如果房间空了，删除房间
		if len(room.Members) == 0 {
			delete(m.rooms, client.RoomId)
		}
	}
	m.mu.Unlock()

	client.Conn.Close()

	global.GVA_LOG.Info("用户离开音视频房间",
		zap.String("roomId", client.RoomId),
		zap.String("userId", client.UserId))

	// 通知房间其他成员
	m.broadcastToRoom(client.RoomId, &AgoraMessage{
		Type:     "userLeft",
		RoomId:   client.RoomId,
		ClientId: client.ClientId,
		UserId:   client.UserId,
	}, client.ClientId)
}

// 转发信令消息
func (m *AgoraWebSocketManager) forwardSignal(from *AgoraClient, msg *AgoraMessage) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	room, exists := m.rooms[from.RoomId]
	if !exists {
		return
	}

	// 转发给目标客户端或广播给房间其他成员
	targetId := msg.Data["targetId"].(string)
	if targetId != "" {
		if targetClient, ok := room.Members[targetId]; ok {
			msg.Data["fromId"] = from.ClientId
			data, _ := json.Marshal(msg)
			targetClient.Conn.WriteMessage(websocket.TextMessage, data)
		}
	} else {
		// 广播给房间其他成员
		for _, member := range room.Members {
			if member.ClientId != from.ClientId {
				msg.Data["fromId"] = from.ClientId
				data, _ := json.Marshal(msg)
				member.Conn.WriteMessage(websocket.TextMessage, data)
			}
		}
	}
}

// 广播消息给房间成员
func (m *AgoraWebSocketManager) broadcastToRoom(roomId string, msg *AgoraMessage, excludeClientId string) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	room, exists := m.rooms[roomId]
	if !exists {
		return
	}

	data, _ := json.Marshal(msg)
	for _, client := range room.Members {
		if client.ClientId != excludeClientId {
			client.Conn.WriteMessage(websocket.TextMessage, data)
		}
	}
}

// 发送房间成员列表给客户端
func (m *AgoraWebSocketManager) sendRoomMembers(client *AgoraClient) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	room, exists := m.rooms[client.RoomId]
	if !exists {
		return
	}

	var members []map[string]string
	for _, member := range room.Members {
		if member.ClientId != client.ClientId {
			members = append(members, map[string]string{
				"clientId": member.ClientId,
				"userId":   member.UserId,
				"role":     member.Role,
			})
		}
	}

	msg := &AgoraMessage{
		Type:     "roomMembers",
		RoomId:   client.RoomId,
		ClientId: client.ClientId,
		Data: map[string]interface{}{
			"members": members,
			"hostId":  room.HostId,
		},
	}
	data, _ := json.Marshal(msg)
	client.Conn.WriteMessage(websocket.TextMessage, data)
}

// 心跳检测
func (m *AgoraWebSocketManager) heartbeatChecker() {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.mu.Lock()
		now := time.Now()
		for clientId, client := range m.clients {
			if now.Sub(client.LastPing) > 2*time.Minute {
				// 超过2分钟没有心跳，断开连接
				client.Conn.Close()
				delete(m.clients, clientId)

				room, exists := m.rooms[client.RoomId]
				if exists {
					delete(room.Members, clientId)
					if len(room.Members) == 0 {
						delete(m.rooms, client.RoomId)
					}
				}

				global.GVA_LOG.Info("音视频客户端心跳超时",
					zap.String("clientId", clientId),
					zap.String("roomId", client.RoomId))
			}
		}
		m.mu.Unlock()
	}
}

// GetRoomInfo 获取房间信息
func (m *AgoraWebSocketManager) GetRoomInfo(roomId string) (map[string]interface{}, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	room, exists := m.rooms[roomId]
	if !exists {
		return nil, false
	}

	var members []map[string]string
	for _, member := range room.Members {
		members = append(members, map[string]string{
			"clientId": member.ClientId,
			"userId":   member.UserId,
			"role":     member.Role,
		})
	}

	return map[string]interface{}{
		"roomId":      room.RoomId,
		"channelName": room.ChannelName,
		"hostId":      room.HostId,
		"memberCount": len(room.Members),
		"members":     members,
		"createdAt":   room.CreatedAt,
	}, true
}

// GetRoomCount 获取房间数量
func (m *AgoraWebSocketManager) GetRoomCount() int {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return len(m.rooms)
}
