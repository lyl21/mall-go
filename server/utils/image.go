package utils

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"strings"
	"time"
)

// ParseFirstImage 从JSON数组字符串中解析第一张图片URL
func ParseFirstImage(picUrls string) string {
	if picUrls == "" {
		return ""
	}

	// 尝试解析为JSON数组
	var urls []string
	if err := json.Unmarshal([]byte(picUrls), &urls); err == nil && len(urls) > 0 {
		return urls[0]
	}

	// 尝试按逗号分隔
	parts := strings.Split(picUrls, ",")
	if len(parts) > 0 {
		return strings.TrimSpace(parts[0])
	}

	return picUrls
}

// GenerateOrderNo 生成订单号
func GenerateOrderNo() string {
	return fmt.Sprintf("%s%06d", time.Now().Format("20060102150405"), rand.Intn(1000000))
}
