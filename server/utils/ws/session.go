package ws

import (
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// SessionInfo 会话信息
type SessionInfo struct {
	SessionState          *SessionState
	MainControlConnection *string
	ControlledConnection  *string
	MainControlUserID     *int64
	ControlledUserID      *int64
	CreatedAt             int64
	PendingControlRequest *PendingControlRequest
	IsControlActive       bool
	mu                    sync.RWMutex
}

// IsFull 检查会话是否已满员
func (s *SessionInfo) IsFull() bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.MainControlConnection != nil && s.ControlledConnection != nil
}

// GetConnection 获取指定角色的连接ID
func (s *SessionInfo) GetConnection(role ClientRole) *string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	switch role {
	case RoleMainControl:
		return s.MainControlConnection
	case RoleControlled:
		return s.ControlledConnection
	}
	return nil
}

// SetConnection 设置角色连接ID
func (s *SessionInfo) SetConnection(role ClientRole, connectionID string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	switch role {
	case RoleMainControl:
		s.MainControlConnection = &connectionID
	case RoleControlled:
		s.ControlledConnection = &connectionID
	}
}

// RemoveConnection 移除指定角色的连接
func (s *SessionInfo) RemoveConnection(role *ClientRole) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if role == nil {
		return
	}
	switch *role {
	case RoleMainControl:
		s.MainControlConnection = nil
	case RoleControlled:
		s.ControlledConnection = nil
	}
}

// TerminateResult 终止会话的结果
type TerminateResult struct {
	Reason            string
	OtherConnectionID *string
}

// tokenData Token数据
type tokenData struct {
	SessionID string
	Role      ClientRole
	CreatedAt int64
}

// IsExpired 检查token是否过期
func (t *tokenData) IsExpired(expireMillis int64) bool {
	return time.Now().UnixMilli()-t.CreatedAt > expireMillis
}

// SessionManager 会话管理器
type SessionManager struct {
	sessions        map[string]*SessionInfo
	tokenInfo       map[string]*tokenData
	mu              sync.RWMutex
	tokenExpireMs   int64
	sessionMaxAgeMs int64
}

// NewSessionManager 创建会话管理器
func NewSessionManager(tokenExpireMs, sessionMaxAgeMs int64) *SessionManager {
	return &SessionManager{
		sessions:        make(map[string]*SessionInfo),
		tokenInfo:       make(map[string]*tokenData),
		tokenExpireMs:   tokenExpireMs,
		sessionMaxAgeMs: sessionMaxAgeMs,
	}
}

// generateSessionID 生成会话ID
func (sm *SessionManager) generateSessionID() string {
	return "session_" + uuid.New().String()
}

// generateToken 生成token
func (sm *SessionManager) generateToken() string {
	return "token_" + uuid.New().String()
}

// CreateSession 创建新会话
func (sm *SessionManager) CreateSession(role ClientRole) *CreateSessionResponseData {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	sessionID := sm.generateSessionID()
	token := sm.generateToken()
	timestamp := time.Now().UnixMilli()

	// 创建初始会话状态
	initialState := NewSessionState(sessionID)

	// 创建会话信息
	sessionInfo := &SessionInfo{
		SessionState:    initialState,
		CreatedAt:       timestamp,
		IsControlActive: false,
	}

	// 保存会话
	sm.sessions[sessionID] = sessionInfo

	// 保存token信息
	sm.tokenInfo[token] = &tokenData{
		SessionID: sessionID,
		Role:      role,
		CreatedAt: timestamp,
	}

	global.GVA_LOG.Info("创建WebSocket会话",
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)))

	return &CreateSessionResponseData{
		SessionID:    sessionID,
		Token:        token,
		InitialState: *initialState,
	}
}

// JoinSession 加入会话
func (sm *SessionManager) JoinSession(token string, role ClientRole, currentState *SessionState, connectionID string) (*JoinSessionResponseData, error) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	// 验证token
	tokenData, ok := sm.tokenInfo[token]
	if !ok {
		return nil, &SecurityError{Message: "Invalid token"}
	}

	// 检查token是否过期
	if tokenData.IsExpired(sm.tokenExpireMs) {
		delete(sm.tokenInfo, token)
		return nil, &SecurityError{Message: "Token expired"}
	}

	// 检查角色是否匹配
	if tokenData.Role != role {
		return nil, &SecurityError{Message: "Role mismatch"}
	}

	sessionID := tokenData.SessionID
	sessionInfo, ok := sm.sessions[sessionID]
	if !ok {
		return nil, &StateError{Message: "Session not found"}
	}

	// 检查该角色是否已经连接
	if sessionInfo.GetConnection(role) != nil {
		return nil, &StateError{Message: "Role already connected"}
	}

	// 设置连接
	sessionInfo.SetConnection(role, connectionID)

	// 如果是被控端加入且上报了当前状态，则合并状态（保留新会话的 sessionId 和 version）
	if role == RoleControlled && currentState != nil {
		// 合并状态：保留新会话的 sessionId 和 version，只更新 lens、device、meta
		mergedState := *sessionInfo.SessionState
		mergedState.Lens = currentState.Lens
		mergedState.Device = currentState.Device
		if currentState.Meta.UpdatedAt > 0 {
			mergedState.Meta = currentState.Meta
		}
		sessionInfo.SessionState = &mergedState
	}

	global.GVA_LOG.Info("加入WebSocket会话",
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)),
		zap.String("connectionId", connectionID))

	return &JoinSessionResponseData{
		SessionID:    sessionID,
		SessionState: *sessionInfo.SessionState,
	}, nil
}

// JoinSessionSimple Demo 模式：直接通过 sessionId 加入会话
func (sm *SessionManager) JoinSessionSimple(sessionID string, role ClientRole, currentState *SessionState, connectionID string, userID *int64) (*JoinSessionResponseData, error) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	sessionInfo, exists := sm.sessions[sessionID]

	if !exists {
		// 会话不存在，自动创建
		timestamp := time.Now().UnixMilli()
		initialState := NewSessionState(sessionID)
		sessionInfo = &SessionInfo{
			SessionState:    initialState,
			CreatedAt:       timestamp,
			IsControlActive: false,
		}
		sm.sessions[sessionID] = sessionInfo
		global.GVA_LOG.Info("自动创建WebSocket会话", zap.String("sessionId", sessionID))
	}

	// 检查该角色是否已经连接
	if existingConn := sessionInfo.GetConnection(role); existingConn != nil {
		global.GVA_LOG.Info("角色已连接，将踢掉旧连接",
			zap.String("sessionId", sessionID),
			zap.String("role", string(role)))
	}
	sessionInfo.SetConnection(role, connectionID)

	// 记录用户ID
	switch role {
	case RoleMainControl:
		sessionInfo.MainControlUserID = userID
	case RoleControlled:
		sessionInfo.ControlledUserID = userID
	}

	// 如果是被控端加入且上报了当前状态，则合并状态（保留新会话的 sessionId 和 version）
	if role == RoleControlled && currentState != nil {
		mergedState := *sessionInfo.SessionState
		mergedState.Lens = currentState.Lens
		mergedState.Device = currentState.Device
		if currentState.Meta.UpdatedAt > 0 {
			mergedState.Meta = currentState.Meta
		}
		sessionInfo.SessionState = &mergedState
	}

	global.GVA_LOG.Info("加入WebSocket会话成功",
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)),
		zap.String("connectionId", connectionID))

	return &JoinSessionResponseData{
		SessionID:    sessionID,
		SessionState: *sessionInfo.SessionState,
	}, nil
}

// GetSessionState 获取会话状态
func (sm *SessionManager) GetSessionState(sessionID string) *SessionState {
	sm.mu.RLock()
	defer sm.mu.RUnlock()
	if info, ok := sm.sessions[sessionID]; ok {
		return info.SessionState
	}
	return nil
}

// UpdateSessionState 更新会话状态
func (sm *SessionManager) UpdateSessionState(sessionID string, newState *SessionState) {
	sm.mu.Lock()
	defer sm.mu.Unlock()
	if info, ok := sm.sessions[sessionID]; ok {
		info.SessionState = newState
		global.GVA_LOG.Info("更新会话状态",
			zap.String("sessionId", sessionID),
			zap.Int64("version", newState.Version))
	}
}

// IncrementVersion 增加会话版本号
func (sm *SessionManager) IncrementVersion(sessionID string) (int64, error) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	sessionInfo, ok := sm.sessions[sessionID]
	if !ok {
		return 0, &StateError{Message: "Session not found: " + sessionID}
	}

	newVersion := sessionInfo.SessionState.Version + 1
	sessionInfo.SessionState.Version = newVersion
	sessionInfo.SessionState.Meta.UpdatedAt = time.Now().UnixMilli()

	return newVersion, nil
}

// GetSessionInfo 获取会话信息
func (sm *SessionManager) GetSessionInfo(sessionID string) *SessionInfo {
	sm.mu.RLock()
	defer sm.mu.RUnlock()
	return sm.sessions[sessionID]
}

// GetConnectionID 获取指定角色的连接ID
func (sm *SessionManager) GetConnectionID(sessionID string, role ClientRole) *string {
	sm.mu.RLock()
	defer sm.mu.RUnlock()
	if info, ok := sm.sessions[sessionID]; ok {
		return info.GetConnection(role)
	}
	return nil
}

// RemoveConnection 移除会话中的连接
func (sm *SessionManager) RemoveConnection(connectionID string) []string {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	affectedSessions := []string{}

	for sessionID, sessionInfo := range sm.sessions {
		modified := false

		if sessionInfo.MainControlConnection != nil && *sessionInfo.MainControlConnection == connectionID {
			sessionInfo.MainControlConnection = nil
			modified = true
		}

		if sessionInfo.ControlledConnection != nil && *sessionInfo.ControlledConnection == connectionID {
			sessionInfo.ControlledConnection = nil
			modified = true
		}

		if modified {
			affectedSessions = append(affectedSessions, sessionID)
			// 如果连接断开，标记远控会话为非活跃状态
			if sessionInfo.IsControlActive {
				sessionInfo.IsControlActive = false
				global.GVA_LOG.Info("连接断开，标记远控会话为非活跃",
					zap.String("sessionId", sessionID),
					zap.String("connectionId", connectionID))
			}
			// 清理等待中的远控请求
			if sessionInfo.PendingControlRequest != nil {
				sessionInfo.PendingControlRequest = nil
				global.GVA_LOG.Info("清理等待中的远控请求",
					zap.String("sessionId", sessionID),
					zap.String("connectionId", connectionID))
			}
		}
	}

	return affectedSessions
}

// TerminateSession 终止会话
func (sm *SessionManager) TerminateSession(sessionID string, role ClientRole) (*TerminateResult, error) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	sessionInfo, ok := sm.sessions[sessionID]
	if !ok {
		return nil, &StateError{Message: "Session not found: " + sessionID}
	}

	// 获取对方的连接ID
	var otherRole ClientRole
	switch role {
	case RoleMainControl:
		otherRole = RoleControlled
	case RoleControlled:
		otherRole = RoleMainControl
	}
	otherConnectionID := sessionInfo.GetConnection(otherRole)

	// 移除指定角色的连接
	sessionInfo.RemoveConnection(&role)

	// 标记会话为非活跃状态
	sessionInfo.IsControlActive = false

	reason := ""
	switch role {
	case RoleControlled:
		reason = "CONTROLLED_EXIT"
	case RoleMainControl:
		reason = "MAIN_CONTROL_EXIT"
	}

	global.GVA_LOG.Info("终止WebSocket会话",
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)),
		zap.String("reason", reason))

	return &TerminateResult{
		Reason:            reason,
		OtherConnectionID: otherConnectionID,
	}, nil
}

// CleanupExpiredSessions 清理过期会话
func (sm *SessionManager) CleanupExpiredSessions() int {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	now := time.Now().UnixMilli()
	expiredKeys := []string{}

	for sessionID, info := range sm.sessions {
		if now-info.CreatedAt > sm.sessionMaxAgeMs {
			expiredKeys = append(expiredKeys, sessionID)
		}
	}

	for _, sessionID := range expiredKeys {
		delete(sm.sessions, sessionID)
		// 清理相关token
		for token, td := range sm.tokenInfo {
			if td.SessionID == sessionID {
				delete(sm.tokenInfo, token)
			}
		}
	}

	if len(expiredKeys) > 0 {
		global.GVA_LOG.Info("清理过期WebSocket会话", zap.Int("count", len(expiredKeys)))
	}

	return len(expiredKeys)
}

// SetPendingControlRequest 设置等待中的远控请求
func (sm *SessionManager) SetPendingControlRequest(sessionID string, request *PendingControlRequest) {
	sm.mu.Lock()
	defer sm.mu.Unlock()
	if info, ok := sm.sessions[sessionID]; ok {
		info.PendingControlRequest = request
		global.GVA_LOG.Info("设置等待中的远控请求",
			zap.String("sessionId", sessionID),
			zap.String("controlledConnection", request.ControlledConnectionID))
	}
}

// GetPendingControlRequest 获取等待中的远控请求
func (sm *SessionManager) GetPendingControlRequest(sessionID string) *PendingControlRequest {
	sm.mu.RLock()
	defer sm.mu.RUnlock()
	if info, ok := sm.sessions[sessionID]; ok {
		return info.PendingControlRequest
	}
	return nil
}

// ClearPendingControlRequest 清除等待中的远控请求
func (sm *SessionManager) ClearPendingControlRequest(sessionID string) {
	sm.mu.Lock()
	defer sm.mu.Unlock()
	if info, ok := sm.sessions[sessionID]; ok {
		info.PendingControlRequest = nil
		global.GVA_LOG.Info("清除等待中的远控请求", zap.String("sessionId", sessionID))
	}
}

// FindMainControlConnection 查找可用的主控端连接
func (sm *SessionManager) FindMainControlConnection(excludeUserID *int64, getActiveMainControls func(*int64) []string) *string {
	// 优先使用外部提供的查找方法
	if getActiveMainControls != nil {
		mainControls := getActiveMainControls(excludeUserID)
		if len(mainControls) > 0 {
			return &mainControls[0]
		}
	}

	// 回退：遍历所有会话
	sm.mu.RLock()
	defer sm.mu.RUnlock()

	for _, info := range sm.sessions {
		if info.MainControlConnection != nil {
			if excludeUserID != nil && info.MainControlUserID != nil && *info.MainControlUserID == *excludeUserID {
				continue
			}
			return info.MainControlConnection
		}
	}
	return nil
}

// IsInActiveSession 检查用户是否已在活跃的远程控制会话中
func (sm *SessionManager) IsInActiveSession(userID *int64, role ClientRole) *string {
	if userID == nil {
		return nil
	}

	sm.mu.RLock()
	defer sm.mu.RUnlock()

	for sessionID, info := range sm.sessions {
		if info.IsControlActive {
			switch role {
			case RoleMainControl:
				if info.MainControlUserID != nil && *info.MainControlUserID == *userID {
					global.GVA_LOG.Info("主控端已在活跃远控会话中",
						zap.Int64("userId", *userID),
						zap.String("sessionId", sessionID))
					return &sessionID
				}
			case RoleControlled:
				if info.ControlledUserID != nil && *info.ControlledUserID == *userID {
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

// SetControlActive 标记会话为活跃的远控会话
func (sm *SessionManager) SetControlActive(sessionID string) {
	sm.mu.Lock()
	defer sm.mu.Unlock()
	if info, ok := sm.sessions[sessionID]; ok {
		info.IsControlActive = true
		global.GVA_LOG.Info("设置会话为活跃远控状态", zap.String("sessionId", sessionID))
	}
}

// SetControlInactive 标记会话为非活跃
func (sm *SessionManager) SetControlInactive(sessionID string) {
	sm.mu.Lock()
	defer sm.mu.Unlock()
	if info, ok := sm.sessions[sessionID]; ok {
		info.IsControlActive = false
		global.GVA_LOG.Info("设置会话为非活跃状态", zap.String("sessionId", sessionID))
	}
}

// SecurityError 安全错误
type SecurityError struct {
	Message string
}

func (e *SecurityError) Error() string {
	return e.Message
}

// StateError 状态错误
type StateError struct {
	Message string
}

func (e *StateError) Error() string {
	return e.Message
}

// GetStats 获取会话统计信息
func (sm *SessionManager) GetStats() map[string]interface{} {
	sm.mu.RLock()
	defer sm.mu.RUnlock()

	var sessions []map[string]interface{}
	for sessionID, info := range sm.sessions {
		info.mu.RLock()
		sessionData := map[string]interface{}{
			"sessionId":       sessionID,
			"hasMainControl":  info.MainControlConnection != nil,
			"hasControlled":   info.ControlledConnection != nil,
			"isControlActive": info.IsControlActive,
			"createdAt":       info.CreatedAt,
		}
		if info.MainControlUserID != nil {
			sessionData["mainControlUserId"] = *info.MainControlUserID
		}
		if info.ControlledUserID != nil {
			sessionData["controlledUserId"] = *info.ControlledUserID
		}
		if info.SessionState != nil {
			sessionData["version"] = info.SessionState.Version
		}
		info.mu.RUnlock()
		sessions = append(sessions, sessionData)
	}

	return map[string]interface{}{
		"totalSessions": len(sm.sessions),
		"sessions":      sessions,
	}
}
