package ws

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// MessageHandlers 消息处理器
type MessageHandlers struct {
	sessionManager     *SessionManager
	connectionManager  *ConnectionManager
	transactionManager *TransactionManager
	rtcGenerator       *RtcTokenGenerator
	applyTimeoutMs     int64
}

// NewMessageHandlers 创建消息处理器
func NewMessageHandlers(
	sm *SessionManager,
	cm *ConnectionManager,
	tm *TransactionManager,
	applyTimeoutMs int64,
	rtcGen *RtcTokenGenerator,
) *MessageHandlers {
	return &MessageHandlers{
		sessionManager:     sm,
		connectionManager:  cm,
		transactionManager: tm,
		rtcGenerator:       rtcGen,
		applyTimeoutMs:     applyTimeoutMs,
	}
}

// HandleCreateSession 处理创建会话请求
func (h *MessageHandlers) HandleCreateSession(connectionID string, msg *SocketMessage) *SocketMessage {
	var createData CreateSessionData
	if msg.Data != nil {
		if err := json.Unmarshal(*msg.Data, &createData); err != nil {
			return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
		}
	} else {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 创建会话
	response := h.sessionManager.CreateSession(createData.Role)

	// 绑定连接到会话
	h.connectionManager.BindToSession(connectionID, response.SessionID, createData.Role)

	global.GVA_LOG.Info("创建会话成功",
		zap.String("connectionId", connectionID),
		zap.String("sessionId", response.SessionID),
		zap.String("role", string(createData.Role)))

	// 构建响应消息
	data, _ := json.Marshal(response)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdCreateSession,
		SessionID: &response.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Data:      &rawData,
	}
}

// HandleJoinSession 处理加入会话请求
// 服务端根据连接建立时已查询的 userType 和 storeId 自行决定角色和会话，不依赖客户端传参
func (h *MessageHandlers) HandleJoinSession(connectionID string, msg *SocketMessage) *SocketMessage {
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "连接未找到")
	}

	if connInfo.StoreId == "" {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "门店信息缺失，无法确定会话")
	}

	// 根据 userType 决定角色
	// optometrist(验光师) → MAIN_CONTROL，manager/customer → CONTROLLED
	var role ClientRole
	switch connInfo.UserType {
	case "optometrist":
		role = RoleMainControl
	default:
		role = RoleControlled
	}

	// 根据 storeId 构造 sessionId
	sessionID := "store_" + connInfo.StoreId

	global.GVA_LOG.Info("加入会话（服务端判断角色）",
		zap.String("connectionId", connectionID),
		zap.String("userType", connInfo.UserType),
		zap.String("storeId", connInfo.StoreId),
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)))

	// 解析客户端上报的当前状态（如果有）
	var currentState *SessionState
	if msg.Data != nil {
		var joinData JoinSessionData
		if err := json.Unmarshal(*msg.Data, &joinData); err == nil {
			currentState = joinData.CurrentState
		}
	}

	var userID *int64
	if connInfo != nil {
		userID = connInfo.UserID
	}
	response, err := h.sessionManager.JoinSessionSimple(sessionID, role, currentState, connectionID, userID)

	if err != nil {
		global.GVA_LOG.Error("加入会话失败",
			zap.String("connectionId", connectionID),
			zap.String("sessionId", sessionID),
			zap.String("role", string(role)),
			zap.Error(err))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, err.Error())
	}

	// 绑定连接到会话
	h.connectionManager.BindToSession(connectionID, response.SessionID, role)

	global.GVA_LOG.Info("加入会话成功",
		zap.String("connectionId", connectionID),
		zap.String("sessionId", response.SessionID),
		zap.String("role", string(role)))

	// 构建响应消息
	data, _ := json.Marshal(response)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdJoinSession,
		SessionID: &response.SessionID,
		TxnID:     msg.TxnID,
		Role:      &role,
		Data:      &rawData,
	}
}

// HandleCommandPatch 处理命令补丁
// 使用服务端记录的连接角色做鉴权
func (h *MessageHandlers) HandleCommandPatch(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.TxnID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing txnId")
	}
	if msg.Data == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 从服务端获取连接的真实角色做权限检查
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil || connInfo.Role == nil || *connInfo.Role != RoleMainControl {
		role := "unknown"
		if connInfo != nil && connInfo.Role != nil {
			role = string(*connInfo.Role)
		}
		global.GVA_LOG.Warn("未授权的命令（服务端角色检查）",
			zap.String("connectionId", connectionID),
			zap.String("role", role))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有主控端可以发送命令")
	}
	serverRole := *connInfo.Role

	var commandData CommandPatchData
	if err := json.Unmarshal(*msg.Data, &commandData); err != nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
	}

	// 幂等性检查
	if h.transactionManager.Exists(*msg.TxnID) {
		global.GVA_LOG.Info("事务已处理", zap.String("txnId", *msg.TxnID))
		return nil
	}

	// 开始事务（使用客户端提供的 txnID）
	h.transactionManager.BeginTransaction(*msg.TxnID, *msg.SessionID, serverRole, &commandData)
	h.transactionManager.MarkApplying(*msg.TxnID)

	// 获取被控端连接
	controlledConnID := h.connectionManager.GetConnectionByRole(*msg.SessionID, RoleControlled)
	if controlledConnID == nil {
		global.GVA_LOG.Warn("被控端未连接", zap.String("sessionId", *msg.SessionID))
		return nil
	}

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
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Version:   commandData.ExpectedVersion,
	}
	applyDataBytes, _ := json.Marshal(applyData)
	rawData := json.RawMessage(applyDataBytes)
	applyMsg.Data = &rawData

	global.GVA_LOG.Info("转发命令到被控端",
		zap.String("sessionId", *msg.SessionID),
		zap.String("txnId", *msg.TxnID),
		zap.Int("opsCount", len(commandData.Ops)))

	// 发送给被控端
	msgBytes, _ := applyMsg.ToJSON()
	h.connectionManager.SendToConnection(*controlledConnID, msgBytes)

	// 启动超时检查
	go h.startApplyTimeoutCheck(*msg.SessionID, *msg.TxnID, *controlledConnID)

	return nil
}

// HandleAck 处理 ACK
func (h *MessageHandlers) HandleAck(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.TxnID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing txnId")
	}
	if msg.Data == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 从服务端获取连接的真实角色做权限检查
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil || connInfo.Role == nil || *connInfo.Role != RoleControlled {
		role := "unknown"
		if connInfo != nil && connInfo.Role != nil {
			role = string(*connInfo.Role)
		}
		global.GVA_LOG.Warn("未授权的ack（服务端角色检查）",
			zap.String("connectionId", connectionID),
			zap.String("role", role))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有被控端可以发送ack")
	}

	var ackData AckData
	if err := json.Unmarshal(*msg.Data, &ackData); err != nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
	}

	// 完成事务
	h.transactionManager.CompleteTransaction(*msg.TxnID, &ackData)

	// 更新会话版本号
	newVersion, _ := h.sessionManager.IncrementVersion(*msg.SessionID)

	// 获取被控端应用的 ops
	var ops []PatchOperation
	if ackData.Success && ackData.AppliedOps != nil {
		ops = ackData.AppliedOps
	} else {
		// 如果失败，尝试从事务记录中获取原始 ops
		txn := h.transactionManager.GetTransaction(*msg.TxnID)
		if txn != nil && txn.CommandData != nil {
			ops = txn.CommandData.Ops
		}
	}

	// 构建 PatchApplied 消息
	patchAppliedData := PatchAppliedData{
		NewVersion: newVersion,
		Success:    ackData.Success,
		DeviceSend: ackData.DeviceSend,
		Ops:        ops,
	}
	if !ackData.Success {
		patchAppliedData.Error = ackData.Error
	}

	patchAppliedMsg := SocketMessage{
		Cmd:       CmdPatchApplied,
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Version:   &newVersion,
	}
	patchAppliedBytes, _ := json.Marshal(patchAppliedData)
	rawData := json.RawMessage(patchAppliedBytes)
	patchAppliedMsg.Data = &rawData

	global.GVA_LOG.Info("处理ack完成",
		zap.String("sessionId", *msg.SessionID),
		zap.String("txnId", *msg.TxnID),
		zap.Bool("success", ackData.Success),
		zap.Int64("newVersion", newVersion))

	// 发送给主控端
	mainControlConnID := h.connectionManager.GetConnectionByRole(*msg.SessionID, RoleMainControl)
	if mainControlConnID != nil {
		msgBytes, _ := patchAppliedMsg.ToJSON()
		h.connectionManager.SendToConnection(*mainControlConnID, msgBytes)
	}

	return nil
}

// HandleSessionTerminate 处理会话终止
// 使用服务端记录的连接角色，不依赖客户端msg.Role
func (h *MessageHandlers) HandleSessionTerminate(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.TxnID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing txnId")
	}

	// 从服务端获取连接的真实角色
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil || connInfo.Role == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing role")
	}
	serverRole := *connInfo.Role

	// 终止会话
	result, err := h.sessionManager.TerminateSession(*msg.SessionID, serverRole)
	if err != nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, err.Error())
	}

	global.GVA_LOG.Info("会话已终止",
		zap.String("sessionId", *msg.SessionID),
		zap.String("role", string(serverRole)),
		zap.String("reason", result.Reason))

	// 解除发起者的会话绑定
	h.connectionManager.UnbindFromSession(connectionID)

	// 构建 SessionTerminated 消息
	terminatedData := SessionTerminateData{Reason: result.Reason}
	terminatedMsg := SocketMessage{
		Cmd:       CmdSessionTerminated,
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Role:      &serverRole,
	}
	terminatedBytes, _ := json.Marshal(terminatedData)
	rawData := json.RawMessage(terminatedBytes)
	terminatedMsg.Data = &rawData

	// 发送给另一端
	if result.OtherConnectionID != nil {
		msgBytes, _ := terminatedMsg.ToJSON()
		h.connectionManager.SendToConnection(*result.OtherConnectionID, msgBytes)
		// 延迟解除另一端的绑定
		time.Sleep(100 * time.Millisecond)
		h.connectionManager.UnbindFromSession(*result.OtherConnectionID)
	}

	return nil
}

// HandleHeartbeat 处理心跳请求
func (h *MessageHandlers) HandleHeartbeat(connectionID string, msg *SocketMessage) *SocketMessage {
	// 更新连接心跳时间
	h.connectionManager.UpdateHeartbeat(connectionID)

	var heartbeatData HeartbeatData
	if msg.Data != nil {
		json.Unmarshal(*msg.Data, &heartbeatData)
	}

	// 构建心跳响应
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

// HandleControlRequest 处理远控请求
// 使用服务端记录的连接角色做鉴权
func (h *MessageHandlers) HandleControlRequest(connectionID string, msg *SocketMessage) *SocketMessage {
	// 从服务端获取连接的真实角色做权限检查
	connCheck := h.connectionManager.GetConnectionInfo(connectionID)
	if connCheck == nil || connCheck.Role == nil || *connCheck.Role != RoleControlled {
		role := "unknown"
		if connCheck != nil && connCheck.Role != nil {
			role = string(*connCheck.Role)
		}
		global.GVA_LOG.Warn("未授权的远控请求（服务端角色检查）",
			zap.String("connectionId", connectionID),
			zap.String("role", role))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有被控端可以发起远控请求")
	}

	var requestData ControlRequestData
	if msg.Data != nil {
		json.Unmarshal(*msg.Data, &requestData)
	}

	// 获取被控端用户ID和门店信息
	var controlledUserID *int64
	var controlledStoreId string
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo != nil {
		controlledUserID = connInfo.UserID
		controlledStoreId = connInfo.StoreId
	}

	// 检查用户身份：验光师不能发起远控请求
	if controlledUserID != nil {
		var member struct {
			Post int64 `gorm:"column:post"`
		}
		// 查询mx_store_member表获取用户职位
		if err := global.GVA_DB.Table("mx_store_member").
			Where("user_id = ? AND is_delete = ?", *controlledUserID, 0).
			Select("post").
			First(&member).Error; err == nil {
			// post: 1店长, 2验光师, 3顾客
			if member.Post == 2 { // 验光师
				global.GVA_LOG.Warn("验光师不允许发起远控请求",
					zap.Int64("userId", *controlledUserID),
					zap.Int64("post", member.Post))
				return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "验光师不允许发起远程验光请求")
			}
		} else {
			global.GVA_LOG.Warn("查询用户门店成员信息失败",
				zap.Int64("userId", *controlledUserID),
				zap.Error(err))
			// 如果查询失败，为了安全起见，不允许发起请求
			return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "无法验证用户身份，不允许发起远程验光请求")
		}
	}

	// 检查是否已在活跃会话中
	existingSessionID := h.sessionManager.IsInActiveSession(controlledUserID, RoleControlled)
	if existingSessionID != nil {
		global.GVA_LOG.Warn("被控端已在活跃远控会话中",
			zap.Int64("controlledUserId", *controlledUserID),
			zap.String("existingSessionId", *existingSessionID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "您已在远程验光会话中，请先结束当前会话")
	}

	// 查找主控端（优先按门店隔离查找）
	var mainControlConnID *string
	if controlledStoreId != "" {
		// 门店隔离：优先查找同门店的主控端
		mainControls := h.connectionManager.FindMainControlConnectionsByStore(controlledStoreId, controlledUserID)
		if len(mainControls) > 0 {
			mainControlConnID = &mainControls[0]
			global.GVA_LOG.Info("按门店隔离找到主控端",
				zap.String("storeId", controlledStoreId),
				zap.String("mainControlConnId", *mainControlConnID))
		}
	}
	if mainControlConnID == nil {
		// 回退：查找所有主控端
		mainControlConnID = h.sessionManager.FindMainControlConnection(controlledUserID, h.connectionManager.FindAllMainControlConnections)
	}

	if mainControlConnID == nil {
		global.GVA_LOG.Warn("主控端未连接", zap.Int64("controlledUserId", *controlledUserID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "主控端未连接，无法发起远控请求")
	}

	// 检查主控端是否已在活跃会话中
	var mainControlUserID *int64
	mainConnInfo := h.connectionManager.GetConnectionInfo(*mainControlConnID)
	if mainConnInfo != nil {
		mainControlUserID = mainConnInfo.UserID
	}
	mainExistingSessionID := h.sessionManager.IsInActiveSession(mainControlUserID, RoleMainControl)
	if mainExistingSessionID != nil {
		global.GVA_LOG.Warn("主控端已在活跃会话中",
			zap.Int64("mainControlUserId", *mainControlUserID),
			zap.String("existingSessionId", *mainExistingSessionID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "验光师正在其他远程验光会话中，请稍后再试")
	}

	// 保存被控端旧会话的状态（在清理绑定之前获取）
	var controlledCurrentState *SessionState
	if connInfo != nil && connInfo.SessionID != nil {
		oldState := h.sessionManager.GetSessionState(*connInfo.SessionID)
		if oldState != nil {
			controlledCurrentState = &SessionState{
				SessionID: oldState.SessionID,
				Version:   oldState.Version,
				Lens:      oldState.Lens,
				Device:    oldState.Device,
				Meta:      oldState.Meta,
			}
			global.GVA_LOG.Info("保存被控端旧会话状态",
				zap.String("connectionId", connectionID),
				zap.String("oldSessionId", *connInfo.SessionID),
				zap.Any("lens", oldState.Lens))
		}
	}

	// 清理双方之前的非活跃会话绑定
	if connInfo != nil && connInfo.SessionID != nil {
		global.GVA_LOG.Info("清理被控端旧会话绑定",
			zap.String("connectionId", connectionID),
			zap.String("oldSessionId", *connInfo.SessionID))
		h.connectionManager.UnbindFromSession(connectionID)
	}
	if mainConnInfo != nil && mainConnInfo.SessionID != nil {
		global.GVA_LOG.Info("清理主控端旧会话绑定",
			zap.String("connectionId", *mainControlConnID),
			zap.String("oldSessionId", *mainConnInfo.SessionID))
		h.connectionManager.UnbindFromSession(*mainControlConnID)
	}

	// 生成唯一 sessionId
	sessionID := h.generateUniqueSessionID()

	// 为双方绑定新会话（携带旧会话状态）
	h.sessionManager.JoinSessionSimple(sessionID, RoleControlled, controlledCurrentState, connectionID, controlledUserID)
	h.connectionManager.BindToSession(connectionID, sessionID, RoleControlled)

	h.sessionManager.JoinSessionSimple(sessionID, RoleMainControl, nil, *mainControlConnID, mainControlUserID)
	h.connectionManager.BindToSession(*mainControlConnID, sessionID, RoleMainControl)

	global.GVA_LOG.Info("为双方绑定新会话",
		zap.String("sessionId", sessionID),
		zap.String("controlled", connectionID),
		zap.String("mainControl", *mainControlConnID))

	// 保存等待中的请求
	h.sessionManager.SetPendingControlRequest(sessionID, &PendingControlRequest{
		ControlledConnectionID: connectionID,
		DeviceInfo:             requestData.DeviceInfo,
		Message:                requestData.Message,
	})

	// 转发请求给主控端
	forwardMsg := SocketMessage{
		Cmd:       CmdControlRequest,
		SessionID: &sessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Data:      msg.Data,
	}
	msgBytes, _ := forwardMsg.ToJSON()
	h.connectionManager.SendToConnection(*mainControlConnID, msgBytes)

	global.GVA_LOG.Info("转发远控请求给主控端",
		zap.String("sessionId", sessionID),
		zap.String("controlledConnection", connectionID),
		zap.String("mainControlConnection", *mainControlConnID))

	return nil
}

// HandleControlResponse 处理远控响应
// 使用服务端记录的连接角色做鉴权
func (h *MessageHandlers) HandleControlResponse(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}
	if msg.Data == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing data")
	}

	// 从服务端获取连接的真实角色做权限检查
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil || connInfo.Role == nil || *connInfo.Role != RoleMainControl {
		role := "unknown"
		if connInfo != nil && connInfo.Role != nil {
			role = string(*connInfo.Role)
		}
		global.GVA_LOG.Warn("未授权的远控响应（服务端角色检查）",
			zap.String("connectionId", connectionID),
			zap.String("role", role))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有主控端可以响应远控请求")
	}

	var responseData ControlResponseData
	if err := json.Unmarshal(*msg.Data, &responseData); err != nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Invalid data format")
	}

	// 获取等待中的请求
	pendingRequest := h.sessionManager.GetPendingControlRequest(*msg.SessionID)
	if pendingRequest == nil {
		global.GVA_LOG.Warn("没有等待中的远控请求", zap.String("sessionId", *msg.SessionID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "没有等待中的远控请求")
	}

	// 清除等待中的请求
	h.sessionManager.ClearPendingControlRequest(*msg.SessionID)

	if responseData.Accept {
		// 同意远控
		global.GVA_LOG.Info("主控端同意远控",
			zap.String("sessionId", *msg.SessionID),
			zap.String("controlledConnection", pendingRequest.ControlledConnectionID))

		// 标记会话为活跃远控状态
		h.sessionManager.SetControlActive(*msg.SessionID)

		// 一次性生成主控端和被控端的 RTC 配置（确保使用相同的 baseUID）
		rtcConfigForMain, rtcConfigForControlled := h.generateRtcConfigPair(*msg.SessionID)

		// 检查RTC配置是否有效
		if rtcConfigForMain == nil || rtcConfigForControlled == nil || rtcConfigForMain.Token == "" || rtcConfigForControlled.Token == "" {
			global.GVA_LOG.Error("生成RTC配置失败",
				zap.String("sessionId", *msg.SessionID),
				zap.Any("rtcConfigForMain", rtcConfigForMain),
				zap.Any("rtcConfigForControlled", rtcConfigForControlled))

			// 清理会话状态
			h.sessionManager.SetControlInactive(*msg.SessionID)
			h.sessionManager.ClearPendingControlRequest(*msg.SessionID)
			h.connectionManager.UnbindFromSession(connectionID)
			h.connectionManager.UnbindFromSession(pendingRequest.ControlledConnectionID)

			return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "声网音视频配置错误，无法建立远控连接")
		}

		// 获取当前会话状态
		currentSessionState := h.sessionManager.GetSessionState(*msg.SessionID)

		// 通知被控端
		acceptedDataForControlled := ControlAcceptedData{
			MainControlInfo: strPtr("主控端已同意"),
			Message:         responseData.Message,
			RtcConfig:       rtcConfigForControlled,
		}
		acceptedMsg := SocketMessage{
			Cmd:       CmdControlAccepted,
			SessionID: msg.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		acceptedBytes, _ := json.Marshal(acceptedDataForControlled)
		rawData := json.RawMessage(acceptedBytes)
		acceptedMsg.Data = &rawData

		msgBytes, _ := acceptedMsg.ToJSON()
		
		global.GVA_LOG.Info("准备发送消息给被控端",
			zap.String("sessionId", *msg.SessionID),
			zap.String("controlledConnectionId", pendingRequest.ControlledConnectionID),
			zap.String("cmd", string(CmdControlAccepted)),
			zap.String("messageJson", string(msgBytes)))
		
		h.connectionManager.SendToConnection(pendingRequest.ControlledConnectionID, msgBytes)

		global.GVA_LOG.Info("已通知被控端并返回 RTC 配置",
			zap.String("sessionId", *msg.SessionID))

		// 返回响应给主控端（包含当前会话状态）
		acceptedDataForMain := ControlAcceptedData{
			MainControlInfo: strPtr("已通知被控端"),
			Message:         strPtr("远控已建立"),
			RtcConfig:       rtcConfigForMain,
			SessionState:    currentSessionState,
		}
		responseMsg := SocketMessage{
			Cmd:       CmdControlResponse,
			SessionID: msg.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		responseBytes, _ := json.Marshal(acceptedDataForMain)
		rawData2 := json.RawMessage(responseBytes)
		responseMsg.Data = &rawData2

		responseJson, _ := responseMsg.ToJSON()
		global.GVA_LOG.Info("准备返回消息给主控端",
			zap.String("sessionId", *msg.SessionID),
			zap.String("cmd", string(CmdControlResponse)),
			zap.String("messageJson", string(responseJson)))

		return &responseMsg
	} else {
		// 拒绝远控
		global.GVA_LOG.Info("主控端拒绝远控",
			zap.String("sessionId", *msg.SessionID),
			zap.String("controlledConnection", pendingRequest.ControlledConnectionID))

		// 通知被控端
		rejectedData := ControlRejectedData{
			Reason:  "主控端拒绝",
			Message: responseData.Message,
		}
		rejectedMsg := SocketMessage{
			Cmd:       CmdControlRejected,
			SessionID: msg.SessionID,
			TxnID:     msg.TxnID,
			Role:      msg.Role,
		}
		rejectedBytes, _ := json.Marshal(rejectedData)
		rawData := json.RawMessage(rejectedBytes)
		rejectedMsg.Data = &rawData

		msgBytes, _ := rejectedMsg.ToJSON()
		h.connectionManager.SendToConnection(pendingRequest.ControlledConnectionID, msgBytes)

		// 解除双方的会话绑定
		h.connectionManager.UnbindFromSession(connectionID)
		h.connectionManager.UnbindFromSession(pendingRequest.ControlledConnectionID)

		// 清理会话状态
		h.sessionManager.SetControlInactive(*msg.SessionID)
		h.sessionManager.ClearPendingControlRequest(*msg.SessionID)

		global.GVA_LOG.Info("已拒绝远控请求，解除会话绑定", zap.String("sessionId", *msg.SessionID))

		return nil
	}
}

// HandleStateSync 处理状态同步（支持双向同步）
// 使用服务端记录的连接角色，不依赖客户端msg.Role
func (h *MessageHandlers) HandleStateSync(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}

	// 从服务端获取连接的真实角色
	connInfo := h.connectionManager.GetConnectionInfo(connectionID)
	if connInfo == nil || connInfo.Role == nil {
		global.GVA_LOG.Warn("状态同步缺少角色信息",
			zap.String("connectionId", connectionID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing role")
	}
	role := *connInfo.Role

	isMainControl := role == RoleMainControl
	isControlled := role == RoleControlled

	if !isMainControl && !isControlled {
		global.GVA_LOG.Warn("未授权的状态同步",
			zap.String("connectionId", connectionID),
			zap.String("role", string(role)))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未授权: 只有主控端或被控端可以发送状态同步")
	}

	global.GVA_LOG.Info("收到状态同步请求",
		zap.String("connectionId", connectionID),
		zap.String("sessionId", *msg.SessionID),
		zap.String("role", string(role)))

	// 如果提供了状态数据，更新会话状态
	if msg.Data != nil {
		var rawData map[string]interface{}
		if err := json.Unmarshal(*msg.Data, &rawData); err != nil {
			global.GVA_LOG.Warn("解析状态同步数据失败",
				zap.String("sessionId", *msg.SessionID),
				zap.Error(err))
		} else {
			// 检查是否是 ops 格式
			if ops, ok := rawData["ops"].([]interface{}); ok {
				// 处理 ops 格式的状态同步
				h.applyOpsToSessionState(*msg.SessionID, ops, isControlled)
			} else {
				// 处理 SessionState 格式或扁平格式
				var syncState SessionState
				if err := json.Unmarshal(*msg.Data, &syncState); err == nil {
					h.mergeSessionState(*msg.SessionID, &syncState, isControlled)
				} else {
					// 尝试扁平格式
					h.applyFlatState(*msg.SessionID, rawData, isControlled)
				}
			}
		}
	}

	// 双向转发状态同步
	var targetConnID *string
	var targetRole ClientRole
	if isControlled {
		targetRole = RoleMainControl
		targetConnID = h.connectionManager.GetConnectionByRole(*msg.SessionID, RoleMainControl)
		if targetConnID == nil {
			global.GVA_LOG.Warn("主控端未连接，无法转发状态同步", zap.String("sessionId", *msg.SessionID))
			return nil
		}
	} else {
		targetRole = RoleControlled
		targetConnID = h.connectionManager.GetConnectionByRole(*msg.SessionID, RoleControlled)
		if targetConnID == nil {
			global.GVA_LOG.Warn("被控端未连接，无法转发状态同步", zap.String("sessionId", *msg.SessionID))
			return nil
		}
	}

	// 转发状态同步给目标端（将 role 设为目标端的角色，客户端据此判断身份）
	forwardMsg := SocketMessage{
		Cmd:       msg.Cmd,
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Role:      &targetRole,
		Data:      msg.Data,
	}
	msgBytes, _ := forwardMsg.ToJSON()
	h.connectionManager.SendToConnection(*targetConnID, msgBytes)

	global.GVA_LOG.Info("转发状态同步",
		zap.String("sessionId", *msg.SessionID),
		zap.String("from", string(role)),
		zap.String("targetConnId", *targetConnID),
		zap.String("targetRole", string(targetRole)))

	return nil
}

// applyOpsToSessionState 应用 ops 格式的状态更新到会话状态
func (h *MessageHandlers) applyOpsToSessionState(sessionID string, ops []interface{}, fromControlled bool) {
	currentState := h.sessionManager.GetSessionState(sessionID)
	if currentState == nil {
		global.GVA_LOG.Warn("会话状态不存在，无法应用ops", zap.String("sessionId", sessionID))
		return
	}

	mergedState := *currentState
	hasUpdates := false

	for _, opInterface := range ops {
		op, ok := opInterface.(map[string]interface{})
		if !ok {
			continue
		}

		opType, _ := op["op"].(string)
		path, _ := op["path"].(string)
		if path == "" {
			path, _ = op["p"].(string)
		}
		value := op["v"]

		if opType != "set" && opType != "replace" {
			continue
		}

		// 解析路径并更新状态
		switch path {
		case "/lens/leftS", "lens/leftS", "/lens/leftS/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.LeftS = &v
				hasUpdates = true
			}
		case "/lens/rightS", "lens/rightS", "/lens/rightS/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.RightS = &v
				hasUpdates = true
			}
		case "/lens/leftC", "lens/leftC", "/lens/leftC/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.LeftC = &v
				hasUpdates = true
			}
		case "/lens/rightC", "lens/rightC", "/lens/rightC/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.RightC = &v
				hasUpdates = true
			}
		case "/lens/leftA", "lens/leftA", "/lens/leftA/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.LeftA = &v
				hasUpdates = true
			}
		case "/lens/rightA", "lens/rightA", "/lens/rightA/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.RightA = &v
				hasUpdates = true
			}
		case "/lens/add", "lens/add", "/lens/add/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.Add = &v
				hasUpdates = true
			}
		case "/lens/pd", "lens/pd", "/lens/pd/":
			if v, ok := toFloat64(value); ok {
				mergedState.Lens.PD = &v
				hasUpdates = true
			}
		case "/lens/mode", "lens/mode", "/lens/mode/":
			if v, ok := value.(string); ok && v != "" {
				mergedState.Lens.Mode = LensMode(v)
				hasUpdates = true
			}
		case "/device/niuTouConnected", "device/niuTouConnected":
			if v, ok := value.(bool); ok {
				mergedState.Device.NiuTouConnected = v
				hasUpdates = true
			}
		}
	}

	if hasUpdates {
		if fromControlled {
			mergedState.Meta.Source = "CONTROLLED"
		} else {
			mergedState.Meta.Source = "MAIN_CONTROL"
		}
		mergedState.Meta.UpdatedAt = time.Now().UnixMilli()
		h.sessionManager.UpdateSessionState(sessionID, &mergedState)
		global.GVA_LOG.Info("应用ops更新会话状态",
			zap.String("sessionId", sessionID),
			zap.String("source", mergedState.Meta.Source),
			zap.Any("lens", mergedState.Lens))
	}
}

// mergeSessionState 合并 SessionState 格式的状态
func (h *MessageHandlers) mergeSessionState(sessionID string, syncState *SessionState, fromControlled bool) {
	currentState := h.sessionManager.GetSessionState(sessionID)
	if currentState == nil {
		return
	}

	mergedState := *currentState
	hasUpdates := false

	if syncState.Lens.Mode != "" {
		mergedState.Lens.Mode = syncState.Lens.Mode
		hasUpdates = true
	}
	if syncState.Lens.LeftS != nil {
		mergedState.Lens.LeftS = syncState.Lens.LeftS
		hasUpdates = true
	}
	if syncState.Lens.RightS != nil {
		mergedState.Lens.RightS = syncState.Lens.RightS
		hasUpdates = true
	}
	if syncState.Lens.LeftC != nil {
		mergedState.Lens.LeftC = syncState.Lens.LeftC
		hasUpdates = true
	}
	if syncState.Lens.RightC != nil {
		mergedState.Lens.RightC = syncState.Lens.RightC
		hasUpdates = true
	}
	if syncState.Lens.LeftA != nil {
		mergedState.Lens.LeftA = syncState.Lens.LeftA
		hasUpdates = true
	}
	if syncState.Lens.RightA != nil {
		mergedState.Lens.RightA = syncState.Lens.RightA
		hasUpdates = true
	}
	if syncState.Lens.Add != nil {
		mergedState.Lens.Add = syncState.Lens.Add
		hasUpdates = true
	}
	if syncState.Lens.PD != nil {
		mergedState.Lens.PD = syncState.Lens.PD
		hasUpdates = true
	}
	if currentState.Device.NiuTouConnected != syncState.Device.NiuTouConnected {
		mergedState.Device.NiuTouConnected = syncState.Device.NiuTouConnected
		hasUpdates = true
	}
	if syncState.Device.Transport != nil {
		mergedState.Device.Transport = syncState.Device.Transport
		hasUpdates = true
	}
	if syncState.Device.LastApply != nil {
		mergedState.Device.LastApply = syncState.Device.LastApply
		hasUpdates = true
	}

	if hasUpdates {
		if fromControlled {
			mergedState.Meta.Source = "CONTROLLED"
		} else {
			mergedState.Meta.Source = "MAIN_CONTROL"
		}
		mergedState.Meta.UpdatedAt = time.Now().UnixMilli()
		h.sessionManager.UpdateSessionState(sessionID, &mergedState)
		global.GVA_LOG.Info("合并会话状态",
			zap.String("sessionId", sessionID),
			zap.String("source", mergedState.Meta.Source),
			zap.Any("lens", mergedState.Lens))
	}
}

// applyFlatState 应用扁平格式的状态
func (h *MessageHandlers) applyFlatState(sessionID string, flatState map[string]interface{}, fromControlled bool) {
	currentState := h.sessionManager.GetSessionState(sessionID)
	if currentState == nil {
		return
	}

	mergedState := *currentState
	hasUpdates := false

	if mode, ok := flatState["mode"].(string); ok && mode != "" {
		mergedState.Lens.Mode = LensMode(mode)
		hasUpdates = true
	}
	if leftS, ok := toFloat64(flatState["leftS"]); ok {
		mergedState.Lens.LeftS = &leftS
		hasUpdates = true
	}
	if rightS, ok := toFloat64(flatState["rightS"]); ok {
		mergedState.Lens.RightS = &rightS
		hasUpdates = true
	}
	if leftC, ok := toFloat64(flatState["leftC"]); ok {
		mergedState.Lens.LeftC = &leftC
		hasUpdates = true
	}
	if rightC, ok := toFloat64(flatState["rightC"]); ok {
		mergedState.Lens.RightC = &rightC
		hasUpdates = true
	}
	if connected, ok := flatState["niuTouConnected"].(bool); ok {
		mergedState.Device.NiuTouConnected = connected
		hasUpdates = true
	}
	if transport, ok := flatState["transport"].(string); ok && transport != "" {
		t := TransportType(transport)
		mergedState.Device.Transport = &t
		hasUpdates = true
	}

	if hasUpdates {
		if fromControlled {
			mergedState.Meta.Source = "CONTROLLED"
		} else {
			mergedState.Meta.Source = "MAIN_CONTROL"
		}
		mergedState.Meta.UpdatedAt = time.Now().UnixMilli()
		h.sessionManager.UpdateSessionState(sessionID, &mergedState)
		global.GVA_LOG.Info("应用扁平格式状态",
			zap.String("sessionId", sessionID),
			zap.String("source", mergedState.Meta.Source),
			zap.Any("lens", mergedState.Lens))
	}
}

// toFloat64 将 interface{} 转换为 float64
func toFloat64(v interface{}) (float64, bool) {
	switch val := v.(type) {
	case float64:
		return val, true
	case float32:
		return float64(val), true
	case int:
		return float64(val), true
	case int64:
		return float64(val), true
	case int32:
		return float64(val), true
	default:
		return 0, false
	}
}

// HandleSyncSnapshot 处理同步快照
func (h *MessageHandlers) HandleSyncSnapshot(connectionID string, msg *SocketMessage) *SocketMessage {
	if msg.SessionID == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Missing sessionId")
	}

	// 获取会话状态
	sessionState := h.sessionManager.GetSessionState(*msg.SessionID)
	if sessionState == nil {
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "Session not found")
	}

	// 构建响应
	responseData := SyncSnapshotResponseData{
		SessionState: *sessionState,
	}
	data, _ := json.Marshal(responseData)
	rawData := json.RawMessage(data)

	return &SocketMessage{
		Cmd:       CmdSyncSnapshot,
		SessionID: msg.SessionID,
		TxnID:     msg.TxnID,
		Role:      msg.Role,
		Data:      &rawData,
	}
}

// startApplyTimeoutCheck 启动apply超时检查
func (h *MessageHandlers) startApplyTimeoutCheck(sessionID, txnID, controlledConnID string) {
	time.Sleep(time.Duration(h.applyTimeoutMs) * time.Millisecond)

	// 检查事务是否已完成
	if h.transactionManager.IsProcessed(txnID) {
		return
	}

	// 标记超时
	h.transactionManager.MarkTimeout(txnID)

	global.GVA_LOG.Warn("远控命令超时",
		zap.String("sessionId", sessionID),
		zap.String("txnId", txnID))

	// 通知主控端超时
	timeoutData := PatchAppliedData{
		Success: false,
		Error:   strPtr("执行超时"),
	}
	timeoutMsg := SocketMessage{
		Cmd:       CmdPatchApplied,
		SessionID: &sessionID,
		TxnID:     &txnID,
	}
	timeoutBytes, _ := json.Marshal(timeoutData)
	rawData := json.RawMessage(timeoutBytes)
	timeoutMsg.Data = &rawData

	mainControlConnID := h.connectionManager.GetConnectionByRole(sessionID, RoleMainControl)
	if mainControlConnID != nil {
		msgBytes, _ := timeoutMsg.ToJSON()
		h.connectionManager.SendToConnection(*mainControlConnID, msgBytes)
	}
}

// generateUniqueSessionID 生成唯一会话ID
func (h *MessageHandlers) generateUniqueSessionID() string {
	return fmt.Sprintf("session_%d", time.Now().UnixMilli())
}

// generateRtcConfig 生成RTC配置
func (h *MessageHandlers) generateRtcConfig(sessionID string, role string) *RtcConfig {
	if h.rtcGenerator == nil {
		global.GVA_LOG.Warn("RTC Token生成器未初始化，返回模拟配置")
		return &RtcConfig{
			AppID:           "default_app_id",
			ChannelName:     sessionID,
			Token:           "mock_token",
			UID:             1,
			TokenExpireTime: int(time.Now().Unix()) + 3600,
		}
	}

	// 基于会话ID和角色生成唯一UID
	// 使用时间戳的哈希值来确保UID唯一性
	hash := int(time.Now().UnixMilli() % 1000000000) // 9位数

	var uid int
	if role == "main_control" {
		uid = (hash | 1) // 确保是奇数
	} else {
		uid = (hash & -2) // 确保是偶数
	}

	global.GVA_LOG.Debug("生成RTC配置",
		zap.String("sessionId", sessionID),
		zap.String("role", role),
		zap.Int("uid", uid))

	result := h.rtcGenerator.GenerateRtcToken(sessionID, uid)

	if result == nil || result.Token == "" {
		global.GVA_LOG.Error("生成RTC配置失败",
			zap.String("sessionId", sessionID),
			zap.String("role", role),
			zap.Int("uid", uid))
		return nil
	}

	return result
}

// generateRtcConfigPair 一次性生成主控端和被控端的RTC配置
// 确保两端使用相同的 baseUID，保证 UID 相邻（奇偶数关系）
func (h *MessageHandlers) generateRtcConfigPair(sessionID string) (*RtcConfig, *RtcConfig) {
	if h.rtcGenerator == nil {
		global.GVA_LOG.Warn("RTC Token生成器未初始化，返回模拟配置")
		mockConfig := &RtcConfig{
			AppID:           "default_app_id",
			ChannelName:     sessionID,
			Token:           "mock_token",
			UID:             1,
			TokenExpireTime: int(time.Now().Unix()) + 3600,
		}
		return mockConfig, mockConfig
	}

	// 使用相同的 baseUID 生成主控端和被控端的 UID
	baseUID := int(time.Now().UnixMilli() % 1000000000)

	// 主控端 UID：确保是奇数
	mainControlUID := baseUID | 1
	// 被控端 UID：确保是偶数
	controlledUID := baseUID & -2

	global.GVA_LOG.Info("生成RTC配置对",
		zap.String("sessionId", sessionID),
		zap.Int("baseUID", baseUID),
		zap.Int("mainControlUID", mainControlUID),
		zap.Int("controlledUID", controlledUID))

	// 生成主控端配置
	rtcConfigForMain := h.rtcGenerator.GenerateRtcToken(sessionID, mainControlUID)
	if rtcConfigForMain == nil || rtcConfigForMain.Token == "" {
		global.GVA_LOG.Error("生成主控端RTC配置失败",
			zap.String("sessionId", sessionID),
			zap.Int("uid", mainControlUID))
		return nil, nil
	}

	// 生成被控端配置
	rtcConfigForControlled := h.rtcGenerator.GenerateRtcToken(sessionID, controlledUID)
	if rtcConfigForControlled == nil || rtcConfigForControlled.Token == "" {
		global.GVA_LOG.Error("生成被控端RTC配置失败",
			zap.String("sessionId", sessionID),
			zap.Int("uid", controlledUID))
		return nil, nil
	}

	return rtcConfigForMain, rtcConfigForControlled
}

// strPtr 辅助函数：字符串指针
func strPtr(s string) *string {
	return &s
}
