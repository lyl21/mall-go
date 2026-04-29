package ws

import (
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

// Manager WebSocket管理器（集成新架构）
type Manager struct {
	connectionManager  *ConnectionManager
	sessionManager     *SessionManager
	transactionManager *TransactionManager
	messageRouter      *MessageRouter
	rtcGenerator       *RtcTokenGenerator
	upgrader           websocket.Upgrader
	mu                 sync.RWMutex
}

// NewManager 创建WebSocket管理器
func NewManager() *Manager {
	// 创建连接管理器（心跳超时2分钟，检查间隔30秒）
	cm := NewConnectionManager(120000)

	// 创建会话管理器（token过期5分钟，会话最大存活24小时）
	sm := NewSessionManager(300000, 86400000)

	// 创建事务管理器（超时30秒）
	tm := NewTransactionManager(30000)

	// 创建RTC Token生成器（需要配置声网AppID和证书）
	global.GVA_LOG.Info("检查Agora配置",
		zap.String("appId", global.GVA_CONFIG.Agora.AppId),
		zap.Bool("hasCertificate", global.GVA_CONFIG.Agora.AppCertificate != ""))
	rtcGen := NewRtcTokenGenerator(global.GVA_CONFIG.Agora.AppId, global.GVA_CONFIG.Agora.AppCertificate, 86400)

	// 创建消息处理器（apply超时30秒）
	handlers := NewMessageHandlers(sm, cm, tm, 30000, rtcGen)

	// 创建消息路由器
	router := NewMessageRouter(handlers)

	return &Manager{
		connectionManager:  cm,
		sessionManager:     sm,
		transactionManager: tm,
		messageRouter:      router,
		rtcGenerator:       rtcGen,
		upgrader: websocket.Upgrader{
			ReadBufferSize:  4096,
			WriteBufferSize: 4096,
			CheckOrigin: func(r *http.Request) bool {
				return true // 允许所有来源
			},
		},
	}
}

// HandleWebSocket 处理WebSocket连接
func (m *Manager) HandleWebSocket(w http.ResponseWriter, r *http.Request, userID int64) {
	m.HandleWebSocketWithInfo(w, r, userID, "", "")
}

// HandleWebSocketWithInfo 处理WebSocket连接（带门店信息）
func (m *Manager) HandleWebSocketWithInfo(w http.ResponseWriter, r *http.Request, userID int64, userType, storeId string) {
	conn, err := m.upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket升级失败", zap.Error(err))
		return
	}

	// 添加连接（带门店信息）
	connectionID := m.connectionManager.AddConnectionWithStore(conn, &userID, userType, storeId)

	global.GVA_LOG.Info("WebSocket连接建立",
		zap.String("connectionId", connectionID),
		zap.Int64("userId", userID),
		zap.String("userType", userType),
		zap.String("storeId", storeId))

	// 发送欢迎消息
	welcomeMsg := map[string]interface{}{
		"type":         "welcome",
		"connectionId": connectionID,
		"dateTime":     time.Now().Format("2006-01-02 15:04:05"),
		"message":      "WebSocket连接成功",
	}
	conn.WriteJSON(welcomeMsg)

	// 启动消息读取循环
	m.readLoop(connectionID, conn, userID)
}

// readLoop 消息读取循环
func (m *Manager) readLoop(connectionID string, conn *websocket.Conn, userID int64) {
	defer func() {
		m.connectionManager.DisconnectConnection(connectionID, "连接关闭")
		// 清理会话管理器中的连接
		affectedSessions := m.sessionManager.RemoveConnection(connectionID)
		for _, sessionID := range affectedSessions {
			global.GVA_LOG.Info("清理会话中的连接",
				zap.String("sessionId", sessionID),
				zap.String("connectionId", connectionID))
		}
		m.messageRouter.OnConnectionClosed(connectionID)
		conn.Close()
		global.GVA_LOG.Info("WebSocket连接已清理",
			zap.String("connectionId", connectionID),
			zap.Int64("userId", userID))
	}()

	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			global.GVA_LOG.Info("WebSocket读取消息失败",
				zap.String("connectionId", connectionID),
				zap.Error(err))
			return
		}

		// 更新心跳时间
		m.connectionManager.UpdateHeartbeat(connectionID)

		// 路由消息
		response := m.messageRouter.RouteMessage(connectionID, string(message))

		// 发送响应
		if response != nil {
			msgBytes, err := response.ToJSON()
			if err != nil {
				global.GVA_LOG.Error("序列化响应消息失败", zap.Error(err))
				continue
			}

			if err := conn.WriteMessage(websocket.TextMessage, msgBytes); err != nil {
				global.GVA_LOG.Error("发送WebSocket消息失败", zap.Error(err))
				return
			}
		}
	}
}

// StartHeartbeatCheck 启动心跳检查
func (m *Manager) StartHeartbeatCheck() {
	ticker := time.NewTicker(30 * time.Second)
	go func() {
		defer ticker.Stop()
		for range ticker.C {
			m.connectionManager.CheckHeartbeats()
			m.transactionManager.CheckTimeouts()
		}
	}()
}

// StartSessionCleanup 启动会话清理
func (m *Manager) StartSessionCleanup() {
	ticker := time.NewTicker(5 * time.Minute)
	go func() {
		defer ticker.Stop()
		for range ticker.C {
			m.sessionManager.CleanupExpiredSessions()
		}
	}()
}

// IsUserOnline 检查用户是否在线
func (m *Manager) IsUserOnline(userID int64) bool {
	// 遍历所有连接，查找该用户的在线连接
	// 这里简化实现，实际可以根据业务需求优化
	return false
}

// SendToUser 发送消息给指定用户
func (m *Manager) SendToUser(userID int64, data interface{}) bool {
	// TODO: 实现根据userID查找连接并发送消息
	return false
}

// GetOnlineCount 获取在线连接数
func (m *Manager) GetOnlineCount() int {
	return m.connectionManager.GetConnectionCount()
}

// GetStats 获取统计信息
func (m *Manager) GetStats() map[string]interface{} {
	return m.sessionManager.GetStats()
}

// HandleWebSocketWithStrID 处理WebSocket连接（userID为字符串）
func (m *Manager) HandleWebSocketWithStrID(w http.ResponseWriter, r *http.Request, userIDStr string) {
	m.HandleWebSocketWithStrIDAndInfo(w, r, userIDStr, "", "")
}

// HandleWebSocketWithStrIDAndInfo 处理WebSocket连接（带完整信息）
func (m *Manager) HandleWebSocketWithStrIDAndInfo(w http.ResponseWriter, r *http.Request, userIDStr, userType, storeId string) {
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		global.GVA_LOG.Error("解析userID失败", zap.String("userID", userIDStr), zap.Error(err))
		http.Error(w, "Invalid userID", http.StatusBadRequest)
		return
	}
	m.HandleWebSocketWithInfo(w, r, userID, userType, storeId)
}
