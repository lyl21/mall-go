package middleware

import (
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/client"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
)

// MiniJWTAuth 小程序 JWT 认证中间件
// 校验 header 中的 Authorization: Bearer <token>，将 openId + wxUserId 注入上下文
func MiniJWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := GetMiniToken(c)
		if token == "" {
			client.ClientUnauthorized("请先登录", c)
			c.Abort()
			return
		}

		valid, claims := utils.ValidateMiniToken(token)
		if !valid || claims == nil {
			client.ClientUnauthorized("登录已过期，请重新登录", c)
			c.Abort()
			return
		}

		c.Set("openId", claims.OpenId)
		c.Set("wxUserId", claims.WxUserId)
		c.Next()
	}
}

// GetMiniToken 从小程序请求中提取 token（导出供外部使用）
func GetMiniToken(c *gin.Context) string {
	authHeader := c.GetHeader("Authorization")
	if authHeader != "" {
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) == 2 && strings.ToLower(parts[0]) == "bearer" {
			return parts[1]
		}
	}

	token := c.GetHeader("token")
	if token != "" {
		return token
	}

	token = c.GetHeader("x-token")
	if token != "" {
		return token
	}

	token, _ = c.Cookie("x-token")
	return token
}
