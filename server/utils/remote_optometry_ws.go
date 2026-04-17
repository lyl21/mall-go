package utils

import (
	"encoding/json"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

// RemoteOptometryWSManager 远程验光 WebSocket 管理器
type RemoteOptometryWSManager struct {
	sessions     map[string]*RemoteOptometrySession // sessionId -> session
	connections  map[string]*RemoteOptometryConn    // connectionId -> connection
	tokenInfo    map[string]*TokenData              // token -> tokenData
	mu           sync.RWMutex
	rtcGen       *AgoraTokenGenerator
	txnManager   *TransactionManager
	tokenExpireMs int64
}

// TokenData Token数据
type TokenData struct {
	SessionID string
	Role      ClientRole
	CreatedAt int64
}

// IsExpired 检查token是否过期
func (t *TokenData) IsExpired(expireMs int64) bool {
	return time.Now().UnixMilli()-t.CreatedAt > expireMs
}

// RemoteOptometrySession 远程验光会话
type RemoteOptometrySession struct {
	SessionID        string
	MainControlConn  *RemoteOptometryConn
	ControlledConn   *RemoteOptometryConn
	State            *SessionState
	CreatedAt        time.Time
	IsControlActive  bool
}

// RemoteOptometryConn 远程验光连接
type RemoteOptometryConn struct {
	Conn         *websocket.Conn
	ConnectionID string
	UserID       *int64
	SessionID    *string
	Role         ClientRole
	LastPing     time.Time
}

// ClientRole 客户端角色
type ClientRole string

const (
	RoleMainControl ClientRole = "MAIN_CONTROL"
	RoleControlled  ClientRole = "CONTROLLED"
)

// LensMode 镜片模式
type LensMode string

const (
	LensModeFar  LensMode = "FAR"
	LensModeNear LensMode = "NEAR"
)

// ApplyStatus 执行状态
type ApplyStatus string

const (
	ApplyStatusApplying ApplyStatus = "APPLYING"
	ApplyStatusSuccess  ApplyStatus = "SUCCESS"
	ApplyStatusFailed   ApplyStatus = "FAILED"
	ApplyStatusTimeout  ApplyStatus = "TIMEOUT"
)

// TransportType 传输方式
type TransportType string

const (
	TransportBLE TransportType = "BLE"
	TransportUSB TransportType = "USB"
)

// PatchOpType Patch 操作类型
type PatchOpType string

const (
	PatchOpSet PatchOpType = "set"
)

// CommandType 消息命令类型
type CommandType string

const (
	// 会话管理
	CmdCreateSession     CommandType = "create_session"
	CmdJoinSession       CommandType = "join_session"
	CmdSyncSnapshot      CommandType = "sync_snapshot"
	CmdSessionTerminate  CommandType = "session/terminate"
	CmdSessionTerminated CommandType = "session/terminated"

	// 握手流程
	CmdControlRequest  CommandType = "control_request"
	CmdControlResponse CommandType = "control_response"
	CmdControlAccepted CommandType = "control_accepted"
	CmdControlRejected CommandType = "control_rejected"

	// 状态同步
	CmdStateSync CommandType = "state_sync"

	// 命令流转
	CmdCommandPatch CommandType = "command/patch"
	CmdApplyPatch   CommandType = "apply/patch"
	CmdAck          CommandType = "ack"
	CmdPatchApplied CommandType = "patch_applied"

	// 心跳
	CmdHeartbeat    CommandType = "heartbeat"
	CmdHeartbeatAck CommandType = "heartbeat/ack"

	// 错误
	CmdError CommandType = "error"
)

// PatchOperation 单个 Patch 操作
type PatchOperation struct {
	Op PatchOpType      `json:"op"`
	P  string           `json:"p"` // JSON Pointer 风格路径
	V  *json.RawMessage `json:"v"` // 值（可以是任意类型）
}

// LastApply 最后执行状态记录
type LastApply struct {
	TxnID     *string     `json:"txnId,omitempty"`
	Status    ApplyStatus `json:"status,omitempty"`
	Ok        *bool       `json:"ok,omitempty"`
	Error     *string     `json:"error,omitempty"`
	UpdatedAt *int64      `json:"updatedAt,omitempty"`
}

// DeviceState 设备状态
type DeviceState struct {
	NiuTouConnected bool           `json:"niuTouConnected"`
	Transport       *TransportType `json:"transport,omitempty"`
	LastApply       *LastApply     `json:"lastApply,omitempty"`
}

// LensState 镜片状态
type LensState struct {
	Mode   LensMode `json:"mode"`
	LeftS  *float64 `json:"leftS,omitempty"`
	RightS *float64 `json:"rightS,omitempty"`
}

// MetaInfo 状态元数据
type MetaInfo struct {
	UpdatedAt int64  `json:"updatedAt"`
	Source    string `json:"source"`
}

// SessionState 会话状态（权威状态）
type SessionState struct {
	SessionID string      `json:"sessionId"`
	Version   int64       `json:"version"`
	Lens      LensState   `json:"lens"`
	Device    DeviceState `json:"device"`
	Meta      MetaInfo    `json:"meta"`
}

// SocketMessage 通用消息封装
type SocketMessage struct {
	Cmd       CommandType      `json:"cmd"`
	SessionID *string          `json:"sessionId,omitempty"`
	TxnID     *string          `json:"txnId,omitempty"`
	Role      *ClientRole      `json:"role,omitempty"`
	Version   *int64           `json:"version,omitempty"`
	Data      *json.RawMessage `json:"data,omitempty"`
}

// CreateSessionData 创建会话请求数据
type CreateSessionData struct {
	Role ClientRole `json:"role"`
}

// CreateSessionResponseData 创建会话响应数据
type CreateSessionResponseData struct {
	SessionID    string       `json:"sessionId"`
	Token        string       `json:"token"`
	InitialState SessionState `json:"initialState"`
}

// JoinSessionData 加入会话请求数据
type JoinSessionData struct {
	Token        *string       `json:"token,omitempty"`
	Role         ClientRole    `json:"role"`
	SessionID    *string       `json:"sessionId,omitempty"`
	CurrentState *SessionState `json:"currentState,omitempty"`
	UserID       *int64        `json:"userId,omitempty"`
}

// JoinSessionResponseData 加入会话响应数据
type JoinSessionResponseData struct {
	SessionID    string       `json:"sessionId"`
	SessionState SessionState `json:"sessionState"`
}

// CommandPatchData 命令Patch数据
type CommandPatchData struct {
	ExpectedVersion *int64           `json:"expectedVersion,omitempty"`
	Ops             []PatchOperation `json:"ops"`
}

// ApplyPatchData 执行Patch数据
type ApplyPatchData struct {
	BaseVersion int64            `json:"baseVersion"`
	Ops         []PatchOperation `json:"ops"`
}

// AckData Ack回执数据
type AckData struct {
	Success    bool             `json:"success"`
	DeviceSend *string          `json:"deviceSend,omitempty"`
	Error      *string          `json:"error,omitempty"`
	AppliedOps []PatchOperation `json:"appliedOps,omitempty"`
}

// PatchAppliedData Patch应用结果数据
type PatchAppliedData struct {
	NewVersion int64            `json:"newVersion"`
	Success    bool             `json:"success"`
	DeviceSend *string          `json:"deviceSend,omitempty"`
	Ops        []PatchOperation `json:"ops,omitempty"`
	Error      *string          `json:"error,omitempty"`
}

// SessionTerminateData 会话终止数据
type SessionTerminateData struct {
	Reason string `json:"reason"`
}

// HeartbeatData 心跳数据
type HeartbeatData struct {
	Timestamp int64 `json:"timestamp"`
}

// ErrorData 错误响应数据
type ErrorData struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Details string `json:"details,omitempty"`
}

// ControlRequestData 远控请求数据
type ControlRequestData struct {
	DeviceInfo *string `json:"deviceInfo,omitempty"`
	Message    *string `json:"message,omitempty"`
}

// ControlResponseData 远控响应数据
type ControlResponseData struct {
	Accept  bool    `json:"accept"`
	Message *string `json:"message,omitempty"`
}

// ControlAcceptedData 远控已接受数据
type ControlAcceptedData struct {
	MainControlInfo *string           `json:"mainControlInfo,omitempty"`
	Message         *string           `json:"message,omitempty"`
	RtcConfig       *AgoraTokenResponse `json:"rtcConfig,omitempty"`
}

// ControlRejectedData 远控被拒绝数据
type ControlRejectedData struct {
	Reason  string  `json:"reason"`
	Message *string `json:"message,omitempty"`
}

// WelcomeMessage 欢迎消息
type WelcomeMessage struct {
	Type         string `json:"type"`
	ConnectionID string `json:"connectionId"`
	DateTime     string `json:"dateTime"`
	Message      string `json:"message"`
}

var (
	RemoteOptometryManager *RemoteOptometryWSManager
)

// InitRemoteOptometryManager 初始化远程验光 WebSocket 管理器
func InitRemoteOptometryManager() {
	RemoteOptometryManager = &RemoteOptometryWSManager{
		sessions:      make(map[string]*RemoteOptometrySession),
		connections:   make(map[string]*RemoteOptometryConn),
		tokenInfo:     make(map[string]*TokenData),
		rtcGen:        NewAgoraTokenGenerator(),
		txnManager:    NewTransactionManager(),
		tokenExpireMs: 3600000, // 1小时
	}
	// 启动心跳检测
	go RemoteOptometryManager.heartbeatChecker()
	// 启动事务超时检测
	go RemoteOptometryManager.applyTimeoutChecker()
	// 启动Token过期清理
	go RemoteOptometryManager.tokenCleanupLoop()
	global.GVA_LOG.Info("远程验光 WebSocket 管理器已初始化")
}

// generateToken 生成Token
func (m *RemoteOptometryWSManager) generateToken() string {
	return "token_" + time.Now().Format("20060102150405") + "_" + randomString(16)
}

// CreateSessionWithToken 创建会话并生成Token
func (m *RemoteOptometryWSManager) CreateSessionWithToken(role ClientRole) (*CreateSessionResponseData, string) {
	m.mu.Lock()
	defer m.mu.Unlock()

	sessionID := generateSessionID()
	token := m.generateToken()
	timestamp := time.Now().UnixMilli()

	// 创建初始状态
	initialState := m.createInitialSessionState(sessionID)

	// 创建会话
	session := &RemoteOptometrySession{
		SessionID:       sessionID,
		State:           initialState,
		CreatedAt:       time.Now(),
		IsControlActive: false,
	}

	// 保存会话
	m.sessions[sessionID] = session

	// 保存Token信息
	m.tokenInfo[token] = &TokenData{
		SessionID: sessionID,
		Role:      role,
		CreatedAt: timestamp,
	}

	global.GVA_LOG.Info("创建会话并生成Token",
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)),
		zap.String("token", token))

	return &CreateSessionResponseData{
		SessionID:    sessionID,
		Token:        token,
		InitialState: *initialState,
	}, token
}

// ValidateToken 验证Token
func (m *RemoteOptometryWSManager) ValidateToken(token string, role ClientRole) (string, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	tokenData, ok := m.tokenInfo[token]
	if !ok {
		return "", &RemoteOptometryError{Message: "Invalid token"}
	}

	// 检查Token是否过期
	if tokenData.IsExpired(m.tokenExpireMs) {
		delete(m.tokenInfo, token)
		return "", &RemoteOptometryError{Message: "Token expired"}
	}

	// 检查角色是否匹配
	if tokenData.Role != role {
		return "", &RemoteOptometryError{Message: "Role mismatch"}
	}

	return tokenData.SessionID, nil
}

// tokenCleanupLoop Token清理循环
func (m *RemoteOptometryWSManager) tokenCleanupLoop() {
	ticker := time.NewTicker(5 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		m.cleanupExpiredTokens()
	}
}

// cleanupExpiredTokens 清理过期Token
func (m *RemoteOptometryWSManager) cleanupExpiredTokens() {
	m.mu.Lock()
	defer m.mu.Unlock()

	for token, tokenData := range m.tokenInfo {
		if tokenData.IsExpired(m.tokenExpireMs) {
			delete(m.tokenInfo, token)
			global.GVA_LOG.Info("清理过期Token", zap.String("token", token))
		}
	}
}

// FindMainControlConnection 查找可用的主控端连接
func (m *RemoteOptometryWSManager) FindMainControlConnection(excludeUserID *int64) *RemoteOptometryConn {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, session := range m.sessions {
		if session.MainControlConn != nil {
			// 排除指定用户ID
			if excludeUserID != nil && session.MainControlConn.UserID != nil &&
				*session.MainControlConn.UserID == *excludeUserID {
				continue
			}
			global.GVA_LOG.Info("找到可用的主控端连接",
				zap.String("connectionId", session.MainControlConn.ConnectionID),
				zap.Any("userId", session.MainControlConn.UserID))
			return session.MainControlConn
		}
	}
	return nil
}

// IsInActiveSession 检查用户是否已在活跃的远程控制会话中
func (m *RemoteOptometryWSManager) IsInActiveSession(userID *int64, role ClientRole) *string {
	if userID == nil {
		return nil
	}

	m.mu.RLock()
	defer m.mu.RUnlock()

	for sessionID, session := range m.sessions {
		if session.IsControlActive {
			switch role {
			case RoleMainControl:
				if session.MainControlConn != nil && session.MainControlConn.UserID != nil &&
					*session.MainControlConn.UserID == *userID {
					global.GVA_LOG.Info("主控端已在活跃远控会话中",
						zap.Int64("userId", *userID),
						zap.String("sessionId", sessionID))
					return &sessionID
				}
			case RoleControlled:
				if session.ControlledConn != nil && session.ControlledConn.UserID != nil &&
					*session.ControlledConn.UserID == *userID {
					global.GVA_LOG.Info("被控端已在活跃远控会话中",
						zap.Int64("userId", *userID),
						zap.String("sessionId", sessionID))
					return &sessionID
				}
			}
		}
	}
	return nil
}

// RemoteOptometryError 远程验光错误
type RemoteOptometryError struct {
	Message string
}

func (e *RemoteOptometryError) Error() string {
	return e.Message
}

// HandleRemoteOptometryWS 处理远程验光 WebSocket 连接
func (m *RemoteOptometryWSManager) HandleRemoteOptometryWS(w http.ResponseWriter, r *http.Request) {
	upgrader := websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true // 允许所有来源
		},
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		global.GVA_LOG.Error("WebSocket 升级失败", zap.Error(err))
		return
	}

	// 从 URL 路径中提取 userId
	path := r.URL.Path
	userIDStr := ""
	if len(path) > len("/ws/remote-optometry/") {
		userIDStr = path[len("/ws/remote-optometry/"):]
	}

	var userID *int64
	if userIDStr != "" {
		if id, err := strconv.ParseInt(userIDStr, 10, 64); err == nil {
			userID = &id
		}
	}

	// 生成连接ID
	connectionID := generateConnectionID()

	// 创建连接对象
	connection := &RemoteOptometryConn{
		Conn:         conn,
		ConnectionID: connectionID,
		UserID:       userID,
		LastPing:     time.Now(),
	}

	m.mu.Lock()
	m.connections[connectionID] = connection
	m.mu.Unlock()

	global.GVA_LOG.Info("新建远程验光 WebSocket 连接",
		zap.String("connectionId", connectionID),
		zap.Any("userId", userID))

	// 发送欢迎消息
	welcomeMsg := WelcomeMessage{
		Type:         "welcome",
		ConnectionID: connectionID,
		DateTime:     time.Now().Format("2006-01-02 15:04:05"),
		Message:      "已连接到远程验光 Socket 服务",
	}
	welcomeBytes, _ := json.Marshal(welcomeMsg)
	conn.WriteMessage(websocket.TextMessage, welcomeBytes)

	// 处理消息
	m.handleConnection(connection)
}

// handleConnection 处理连接消息
func (m *RemoteOptometryWSManager) handleConnection(conn *RemoteOptometryConn) {
	defer func() {
		m.cleanupConnection(conn)
	}()

	for {
		_, message, err := conn.Conn.ReadMessage()
		if err != nil {
			global.GVA_LOG.Info("WebSocket 连接断开",
				zap.String("connectionId", conn.ConnectionID),
				zap.Error(err))
			return
		}

		var msg SocketMessage
		if err := json.Unmarshal(message, &msg); err != nil {
			global.GVA_LOG.Error("解析消息失败",
				zap.String("connectionId", conn.ConnectionID),
				zap.Error(err))
			continue
		}

		// 处理消息
		response := m.handleMessage(conn, &msg)
		if response != nil {
			responseBytes, _ := json.Marshal(response)
			conn.Conn.WriteMessage(websocket.TextMessage, responseBytes)
		}
	}
}

// handleMessage 处理消息
func (m *RemoteOptometryWSManager) handleMessage(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	switch msg.Cmd {
	case CmdCreateSession:
		return m.handleCreateSession(conn, msg)
	case CmdJoinSession:
		return m.handleJoinSession(conn, msg)
	case CmdControlRequest:
		return m.handleControlRequest(conn, msg)
	case CmdControlResponse:
		return m.handleControlResponse(conn, msg)
	case CmdCommandPatch:
		return m.handleCommandPatch(conn, msg)
	case CmdAck:
		return m.handleAck(conn, msg)
	case CmdHeartbeat:
		return m.handleHeartbeat(conn, msg)
	case CmdSessionTerminate:
		return m.handleSessionTerminate(conn, msg)
	case CmdStateSync:
		return m.handleStateSync(conn, msg)
	case CmdSyncSnapshot:
		return m.handleSyncSnapshot(conn, msg)
	default:
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未知命令: "+string(msg.Cmd))
	}
}

// handleCreateSession 处理创建会话请求
func (m *RemoteOptometryWSManager) handleCreateSession(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	var createData CreateSessionData
	if msg.Data != nil {
		if err := json.Unmarshal(*msg.Data, &createData); err != nil {
			return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
		}
	} else {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 使用Token机制创建会话
	responseData, token := m.CreateSessionWithToken(createData.Role)

	// 根据角色绑定连接
	m.mu.Lock()
	session := m.sessions[responseData.SessionID]
	if createData.Role == RoleMainControl {
		session.MainControlConn = conn
	} else {
		session.ControlledConn = conn
	}
	conn.SessionID = &responseData.SessionID
	conn.Role = createData.Role
	m.mu.Unlock()

	global.GVA_LOG.Info("创建会话成功",
		zap.String("connectionId", conn.ConnectionID),
		zap.String("sessionId", responseData.SessionID),
		zap.String("role", string(createData.Role)),
		zap.String("token", token))

	// 构建响应（包含Token）
	responseData.Token = token
	data, _ := json.Marshal(responseData)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdCreateSession,
		SessionID: &responseData.SessionID,
		TxnID:     msg.TxnID,
		Role:      &createData.Role,
		Data:      &rawData,
	}
}

// handleJoinSession 处理加入会话请求
func (m *RemoteOptometryWSManager) handleJoinSession(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	var joinData JoinSessionData
	if msg.Data != nil {
		if err := json.Unmarshal(*msg.Data, &joinData); err != nil {
			return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
		}
	} else {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	var sessionID string
	var err error

	// 优先使用Token加入会话
	if joinData.Token != nil && *joinData.Token != "" {
		sessionID, err = m.ValidateToken(*joinData.Token, joinData.Role)
		if err != nil {
			return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, err.Error())
		}
		global.GVA_LOG.Info("使用Token加入会话",
			zap.String("token", *joinData.Token),
			zap.String("sessionId", sessionID))
	} else if joinData.SessionID != nil {
		// 使用sessionId加入（Demo模式）
		sessionID = *joinData.SessionID
	} else {
		// 自动匹配模式：被控端尝试找到可用的主控端
		if joinData.Role == RoleControlled && conn.UserID != nil {
			// 检查是否已在活跃会话中
			if existingSessionID := m.IsInActiveSession(conn.UserID, RoleControlled); existingSessionID != nil {
				return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "已在活跃远控会话中: "+*existingSessionID)
			}

			// 查找可用的主控端
			mainControlConn := m.FindMainControlConnection(conn.UserID)
			if mainControlConn != nil && mainControlConn.SessionID != nil {
				sessionID = *mainControlConn.SessionID
				global.GVA_LOG.Info("自动匹配到主控端",
					zap.String("sessionId", sessionID),
					zap.String("mainControlConn", mainControlConn.ConnectionID))
			} else {
				return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未找到可用的主控端")
			}
		} else {
			return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId or token")
		}
	}

	m.mu.Lock()
	session, exists := m.sessions[sessionID]
	if !exists {
		// Demo模式：自动创建会话
		initialState := m.createInitialSessionState(sessionID)
		session = &RemoteOptometrySession{
			SessionID:       sessionID,
			State:           initialState,
			CreatedAt:       time.Now(),
			IsControlActive: false,
		}
		m.sessions[sessionID] = session
		global.GVA_LOG.Info("Demo模式：自动创建会话", zap.String("sessionId", sessionID))
	}

	// 根据角色绑定连接
	if joinData.Role == RoleMainControl {
		if session.MainControlConn != nil {
			// Demo模式：踢掉旧连接
			global.GVA_LOG.Info("Demo模式：主控端已存在，踢掉旧连接",
				zap.String("sessionId", sessionID))
		}
		session.MainControlConn = conn
	} else {
		if session.ControlledConn != nil {
			// Demo模式：踢掉旧连接
			global.GVA_LOG.Info("Demo模式：被控端已存在，踢掉旧连接",
				zap.String("sessionId", sessionID))
		}
		session.ControlledConn = conn
	}

	conn.SessionID = &sessionID
	conn.Role = joinData.Role
	m.mu.Unlock()

	global.GVA_LOG.Info("加入会话成功",
		zap.String("connectionId", conn.ConnectionID),
		zap.String("sessionId", sessionID),
		zap.String("role", string(joinData.Role)))

	// 构建响应
	responseData := JoinSessionResponseData{
		SessionID:    sessionID,
		SessionState: *session.State,
	}
	data, _ := json.Marshal(responseData)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdJoinSession,
		SessionID: &sessionID,
		TxnID:     msg.TxnID,
		Role:      &joinData.Role,
		Data:      &rawData,
	}
}

// handleControlRequest 处理远控请求
func (m *RemoteOptometryWSManager) handleControlRequest(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	// 权限检查
	if conn.Role != RoleControlled {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有被控端可以发起远控请求")
	}

	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未绑定会话")
	}

	m.mu.RLock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.RUnlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "会话不存在")
	}

	mainControlConn := session.MainControlConn
	m.mu.RUnlock()

	if mainControlConn == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "主控端未连接")
	}

	// 转发请求给主控端
	forwardMsg := SocketMessage{
		Cmd:       CmdControlRequest,
		SessionID: conn.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Data:      msg.Data,
	}
	msgBytes, _ := json.Marshal(forwardMsg)
	mainControlConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

	global.GVA_LOG.Info("转发远控请求给主控端",
		zap.String("sessionId", *conn.SessionID),
		zap.String("controlledConnection", conn.ConnectionID))

	return nil
}

// handleControlResponse 处理远控响应
func (m *RemoteOptometryWSManager) handleControlResponse(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未绑定会话")
	}

	if conn.Role != RoleMainControl {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有主控端可以响应远控请求")
	}

	var responseData ControlResponseData
	if msg.Data != nil {
		if err := json.Unmarshal(*msg.Data, &responseData); err != nil {
			return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
		}
	}

	m.mu.Lock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.Unlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "会话不存在")
	}

	controlledConn := session.ControlledConn

	if responseData.Accept {
		session.IsControlActive = true
	}
	m.mu.Unlock()

	if controlledConn == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "被控端未连接")
	}

	if responseData.Accept {
		// 生成 RTC 配置
		var rtcConfigForMain, rtcConfigForControlled *AgoraTokenResponse
		if m.rtcGen != nil && m.rtcGen.IsConfigured() {
			rtcConfigForMain = m.rtcGen.GenerateRtcConfig(*conn.SessionID, "main_control")
			rtcConfigForControlled = m.rtcGen.GenerateRtcConfig(*conn.SessionID, "controlled")
		}

		// 通知被控端
		acceptedDataForControlled := ControlAcceptedData{
			MainControlInfo: strPtr("主控端已同意"),
			Message:         responseData.Message,
			RtcConfig:       rtcConfigForControlled,
		}
		acceptedMsg := SocketMessage{
			Cmd:       CmdControlAccepted,
			SessionID: conn.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		acceptedBytes, _ := json.Marshal(acceptedDataForControlled)
		rawData := json.RawMessage(acceptedBytes)
		acceptedMsg.Data = &rawData

		msgBytes, _ := json.Marshal(acceptedMsg)
		controlledConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

		// 返回响应给主控端
		acceptedDataForMain := ControlAcceptedData{
			MainControlInfo: strPtr("已通知被控端"),
			Message:         strPtr("远控已建立"),
			RtcConfig:       rtcConfigForMain,
		}
		responseMsg := SocketMessage{
			Cmd:       CmdControlResponse,
			SessionID: conn.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		responseBytes, _ := json.Marshal(acceptedDataForMain)
		rawData2 := json.RawMessage(responseBytes)
		responseMsg.Data = &rawData2

		global.GVA_LOG.Info("主控端同意远控",
			zap.String("sessionId", *conn.SessionID))

		return &responseMsg
	} else {
		// 拒绝远控
		rejectedData := ControlRejectedData{
			Reason:  "主控端拒绝",
			Message: responseData.Message,
		}
		rejectedMsg := SocketMessage{
			Cmd:       CmdControlRejected,
			SessionID: conn.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		rejectedBytes, _ := json.Marshal(rejectedData)
		rawData := json.RawMessage(rejectedBytes)
		rejectedMsg.Data = &rawData

		msgBytes, _ := json.Marshal(rejectedMsg)
		controlledConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

		global.GVA_LOG.Info("主控端拒绝远控",
			zap.String("sessionId", *conn.SessionID))

		return nil
	}
}

// handleCommandPatch 处理命令补丁
func (m *RemoteOptometryWSManager) handleCommandPatch(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.TxnID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing txnId")
	}
	if msg.Data == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 权限检查
	if conn.Role != RoleMainControl {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有主控端可以发送命令")
	}

	m.mu.RLock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.RUnlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Session not found")
	}

	controlledConn := session.ControlledConn
	m.mu.RUnlock()

	if controlledConn == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "被控端未连接")
	}

	var commandData CommandPatchData
	if err := json.Unmarshal(*msg.Data, &commandData); err != nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
	}

	// 开始事务
	txnID := m.txnManager.BeginTransaction(*conn.SessionID, conn.Role, &commandData)
	// 更新消息的TxnID为生成的事务ID
	msg.TxnID = &txnID

	// 构建 Apply 消息
	applyData := ApplyPatchData{
		BaseVersion: 0,
		Ops:         commandData.Ops,
	}
	if commandData.ExpectedVersion != nil {
		applyData.BaseVersion = *commandData.ExpectedVersion
	}

	applyMsg := SocketMessage{
		Cmd:       CmdApplyPatch,
		SessionID: conn.SessionID,
		TxnID:     &txnID,
		Version:   commandData.ExpectedVersion,
	}
	applyDataBytes, _ := json.Marshal(applyData)
	rawData := json.RawMessage(applyDataBytes)
	applyMsg.Data = &rawData

	global.GVA_LOG.Info("转发命令到被控端",
		zap.String("sessionId", *conn.SessionID),
		zap.String("txnId", txnID),
		zap.Int("opsCount", len(commandData.Ops)))

	// 发送给被控端
	msgBytes, _ := json.Marshal(applyMsg)
	controlledConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

	// 标记事务为执行中
	m.txnManager.MarkApplying(txnID)

	return nil
}

// handleAck 处理 ACK
func (m *RemoteOptometryWSManager) handleAck(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.TxnID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing txnId")
	}
	if msg.Data == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 权限检查
	if conn.Role != RoleControlled {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有被控端可以发送ack")
	}

	var ackData AckData
	if err := json.Unmarshal(*msg.Data, &ackData); err != nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
	}

	// 完成事务
	m.txnManager.CompleteTransaction(*msg.TxnID, &ackData)

	m.mu.RLock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.RUnlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Session not found")
	}

	// 更新版本号
	session.State.Version++
	newVersion := session.State.Version

	mainControlConn := session.MainControlConn
	m.mu.RUnlock()

	// 构建 PatchApplied 消息
	patchAppliedData := PatchAppliedData{
		NewVersion: newVersion,
		Success:    ackData.Success,
		DeviceSend: ackData.DeviceSend,
		Ops:        ackData.AppliedOps,
	}
	if !ackData.Success {
		patchAppliedData.Error = ackData.Error
	}

	patchAppliedMsg := SocketMessage{
		Cmd:       CmdPatchApplied,
		SessionID: conn.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Version:   &newVersion,
	}
	patchAppliedBytes, _ := json.Marshal(patchAppliedData)
	rawData := json.RawMessage(patchAppliedBytes)
	patchAppliedMsg.Data = &rawData

	global.GVA_LOG.Info("处理ack完成",
		zap.String("sessionId", *conn.SessionID),
		zap.String("txnId", *msg.TxnID),
		zap.Bool("success", ackData.Success),
		zap.Int64("newVersion", newVersion))

	// 发送给主控端
	if mainControlConn != nil {
		msgBytes, _ := json.Marshal(patchAppliedMsg)
		mainControlConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)
	}

	return nil
}

// handleHeartbeat 处理心跳
func (m *RemoteOptometryWSManager) handleHeartbeat(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	conn.LastPing = time.Now()

	heartbeatAckData := HeartbeatData{Timestamp: time.Now().UnixMilli()}
	heartbeatAckMsg := SocketMessage{
		Cmd:       CmdHeartbeatAck,
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
	}
	heartbeatBytes, _ := json.Marshal(heartbeatAckData)
	rawData := json.RawMessage(heartbeatBytes)
	heartbeatAckMsg.Data = &rawData

	return &heartbeatAckMsg
}

// handleSessionTerminate 处理会话终止
func (m *RemoteOptometryWSManager) handleSessionTerminate(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}

	m.mu.Lock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.Unlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Session not found")
	}

	// 获取另一端连接
	var otherConn *RemoteOptometryConn
	if conn.Role == RoleMainControl {
		otherConn = session.ControlledConn
	} else {
		otherConn = session.MainControlConn
	}

	// 删除会话
	delete(m.sessions, *conn.SessionID)
	m.mu.Unlock()

	// 通知另一端
	if otherConn != nil {
		terminatedData := SessionTerminateData{Reason: "对方已终止会话"}
		terminatedMsg := SocketMessage{
			Cmd:       CmdSessionTerminated,
			SessionID: conn.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		terminatedBytes, _ := json.Marshal(terminatedData)
		rawData := json.RawMessage(terminatedBytes)
		terminatedMsg.Data = &rawData

		msgBytes, _ := json.Marshal(terminatedMsg)
		otherConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)
	}

	global.GVA_LOG.Info("会话已终止",
		zap.String("sessionId", *conn.SessionID),
		zap.String("role", string(conn.Role)))

	return nil
}

// handleStateSync 处理状态同步
func (m *RemoteOptometryWSManager) handleStateSync(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}

	// 权限检查
	if conn.Role != RoleControlled {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有被控端可以发送状态同步")
	}

	m.mu.RLock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.RUnlock()
		return nil
	}

	mainControlConn := session.MainControlConn
	m.mu.RUnlock()

	if mainControlConn == nil {
		return nil
	}

	// 转发状态同步给主控端
	forwardMsg := SocketMessage{
		Cmd:       CmdStateSync,
		SessionID: conn.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Data:      msg.Data,
	}
	msgBytes, _ := json.Marshal(forwardMsg)
	mainControlConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

	return nil
}

// handleSyncSnapshot 处理同步快照请求
func (m *RemoteOptometryWSManager) handleSyncSnapshot(conn *RemoteOptometryConn, msg *SocketMessage) *SocketMessage {
	if conn.SessionID == nil {
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}

	m.mu.RLock()
	session, exists := m.sessions[*conn.SessionID]
	if !exists {
		m.mu.RUnlock()
		return m.createErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Session not found")
	}

	sessionState := *session.State
	m.mu.RUnlock()

	// 构建快照响应
	type SyncSnapshotResponseData struct {
		SessionState SessionState `json:"sessionState"`
	}

	responseData := SyncSnapshotResponseData{SessionState: sessionState}
	responseMsg := SocketMessage{
		Cmd:       CmdSyncSnapshot,
		SessionID: conn.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
	}
	responseBytes, _ := json.Marshal(responseData)
	rawData := json.RawMessage(responseBytes)
	responseMsg.Data = &rawData

	return &responseMsg
}

// cleanupConnection 清理连接
func (m *RemoteOptometryWSManager) cleanupConnection(conn *RemoteOptometryConn) {
	m.mu.Lock()
	defer m.mu.Unlock()

	// 从连接列表中删除
	delete(m.connections, conn.ConnectionID)

	// 如果连接绑定了会话，处理会话
	if conn.SessionID != nil {
		if session, exists := m.sessions[*conn.SessionID]; exists {
			// 根据角色清除连接
			if conn.Role == RoleMainControl {
				session.MainControlConn = nil
			} else {
				session.ControlledConn = nil
			}

			// 如果会话双方都已断开，删除会话
			if session.MainControlConn == nil && session.ControlledConn == nil {
				delete(m.sessions, *conn.SessionID)
				global.GVA_LOG.Info("会话已删除",
					zap.String("sessionId", *conn.SessionID))
			}
		}
	}

	conn.Conn.Close()

	global.GVA_LOG.Info("连接已清理",
		zap.String("connectionId", conn.ConnectionID))
}

// heartbeatChecker 心跳检测
func (m *RemoteOptometryWSManager) heartbeatChecker() {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		m.mu.Lock()
		now := time.Now()
		for connID, conn := range m.connections {
			if now.Sub(conn.LastPing) > 2*time.Minute {
				// 超过2分钟没有心跳，断开连接
				conn.Conn.Close()
				delete(m.connections, connID)

				// 处理会话
				if conn.SessionID != nil {
					if session, exists := m.sessions[*conn.SessionID]; exists {
						if conn.Role == RoleMainControl {
							session.MainControlConn = nil
						} else {
							session.ControlledConn = nil
						}

						if session.MainControlConn == nil && session.ControlledConn == nil {
							delete(m.sessions, *conn.SessionID)
						}
					}
				}

				global.GVA_LOG.Info("远程验光客户端心跳超时",
					zap.String("connectionId", connID),
					zap.String("sessionId", strPtrValue(conn.SessionID)))
			}
		}
		m.mu.Unlock()
	}
}

// createInitialSessionState 创建初始会话状态
func (m *RemoteOptometryWSManager) createInitialSessionState(sessionID string) *SessionState {
	now := time.Now().UnixMilli()
	return &SessionState{
		SessionID: sessionID,
		Version:   1,
		Lens: LensState{
			Mode: LensModeFar,
		},
		Device: DeviceState{
			NiuTouConnected: false,
			LastApply: &LastApply{
				UpdatedAt: &now,
			},
		},
		Meta: MetaInfo{
			UpdatedAt: now,
			Source:    "SERVER",
		},
	}
}

// applyTimeoutChecker Apply超时检测器
func (m *RemoteOptometryWSManager) applyTimeoutChecker() {
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		// 获取所有会话
		m.mu.RLock()
		sessions := make(map[string]*RemoteOptometrySession)
		for id, session := range m.sessions {
			sessions[id] = session
		}
		m.mu.RUnlock()

		// 检查每个会话的事务
		for sessionID, session := range sessions {
			// 获取该会话的所有事务
			records := m.txnManager.GetTransactionsBySession(sessionID)
			for _, record := range records {
				// 检查是否在APPLYING状态且超时
				if record.GetStatus() == TransactionStatusApplying {
					if record.IsTimeout(5000) { // 5秒超时
						// 标记事务超时
						if m.txnManager.MarkTimeout(record.TxnID) {
							global.GVA_LOG.Warn("事务执行超时",
								zap.String("txnId", record.TxnID),
								zap.String("sessionId", sessionID))

							// 通知主控端
							if session.MainControlConn != nil {
								timeoutData := PatchAppliedData{
									NewVersion: session.State.Version,
									Success:    false,
									Error:      strPtr("Apply timeout"),
									Ops:        record.GetCommandData().Ops,
								}
								timeoutMsg := SocketMessage{
									Cmd:       CmdPatchApplied,
									SessionID: &sessionID,
									TxnID:     &record.TxnID,
									Role:      (*ClientRole)(&record.Role),
									Version:   &session.State.Version,
								}
								timeoutBytes, _ := json.Marshal(timeoutData)
								rawData := json.RawMessage(timeoutBytes)
								timeoutMsg.Data = &rawData

								msgBytes, _ := json.Marshal(timeoutMsg)
								session.MainControlConn.Conn.WriteMessage(websocket.TextMessage, msgBytes)

								global.GVA_LOG.Info("已通知主控端事务超时",
									zap.String("txnId", record.TxnID),
									zap.String("sessionId", sessionID))
							}
						}
					}
				}
			}
		}
	}
}

// GetStats 获取统计信息
func (m *RemoteOptometryWSManager) GetStats() map[string]interface{} {
	m.mu.RLock()
	defer m.mu.RUnlock()

	stats := map[string]interface{}{
		"totalConnections": len(m.connections),
		"totalSessions":    len(m.sessions),
	}

	// 会话详情
	var sessionDetails []map[string]interface{}
	for sessionID, session := range m.sessions {
		sessionInfo := map[string]interface{}{
			"sessionId":       sessionID,
			"isControlActive": session.IsControlActive,
			"createdAt":       session.CreatedAt.Format("2006-01-02 15:04:05"),
			"hasMainControl":  session.MainControlConn != nil,
			"hasControlled":   session.ControlledConn != nil,
		}
		sessionDetails = append(sessionDetails, sessionInfo)
	}
	stats["sessions"] = sessionDetails

	// 事务统计
	if m.txnManager != nil {
		stats["transactions"] = m.txnManager.GetStats()
	}

	return stats
}

// createErrorMessage 创建错误消息
func (m *RemoteOptometryWSManager) createErrorMessage(sessionID *string, txnID *string, role *ClientRole, errMsg string) *SocketMessage {
	errData := ErrorData{
		Code:    500,
		Message: errMsg,
	}
	data, _ := json.Marshal(errData)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdError,
		SessionID: sessionID,
		TxnID:     txnID,
		Role:      role,
		Data:      &rawData,
	}
}

// Helper functions
func generateConnectionID() string {
	return "conn_" + time.Now().Format("20060102150405") + "_" + randomString(6)
}

func generateSessionID() string {
	return "session_" + time.Now().Format("20060102150405") + "_" + randomString(8)
}

func randomString(length int) string {
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	result := make([]byte, length)
	for i := range result {
		result[i] = chars[time.Now().UnixNano()%int64(len(chars))]
		time.Sleep(time.Nanosecond)
	}
	return string(result)
}

func strPtr(s string) *string {
	return &s
}

func strPtrValue(s *string) string {
	if s == nil {
		return ""
	}
	return *s
}

// LogRemoteOptometryEvent 记录远程验光事件日志
func (m *RemoteOptometryWSManager) LogRemoteOptometryEvent(sessionID string, eventType string, data map[string]interface{}) {
	go func() {
		defer func() {
			if r := recover(); r != nil {
				global.GVA_LOG.Error("记录远程验光日志时发生错误", zap.Any("recover", r))
			}
		}()

		log := store.RemoteOptometryLog{
			LogId:     "log_" + time.Now().Format("20060102150405") + "_" + randomString(8),
			SessionId: sessionID,
			StartTime: time.Now(),
		}

		// 从data中提取字段
		if v, ok := data["equipment"].(string); ok {
			log.Equipment = v
		}
		if v, ok := data["userId"].(int64); ok {
			log.UserId = &v
		}
		if v, ok := data["mainControlId"].(string); ok {
			log.MainControlId = &v
		}
		if v, ok := data["controlledId"].(string); ok {
			log.ControlledId = &v
		}
		if v, ok := data["isControlActive"].(bool); ok {
			log.IsControlActive = v
		}
		if v, ok := data["controlStatus"].(string); ok {
			log.ControlStatus = v
		}
		if v, ok := data["niuTouConnected"].(bool); ok {
			log.NiuTouConnected = v
		}
		if v, ok := data["transport"].(string); ok {
			log.Transport = v
		}
		if v, ok := data["lensMode"].(string); ok {
			log.LensMode = v
		}
		if v, ok := data["leftS"].(float64); ok {
			log.LeftS = &v
		}
		if v, ok := data["rightS"].(float64); ok {
			log.RightS = &v
		}
		if v, ok := data["lastApplyStatus"].(string); ok {
			log.LastApplyStatus = v
		}
		if v, ok := data["lastApplyTxnId"].(string); ok {
			log.LastApplyTxnId = v
		}
		if v, ok := data["lastApplyError"].(string); ok {
			log.LastApplyError = v
		}
		if v, ok := data["deviceInfo"].(string); ok {
			log.DeviceInfo = v
		}
		if v, ok := data["remark"].(string); ok {
			log.Remark = v
		}

		log.LastActiveTime = time.Now()

		// 异步保存到数据库
		if err := global.GVA_DB.Create(&log).Error; err != nil {
			global.GVA_LOG.Error("保存远程验光日志失败", zap.Error(err))
		}
	}()
}

// UpdateSessionLog 更新会话日志
func (m *RemoteOptometryWSManager) UpdateSessionLog(sessionID string, updates map[string]interface{}) {
	go func() {
		defer func() {
			if r := recover(); r != nil {
				global.GVA_LOG.Error("更新远程验光日志时发生错误", zap.Any("recover", r))
			}
		}()

		// 查找最新的日志记录
		var log store.RemoteOptometryLog
		if err := global.GVA_DB.Where("session_id = ?", sessionID).
			Order("start_time DESC").
			First(&log).Error; err != nil {
			return
		}

		// 更新字段
		if err := global.GVA_DB.Model(&log).Updates(updates).Error; err != nil {
			global.GVA_LOG.Error("更新远程验光日志失败", zap.Error(err))
		}
	}()
}
