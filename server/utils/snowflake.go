package utils

import (
	"sync"
	"time"
)

// Snowflake 雪花算法结构体
type Snowflake struct {
	mu            sync.Mutex
	timestamp     int64 // 时间戳
	workerId      int64 // 机器ID
	datacenterId  int64 // 数据中心ID
	sequence      int64 // 序列号
}

const (
	workerIdBits     = uint64(5) // 机器ID位数
	datacenterIdBits = uint64(5) // 数据中心ID位数
	sequenceBits     = uint64(12) // 序列号位数

	maxWorkerId     = int64(-1) ^ (int64(-1) << workerIdBits)     // 最大机器ID
	maxDatacenterId = int64(-1) ^ (int64(-1) << datacenterIdBits) // 最大数据中心ID
	maxSequence     = int64(-1) ^ (int64(-1) << sequenceBits)     // 最大序列号

	workerIdShift     = sequenceBits                             // 机器ID左移位数
	datacenterIdShift = sequenceBits + workerIdBits              // 数据中心ID左移位数
	timestampShift    = sequenceBits + workerIdBits + datacenterIdBits // 时间戳左移位数
)

var (
	epoch          int64 = 1609459200000 // 起始时间戳 2021-01-01 00:00:00
	snowflakeInst  *Snowflake
	snowflakeOnce  sync.Once
)

// InitSnowflake 初始化雪花算法
func InitSnowflake(workerId, datacenterId int64) {
	snowflakeOnce.Do(func() {
		snowflakeInst = NewSnowflake(workerId, datacenterId)
	})
}

// NewSnowflake 创建雪花算法实例
func NewSnowflake(workerId, datacenterId int64) *Snowflake {
	if workerId < 0 || workerId > maxWorkerId {
		panic("workerId out of range")
	}
	if datacenterId < 0 || datacenterId > maxDatacenterId {
		panic("datacenterId out of range")
	}
	return &Snowflake{
		workerId:     workerId,
		datacenterId: datacenterId,
		timestamp:    0,
		sequence:     0,
	}
}

// NextId 生成下一个ID
func (s *Snowflake) NextId() int64 {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := time.Now().UnixMilli()

	if now < s.timestamp {
		// 时钟回拨，等待
		time.Sleep(time.Duration(s.timestamp-now) * time.Millisecond)
		now = time.Now().UnixMilli()
	}

	if now == s.timestamp {
		// 同一毫秒内，序列号递增
		s.sequence = (s.sequence + 1) & maxSequence
		if s.sequence == 0 {
			// 序列号溢出，等待下一毫秒
			for now <= s.timestamp {
				now = time.Now().UnixMilli()
			}
		}
	} else {
		// 不同毫秒，序列号重置
		s.sequence = 0
	}

	s.timestamp = now

	// 组合ID
	id := ((now - epoch) << timestampShift) |
		(s.datacenterId << datacenterIdShift) |
		(s.workerId << workerIdShift) |
		s.sequence

	return id
}

// GenerateOrderNoFromSnowflake 生成订单号（使用雪花算法）
func GenerateOrderNoFromSnowflake() string {
	if snowflakeInst == nil {
		InitSnowflake(0, 0)
	}
	return int64ToString(snowflakeInst.NextId())
}

// GenerateSnowflakeId 生成雪花ID（字符串格式）
func GenerateSnowflakeId() string {
	if snowflakeInst == nil {
		InitSnowflake(0, 0)
	}
	id := snowflakeInst.NextId()
	return int64ToString(id)
}

// int64ToString int64转字符串
func int64ToString(n int64) string {
	if n == 0 {
		return "0"
	}
	var buf [20]byte
	i := len(buf)
	for n > 0 {
		i--
		buf[i] = byte('0' + n%10)
		n /= 10
	}
	return string(buf[i:])
}
