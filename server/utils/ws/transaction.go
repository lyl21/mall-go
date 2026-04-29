package ws

import (
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// TransactionStatus 事务状态
type TransactionStatus string

const (
	TransactionStatusPending   TransactionStatus = "PENDING"
	TransactionStatusApplying  TransactionStatus = "APPLYING"
	TransactionStatusCompleted TransactionStatus = "COMPLETED"
	TransactionStatusTimeout   TransactionStatus = "TIMEOUT"
	TransactionStatusFailed    TransactionStatus = "FAILED"
)

// TransactionRecord 事务记录
type TransactionRecord struct {
	TxnID       string
	SessionID   string
	Role        ClientRole
	Status      TransactionStatus
	CreatedAt   int64
	UpdatedAt   int64
	CommandData *CommandPatchData
	AckData     *AckData
	mu          sync.RWMutex
}

// IsTimeout 检查事务是否超时
func (t *TransactionRecord) IsTimeout(timeoutMs int64) bool {
	return time.Now().UnixMilli()-t.CreatedAt > timeoutMs
}

// IsProcessed 检查事务是否已处理
func (t *TransactionRecord) IsProcessed() bool {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.Status == TransactionStatusCompleted
}

// UpdateStatus 更新状态
func (t *TransactionRecord) UpdateStatus(newStatus TransactionStatus) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.Status = newStatus
	t.UpdatedAt = time.Now().UnixMilli()
}

// TransactionManager 事务管理器
type TransactionManager struct {
	transactions map[string]*TransactionRecord
	mu           sync.RWMutex
	timeoutMs    int64
}

// NewTransactionManager 创建事务管理器
func NewTransactionManager(timeoutMs int64) *TransactionManager {
	return &TransactionManager{
		transactions: make(map[string]*TransactionRecord),
		timeoutMs:    timeoutMs,
	}
}

// BeginTransaction 开始新事务
func (tm *TransactionManager) BeginTransaction(txnID string, sessionID string, role ClientRole, commandData *CommandPatchData) {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	now := time.Now().UnixMilli()

	record := &TransactionRecord{
		TxnID:       txnID,
		SessionID:   sessionID,
		Role:        role,
		Status:      TransactionStatusPending,
		CreatedAt:   now,
		UpdatedAt:   now,
		CommandData: commandData,
	}

	tm.transactions[txnID] = record

	global.GVA_LOG.Info("开始WebSocket事务",
		zap.String("txnId", txnID),
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)))
}

// MarkApplying 标记事务为执行中
func (tm *TransactionManager) MarkApplying(txnID string) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		global.GVA_LOG.Warn("事务未找到", zap.String("txnId", txnID))
		return false
	}

	record.mu.RLock()
	status := record.Status
	record.mu.RUnlock()

	if status != TransactionStatusPending {
		global.GVA_LOG.Warn("事务不在PENDING状态",
			zap.String("txnId", txnID),
			zap.String("currentStatus", string(status)))
		return false
	}

	record.UpdateStatus(TransactionStatusApplying)
	return true
}

// CompleteTransaction 完成事务
func (tm *TransactionManager) CompleteTransaction(txnID string, ackData *AckData) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		global.GVA_LOG.Warn("事务未找到", zap.String("txnId", txnID))
		return false
	}

	record.mu.Lock()
	record.AckData = ackData
	record.mu.Unlock()

	newStatus := TransactionStatusCompleted
	if !ackData.Success {
		newStatus = TransactionStatusFailed
	}
	record.UpdateStatus(newStatus)

	global.GVA_LOG.Info("完成WebSocket事务",
		zap.String("txnId", txnID),
		zap.String("sessionId", record.SessionID),
		zap.Bool("success", ackData.Success))

	return true
}

// Exists 检查事务是否存在
func (tm *TransactionManager) Exists(txnID string) bool {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	_, ok := tm.transactions[txnID]
	return ok
}

// GetTransaction 获取事务记录
func (tm *TransactionManager) GetTransaction(txnID string) *TransactionRecord {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	return tm.transactions[txnID]
}

// IsProcessed 检查事务是否已处理
func (tm *TransactionManager) IsProcessed(txnID string) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		return false
	}
	return record.IsProcessed()
}

// MarkTimeout 标记事务超时
func (tm *TransactionManager) MarkTimeout(txnID string) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		return false
	}

	record.mu.RLock()
	status := record.Status
	record.mu.RUnlock()

	if status == TransactionStatusCompleted || status == TransactionStatusFailed {
		return false
	}

	record.UpdateStatus(TransactionStatusTimeout)
	return true
}

// CheckTimeouts 检查并处理超时事务
func (tm *TransactionManager) CheckTimeouts() []string {
	tm.mu.RLock()
	defer tm.mu.RUnlock()

	timeoutTxns := []string{}

	for txnID, record := range tm.transactions {
		record.mu.RLock()
		status := record.Status
		record.mu.RUnlock()

		if status != TransactionStatusCompleted && status != TransactionStatusFailed && status != TransactionStatusTimeout {
			if record.IsTimeout(tm.timeoutMs) {
				record.UpdateStatus(TransactionStatusTimeout)
				timeoutTxns = append(timeoutTxns, txnID)

				global.GVA_LOG.Info("WebSocket事务超时",
					zap.String("txnId", txnID),
					zap.String("sessionId", record.SessionID))
			}
		}
	}

	return timeoutTxns
}
