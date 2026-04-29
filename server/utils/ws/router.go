package ws

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// MessageRouter 消息路由器
type MessageRouter struct {
	handlers *MessageHandlers
}

// NewMessageRouter 创建消息路由器
func NewMessageRouter(handlers *MessageHandlers) *MessageRouter {
	return &MessageRouter{
		handlers: handlers,
	}
}

// RouteMessage 路由消息到对应的处理器
func (r *MessageRouter) RouteMessage(connectionID string, messageText string) *SocketMessage {
	// 解析消息
	msg, err := ParseSocketMessage([]byte(messageText))
	if err != nil {
		global.GVA_LOG.Error("解析WebSocket消息失败",
			zap.String("connectionId", connectionID),
			zap.Error(err))
		return CreateErrorMessage(nil, nil, nil, "解析消息失败: "+err.Error())
	}

	// 验证基本字段
	if msg.Cmd == "" {
		global.GVA_LOG.Warn("收到空命令消息", zap.String("connectionId", connectionID))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "命令为空")
	}

	global.GVA_LOG.Info("收到WebSocket消息",
		zap.String("connectionId", connectionID),
		zap.String("cmd", string(msg.Cmd)),
		zap.String("sessionId", getStringValue(msg.SessionID)),
		zap.String("txnId", getStringValue(msg.TxnID)))

	// 根据命令类型路由
	switch msg.Cmd {
	// 会话管理
	case CmdCreateSession:
		return r.handlers.HandleCreateSession(connectionID, msg)

	case CmdJoinSession:
		return r.handlers.HandleJoinSession(connectionID, msg)

	case CmdSyncSnapshot:
		return r.handlers.HandleSyncSnapshot(connectionID, msg)

	case CmdSessionTerminate:
		return r.handlers.HandleSessionTerminate(connectionID, msg)

	// 握手流程
	case CmdControlRequest:
		return r.handlers.HandleControlRequest(connectionID, msg)

	case CmdControlResponse:
		return r.handlers.HandleControlResponse(connectionID, msg)

	// 状态同步
	case CmdStateSync:
		return r.handlers.HandleStateSync(connectionID, msg)

	// 命令流转
	case CmdCommandPatch:
		return r.handlers.HandleCommandPatch(connectionID, msg)

	case CmdAck:
		return r.handlers.HandleAck(connectionID, msg)

	// 心跳
	case CmdHeartbeat:
		return r.handlers.HandleHeartbeat(connectionID, msg)

	// 心跳响应（客户端不应该发送，忽略）
	case CmdHeartbeatAck:
		global.GVA_LOG.Warn("收到心跳响应(客户端不应发送)", zap.String("connectionId", connectionID))
		return nil

	// 错误消息（客户端不应该发送，忽略）
	case CmdError:
		global.GVA_LOG.Warn("收到客户端错误消息(异常情况)", zap.String("connectionId", connectionID))
		return nil

	// 未知命令
	default:
		global.GVA_LOG.Warn("未知WebSocket命令",
			zap.String("connectionId", connectionID),
			zap.String("cmd", string(msg.Cmd)))
		return CreateErrorMessage(msg.SessionID, msg.TxnID, msg.Role, "未知命令: "+string(msg.Cmd))
	}
}

// OnConnectionClosed 处理连接关闭
func (r *MessageRouter) OnConnectionClosed(connectionID string) {
	global.GVA_LOG.Info("WebSocket连接关闭", zap.String("connectionId", connectionID))
}

// getStringValue 获取字符串值
func getStringValue(s *string) string {
	if s == nil {
		return "<nil>"
	}
	return *s
}
