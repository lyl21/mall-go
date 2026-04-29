package ws

import (
	"net"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

// ConnectionInfo WebSocket连接信息
type ConnectionInfo struct {
	ConnectionID      string
	SessionID         *string
	Role              *ClientRole
	Conn              *websocket.Conn
	LastHeartbeatTime int64
	IsConnected       bool
	UserID            *int64
	UserType          string // customer, optometrist, manager
	StoreId           string // 门店ID，用于门店隔离
	mu                sync.RWMutex
}

// IsHeartbeatTimeout 检查心跳是否超时
func (c *ConnectionInfo) IsHeartbeatTimeout(timeoutMs int64) bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return time.Now().UnixMilli()-c.LastHeartbeatTime > timeoutMs
}

// UpdateHeartbeat 更新心跳时间
func (c *ConnectionInfo) UpdateHeartbeat() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.LastHeartbeatTime = time.Now().UnixMilli()
}

// ConnectionManager 连接管理器
type ConnectionManager struct {
	connections        map[string]*ConnectionInfo
	sessionConnections map[string]map[string]bool
	mu                 sync.RWMutex
	heartbeatTimeoutMs int64
}

// NewConnectionManager 创建连接管理器
func NewConnectionManager(heartbeatTimeoutMs int64) *ConnectionManager {
	return &ConnectionManager{
		connections:        make(map[string]*ConnectionInfo),
		sessionConnections: make(map[string]map[string]bool),
		heartbeatTimeoutMs: heartbeatTimeoutMs,
	}
}

// generateConnectionID 生成连接ID
func (cm *ConnectionManager) generateConnectionID() string {
	return "conn_" + time.Now().Format("20060102150405") + "_" + RandomString(8)
}

// RandomString 生成随机字符串
func RandomString(length int) string {
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	result := make([]byte, length)
	for i := range result {
		result[i] = chars[time.Now().UnixNano()%int64(len(chars))]
		time.Sleep(time.Nanosecond)
	}
	return string(result)
}

// AddConnection 添加新连接
func (cm *ConnectionManager) AddConnection(conn *websocket.Conn, userID *int64) string {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionID := cm.generateConnectionID()
	connectionInfo := &ConnectionInfo{
		ConnectionID:      connectionID,
		Conn:              conn,
		LastHeartbeatTime: time.Now().UnixMilli(),
		IsConnected:       true,
		UserID:            userID,
	}

	cm.connections[connectionID] = connectionInfo

	remoteAddr := ""
	if addr, ok := conn.RemoteAddr().(*net.TCPAddr); ok {
		remoteAddr = addr.String()
	} else {
		remoteAddr = conn.RemoteAddr().String()
	}

	global.GVA_LOG.Info("添加WebSocket连接",
		zap.String("connectionId", connectionID),
		zap.Int64("userId", *userID),
		zap.String("remoteAddress", remoteAddr))

	return connectionID
}

// AddConnectionWithStore 添加新连接（带门店信息）
func (cm *ConnectionManager) AddConnectionWithStore(conn *websocket.Conn, userID *int64, userType, storeId string) string {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionID := cm.generateConnectionID()
	connectionInfo := &ConnectionInfo{
		ConnectionID:      connectionID,
		Conn:              conn,
		LastHeartbeatTime: time.Now().UnixMilli(),
		IsConnected:       true,
		UserID:            userID,
		UserType:          userType,
		StoreId:           storeId,
	}

	cm.connections[connectionID] = connectionInfo

	remoteAddr := ""
	if addr, ok := conn.RemoteAddr().(*net.TCPAddr); ok {
		remoteAddr = addr.String()
	} else {
		remoteAddr = conn.RemoteAddr().String()
	}

	global.GVA_LOG.Info("添加WebSocket连接（带门店信息）",
		zap.String("connectionId", connectionID),
		zap.Int64("userId", *userID),
		zap.String("userType", userType),
		zap.String("storeId", storeId),
		zap.String("remoteAddress", remoteAddr))

	return connectionID
}

// BindToSession 绑定连接到会话
func (cm *ConnectionManager) BindToSession(connectionID string, sessionID string, role ClientRole) {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionInfo, ok := cm.connections[connectionID]
	if !ok {
		global.GVA_LOG.Warn("连接未找到", zap.String("connectionId", connectionID))
		return
	}

	// 如果之前绑定了其他会话，先从旧会话中移除
	if connectionInfo.SessionID != nil && *connectionInfo.SessionID != sessionID {
		oldSessionID := *connectionInfo.SessionID
		if conns, ok := cm.sessionConnections[oldSessionID]; ok {
			delete(conns, connectionID)
			if len(conns) == 0 {
				delete(cm.sessionConnections, oldSessionID)
			}
		}
		global.GVA_LOG.Info("从旧会话移除连接",
			zap.String("connectionId", connectionID),
			zap.String("oldSessionId", oldSessionID))
	}

	// 更新连接信息
	connectionInfo.mu.Lock()
	connectionInfo.SessionID = &sessionID
	connectionInfo.Role = &role
	connectionInfo.mu.Unlock()

	// 添加到会话连接集合
	if _, ok := cm.sessionConnections[sessionID]; !ok {
		cm.sessionConnections[sessionID] = make(map[string]bool)
	}
	cm.sessionConnections[sessionID][connectionID] = true

	global.GVA_LOG.Info("绑定连接到会话",
		zap.String("connectionId", connectionID),
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)))
}

// UnbindFromSession 解除连接与会话的绑定
func (cm *ConnectionManager) UnbindFromSession(connectionID string) {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionInfo, ok := cm.connections[connectionID]
	if !ok {
		global.GVA_LOG.Warn("连接未找到", zap.String("connectionId", connectionID))
		return
	}

	connectionInfo.mu.RLock()
	oldSessionID := connectionInfo.SessionID
	connectionInfo.mu.RUnlock()

	// 清除连接的会话信息（但保留 role，以便查找可用主控端）
	connectionInfo.mu.Lock()
	connectionInfo.SessionID = nil
	connectionInfo.mu.Unlock()

	// 从会话连接集合中移除
	if oldSessionID != nil {
		if conns, ok := cm.sessionConnections[*oldSessionID]; ok {
			delete(conns, connectionID)
			if len(conns) == 0 {
				delete(cm.sessionConnections, *oldSessionID)
			}
		}
	}

	global.GVA_LOG.Info("解除连接与会话绑定",
		zap.String("connectionId", connectionID),
		zap.String("oldSessionId", *oldSessionID))
}

// SendToConnection 发送消息到指定连接
func (cm *ConnectionManager) SendToConnection(connectionID string, message []byte) bool {
	cm.mu.RLock()
	connectionInfo, ok := cm.connections[connectionID]
	cm.mu.RUnlock()

	if !ok {
		global.GVA_LOG.Warn("连接未找到", zap.String("connectionId", connectionID))
		return false
	}

	connectionInfo.mu.RLock()
	isConnected := connectionInfo.IsConnected
	conn := connectionInfo.Conn
	connectionInfo.mu.RUnlock()

	if !isConnected {
		global.GVA_LOG.Warn("连接未激活", zap.String("connectionId", connectionID))
		return false
	}

	err := conn.WriteMessage(websocket.TextMessage, message)
	if err != nil {
		global.GVA_LOG.Error("发送消息失败",
			zap.String("connectionId", connectionID),
			zap.Error(err))
		cm.DisconnectConnection(connectionID, "发送错误: "+err.Error())
		return false
	}

	return true
}

// BroadcastToSession 广播消息到会话中的所有连接
func (cm *ConnectionManager) BroadcastToSession(sessionID string, message []byte, excludeConnectionID *string) int {
	cm.mu.RLock()
	connIDs, ok := cm.sessionConnections[sessionID]
	cm.mu.RUnlock()

	if !ok {
		return 0
	}

	successCount := 0
	for connectionID := range connIDs {
		if excludeConnectionID != nil && connectionID == *excludeConnectionID {
			continue
		}
		if cm.SendToConnection(connectionID, message) {
			successCount++
		}
	}

	return successCount
}

// GetConnectionByRole 获取会话中指定角色的连接ID
func (cm *ConnectionManager) GetConnectionByRole(sessionID string, role ClientRole) *string {
	cm.mu.RLock()
	defer cm.mu.RUnlock()

	connIDs, ok := cm.sessionConnections[sessionID]
	if !ok {
		return nil
	}

	for connectionID := range connIDs {
		if info, ok := cm.connections[connectionID]; ok {
			info.mu.RLock()
			connRole := info.Role
			isConnected := info.IsConnected
			info.mu.RUnlock()
			if connRole != nil && *connRole == role && isConnected {
				return &connectionID
			}
		}
	}
	return nil
}

// GetConnectionInfo 获取连接信息
func (cm *ConnectionManager) GetConnectionInfo(connectionID string) *ConnectionInfo {
	cm.mu.RLock()
	defer cm.mu.RUnlock()
	return cm.connections[connectionID]
}

// UpdateConnectionRole 更新连接的角色
func (cm *ConnectionManager) UpdateConnectionRole(connectionID string, role ClientRole) {
	cm.mu.RLock()
	connectionInfo, ok := cm.connections[connectionID]
	cm.mu.RUnlock()

	if ok {
		connectionInfo.mu.Lock()
		connectionInfo.Role = &role
		connectionInfo.mu.Unlock()
	}
}

// UpdateHeartbeat 更新心跳时间
func (cm *ConnectionManager) UpdateHeartbeat(connectionID string) {
	cm.mu.RLock()
	connectionInfo, ok := cm.connections[connectionID]
	cm.mu.RUnlock()

	if ok {
		connectionInfo.UpdateHeartbeat()
	}
}

// DisconnectConnection 断开连接
func (cm *ConnectionManager) DisconnectConnection(connectionID string, reason string) {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionInfo, ok := cm.connections[connectionID]
	if !ok {
		return
	}

	connectionInfo.mu.Lock()
	if connectionInfo.Conn != nil {
		connectionInfo.Conn.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, reason))
		connectionInfo.Conn.Close()
	}
	connectionInfo.IsConnected = false
	sessionID := connectionInfo.SessionID
	connectionInfo.mu.Unlock()

	// 从会话连接集合中移除
	if sessionID != nil {
		if conns, ok := cm.sessionConnections[*sessionID]; ok {
			delete(conns, connectionID)
			if len(conns) == 0 {
				delete(cm.sessionConnections, *sessionID)
			}
		}
	}

	global.GVA_LOG.Info("断开WebSocket连接",
		zap.String("connectionId", connectionID),
		zap.String("reason", reason))
}

// GetSessionActiveConnections 获取会话的所有活跃连接
func (cm *ConnectionManager) GetSessionActiveConnections(sessionID string) []string {
	cm.mu.RLock()
	defer cm.mu.RUnlock()

	result := []string{}
	if connIDs, ok := cm.sessionConnections[sessionID]; ok {
		for connectionID := range connIDs {
			if info, ok := cm.connections[connectionID]; ok {
				info.mu.RLock()
				isConnected := info.IsConnected
				info.mu.RUnlock()
				if isConnected {
					result = append(result, connectionID)
				}
			}
		}
	}
	return result
}

// HasActiveRoleConnection 检查会话中是否包含指定角色的活跃连接
func (cm *ConnectionManager) HasActiveRoleConnection(sessionID string, role ClientRole) bool {
	return cm.GetConnectionByRole(sessionID, role) != nil
}

// FindAllMainControlConnections 查找所有角色为 MAIN_CONTROL 的活跃连接
func (cm *ConnectionManager) FindAllMainControlConnections(excludeUserID *int64) []string {
	cm.mu.RLock()
	defer cm.mu.RUnlock()

	result := []string{}
	for connectionID, info := range cm.connections {
		info.mu.RLock()
		role := info.Role
		isConnected := info.IsConnected
		userID := info.UserID
		info.mu.RUnlock()

		if role != nil && *role == RoleMainControl && isConnected {
			if excludeUserID == nil || userID == nil || *userID != *excludeUserID {
				result = append(result, connectionID)
			}
		}
	}

	return result
}

// FindMainControlConnectionsByStore 按门店查找主控端连接（门店隔离）
func (cm *ConnectionManager) FindMainControlConnectionsByStore(storeId string, excludeUserID *int64) []string {
	cm.mu.RLock()
	defer cm.mu.RUnlock()

	result := []string{}
	for connectionID, info := range cm.connections {
		info.mu.RLock()
		role := info.Role
		isConnected := info.IsConnected
		userID := info.UserID
		connStoreId := info.StoreId
		userType := info.UserType
		info.mu.RUnlock()

		// 门店隔离：只查找同门店的主控端
		// 主控端条件：1. role为MAIN_CONTROL 或者 2. userType为optometrist（验光师自动为主控端）
		isMainControl := (role != nil && *role == RoleMainControl) || userType == "optometrist"
		if isMainControl && isConnected && connStoreId == storeId {
			global.GVA_LOG.Debug("找到候选主控端连接",
				zap.String("connectionId", connectionID),
				zap.Any("role", role),
				zap.String("userType", userType),
				zap.Bool("isMainControl", isMainControl),
				zap.String("storeId", connStoreId),
				zap.String("targetStoreId", storeId))
			if excludeUserID == nil || userID == nil || *userID != *excludeUserID {
				result = append(result, connectionID)
				global.GVA_LOG.Debug("添加为主控端",
					zap.String("connectionId", connectionID),
					zap.Any("userId", userID))
			}
		}
	}

	global.GVA_LOG.Info("按门店查找主控端",
		zap.String("storeId", storeId),
		zap.Int("count", len(result)))

	return result
}

// CheckHeartbeats 检查心跳超时
func (cm *ConnectionManager) CheckHeartbeats() {
	cm.mu.RLock()
	connections := make([]*ConnectionInfo, 0, len(cm.connections))
	for _, info := range cm.connections {
		connections = append(connections, info)
	}
	cm.mu.RUnlock()

	timeoutConnections := []string{}
	now := time.Now().UnixMilli()

	for _, info := range connections {
		info.mu.RLock()
		isConnected := info.IsConnected
		info.mu.RUnlock()

		if isConnected && info.IsHeartbeatTimeout(cm.heartbeatTimeoutMs) {
			info.mu.RLock()
			lastHeartbeat := info.LastHeartbeatTime
			connectionID := info.ConnectionID
			info.mu.RUnlock()

			timeoutConnections = append(timeoutConnections, connectionID)
			global.GVA_LOG.Info("WebSocket心跳超时",
				zap.String("connectionId", connectionID),
				zap.Int64("lastHeartbeatAge", now-lastHeartbeat))
		}
	}

	for _, connectionID := range timeoutConnections {
		cm.DisconnectConnection(connectionID, "心跳超时")
	}
}

// RemoveConnection 移除连接
func (cm *ConnectionManager) RemoveConnection(connectionID string) {
	cm.mu.Lock()
	defer cm.mu.Unlock()

	connectionInfo, ok := cm.connections[connectionID]
	if !ok {
		return
	}

	// 从会话连接集合中移除
	if connectionInfo.SessionID != nil {
		if conns, ok := cm.sessionConnections[*connectionInfo.SessionID]; ok {
			delete(conns, connectionID)
			if len(conns) == 0 {
				delete(cm.sessionConnections, *connectionInfo.SessionID)
			}
		}
	}

	delete(cm.connections, connectionID)
	global.GVA_LOG.Info("移除WebSocket连接", zap.String("connectionId", connectionID))
}

// GetConnectionCount 获取连接数量
func (cm *ConnectionManager) GetConnectionCount() int {
	cm.mu.RLock()
	defer cm.mu.RUnlock()
	return len(cm.connections)
}
