package utils

import (
	"strconv"

	"github.com/gin-gonic/gin"
)

// GetIntQuery 从Query参数获取int值，带默认值
func GetIntQuery(c *gin.Context, key string, defaultVal int) int {
	val := c.Query(key)
	if val == "" {
		return defaultVal
	}
	i, err := strconv.Atoi(val)
	if err != nil {
		return defaultVal
	}
	return i
}
