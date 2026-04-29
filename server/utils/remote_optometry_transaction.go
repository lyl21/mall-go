package utils

import (
	"sync"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/utils/ws"
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
	Role        ws.ClientRole
	Status      TransactionStatus
	CreatedAt   int64
	UpdatedAt   int64
	CommandData *ws.CommandPatchData
	AckData     *ws.AckData
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
	return t.Status == TransactionStatusCompleted || t.Status == TransactionStatusFailed || t.Status == TransactionStatusTimeout
}

// UpdateStatus 更新状态
func (t *TransactionRecord) UpdateStatus(newStatus TransactionStatus) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.Status = newStatus
	t.UpdatedAt = time.Now().UnixMilli()
}

// GetStatus 获取状态
func (t *TransactionRecord) GetStatus() TransactionStatus {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.Status
}

// GetCommandData 获取命令数据
func (t *TransactionRecord) GetCommandData() *ws.CommandPatchData {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.CommandData
}

// TransactionManager 事务管理器
type TransactionManager struct {
	transactions      map[string]*TransactionRecord
	sessionTxns       map[string]map[string]bool
	mu                sync.RWMutex
	timeoutMs         int64
	applyTimeoutMs    int64
	cleanupIntervalMs int64
}

// NewTransactionManager 创建事务管理器
func NewTransactionManager() *TransactionManager {
	tm := &TransactionManager{
		transactions:      make(map[string]*TransactionRecord),
		sessionTxns:       make(map[string]map[string]bool),
		timeoutMs:         10000,  // 10秒
		applyTimeoutMs:    5000,   // 5秒
		cleanupIntervalMs: 60000,  // 1分钟
	}
	// 启动清理协程
	go tm.cleanupLoop()
	return tm
}

// generateTransactionID 生成事务ID
func (tm *TransactionManager) generateTransactionID() string {
	return "txn_" + time.Now().Format("20060102150405") + "_" + ws.RandomString(8)
}

// BeginTransaction 开始新事务
func (tm *TransactionManager) BeginTransaction(sessionID string, role ws.ClientRole, commandData *ws.CommandPatchData) string {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	txnID := tm.generateTransactionID()
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

	// 保存事务记录
	tm.transactions[txnID] = record

	// 添加到会话事务集合
	if _, ok := tm.sessionTxns[sessionID]; !ok {
		tm.sessionTxns[sessionID] = make(map[string]bool)
	}
	tm.sessionTxns[sessionID][txnID] = true

	global.GVA_LOG.Info("开始事务",
		zap.String("txnId", txnID),
		zap.String("sessionId", sessionID),
		zap.String("role", string(role)),
		zap.Int("opsCount", len(commandData.Ops)))

	return txnID
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

	status := record.GetStatus()
	if status != TransactionStatusPending {
		global.GVA_LOG.Warn("事务不在PENDING状态",
			zap.String("txnId", txnID),
			zap.String("currentStatus", string(status)))
		return false
	}

	record.UpdateStatus(TransactionStatusApplying)
	global.GVA_LOG.Info("标记事务为APPLYING", zap.String("txnId", txnID))
	return true
}

// CompleteTransaction 完成事务
func (tm *TransactionManager) CompleteTransaction(txnID string, ackData *ws.AckData) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		global.GVA_LOG.Warn("事务未找到", zap.String("txnId", txnID))
		return false
	}

	status := record.GetStatus()
	if status != TransactionStatusApplying && status != TransactionStatusPending {
		global.GVA_LOG.Warn("事务不在APPLYING/PENDING状态",
			zap.String("txnId", txnID),
			zap.String("currentStatus", string(status)))
	}

	record.mu.Lock()
	record.AckData = ackData
	record.mu.Unlock()

	newStatus := TransactionStatusCompleted
	if !ackData.Success {
		newStatus = TransactionStatusFailed
	}
	record.UpdateStatus(newStatus)

	global.GVA_LOG.Info("完成事务",
		zap.String("txnId", txnID),
		zap.String("sessionId", record.SessionID),
		zap.Bool("success", ackData.Success))

	return true
}

// MarkTimeout 标记事务超时
func (tm *TransactionManager) MarkTimeout(txnID string) bool {
	tm.mu.RLock()
	record, ok := tm.transactions[txnID]
	tm.mu.RUnlock()

	if !ok {
		global.GVA_LOG.Warn("事务未找到", zap.String("txnId", txnID))
		return false
	}

	status := record.GetStatus()
	if status == TransactionStatusCompleted || status == TransactionStatusFailed {
		return false
	}

	record.UpdateStatus(TransactionStatusTimeout)
	global.GVA_LOG.Info("标记事务超时", zap.String("txnId", txnID))
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

// GetTransactionsBySession 获取会话的所有事务
func (tm *TransactionManager) GetTransactionsBySession(sessionID string) []*TransactionRecord {
	tm.mu.RLock()
	defer tm.mu.RUnlock()

	var records []*TransactionRecord
	if txnIDs, ok := tm.sessionTxns[sessionID]; ok {
		for txnID := range txnIDs {
			if record, ok := tm.transactions[txnID]; ok {
				records = append(records, record)
			}
		}
	}
	return records
}

// cleanupLoop 清理循环
func (tm *TransactionManager) cleanupLoop() {
	ticker := time.NewTicker(time.Duration(tm.cleanupIntervalMs) * time.Millisecond)
	defer ticker.Stop()

	for range ticker.C {
		tm.cleanup()
	}
}

// cleanup 清理过期事务
func (tm *TransactionManager) cleanup() {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	now := time.Now().UnixMilli()
	maxAge := tm.timeoutMs * 5 // 保留5倍超时时间的事务

	for txnID, record := range tm.transactions {
		if now-record.CreatedAt > maxAge {
			// 从会话事务集合中移除
			if txnIDs, ok := tm.sessionTxns[record.SessionID]; ok {
				delete(txnIDs, txnID)
				if len(txnIDs) == 0 {
					delete(tm.sessionTxns, record.SessionID)
				}
			}
			// 删除事务记录
			delete(tm.transactions, txnID)
		}
	}
}

// GetStats 获取统计信息
func (tm *TransactionManager) GetStats() map[string]interface{} {
	tm.mu.RLock()
	defer tm.mu.RUnlock()

	stats := map[string]interface{}{
		"totalTransactions": len(tm.transactions),
	}

	var pending, applying, completed, failed, timeout int
	for _, record := range tm.transactions {
		switch record.GetStatus() {
		case TransactionStatusPending:
			pending++
		case TransactionStatusApplying:
			applying++
		case TransactionStatusCompleted:
			completed++
		case TransactionStatusFailed:
			failed++
		case TransactionStatusTimeout:
			timeout++
		}
	}

	stats["pendingTransactions"] = pending
	stats["applyingTransactions"] = applying
	stats["completedTransactions"] = completed
	stats["failedTransactions"] = failed
	stats["timeoutTransactions"] = timeout

	return stats
}
