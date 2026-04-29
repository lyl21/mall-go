package ws

import (
	"encoding/json"
	"time"
)

// ClientRole 客户端角色枚举
type ClientRole string

const (
	RoleMainControl ClientRole = "MAIN_CONTROL"
	RoleControlled  ClientRole = "CONTROLLED"
)

// LensMode 镜片模式枚举
type LensMode string

const (
	LensModeFar  LensMode = "FAR"
	LensModeNear LensMode = "NEAR"
)

// ApplyStatus 执行状态枚举
type ApplyStatus string

const (
	ApplyStatusApplying ApplyStatus = "APPLYING"
	ApplyStatusSuccess  ApplyStatus = "SUCCESS"
	ApplyStatusFailed   ApplyStatus = "FAILED"
	ApplyStatusTimeout  ApplyStatus = "TIMEOUT"
)

// TransportType 传输方式枚举
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

// PatchOperation 单个 Patch 操作
type PatchOperation struct {
	Op PatchOpType      `json:"op"`
	P  string           `json:"p"`
	V  *json.RawMessage `json:"v"`
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
	LeftC  *float64 `json:"leftC,omitempty"`
	RightC *float64 `json:"rightC,omitempty"`
	LeftA  *float64 `json:"leftA,omitempty"`
	RightA *float64 `json:"rightA,omitempty"`
	Add    *float64 `json:"add,omitempty"`
	PD     *float64 `json:"pd,omitempty"`
}

// MetaInfo 状态元数据
type MetaInfo struct {
	UpdatedAt int64  `json:"updatedAt"`
	Source    string `json:"source"`
}

// SessionState 会话状态（权威状态）
type SessionState struct {
	SessionID string     `json:"sessionId"`
	Version   int64      `json:"version"`
	Lens      LensState  `json:"lens"`
	Device    DeviceState `json:"device"`
	Meta      MetaInfo   `json:"meta"`
}

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

// SyncSnapshotData 同步快照请求数据
type SyncSnapshotData struct {
	CurrentVersion int64 `json:"currentVersion"`
}

// SyncSnapshotResponseData 同步快照响应数据
type SyncSnapshotResponseData struct {
	SessionState SessionState `json:"sessionState"`
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

// RtcConfig RTC 配置信息
type RtcConfig struct {
	AppID           string `json:"appId"`
	ChannelName     string `json:"channelName"`
	Token           string `json:"token"`
	UID             int    `json:"uid"`
	TokenExpireTime int    `json:"tokenExpireTime"`
}

// ControlAcceptedData 远控已接受数据
type ControlAcceptedData struct {
	MainControlInfo *string       `json:"mainControlInfo,omitempty"`
	Message         *string       `json:"message,omitempty"`
	RtcConfig       *RtcConfig    `json:"rtcConfig,omitempty"`
	SessionState    *SessionState `json:"sessionState,omitempty"`
}

// ControlRejectedData 远控被拒绝数据
type ControlRejectedData struct {
	Reason  string  `json:"reason"`
	Message *string `json:"message,omitempty"`
}

// PendingControlRequest 等待中的远控请求
type PendingControlRequest struct {
	ControlledConnectionID string
	DeviceInfo             *string
	Message                *string
}

// ToJSON 将消息转换为 JSON
func (m *SocketMessage) ToJSON() ([]byte, error) {
	return json.Marshal(m)
}

// ParseSocketMessage 从 JSON 解析消息
func ParseSocketMessage(data []byte) (*SocketMessage, error) {
	var msg SocketMessage
	if err := json.Unmarshal(data, &msg); err != nil {
		return nil, err
	}
	return &msg, nil
}

// CreateErrorMessage 创建错误响应消息
func CreateErrorMessage(sessionID *string, txnID *string, role *ClientRole, errMsg string) *SocketMessage {
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

// NewSessionState 创建新的会话状态
func NewSessionState(sessionID string) *SessionState {
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
