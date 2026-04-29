package middleware

import (
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/client"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
)

func ClientAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := getClientToken(c)
		if token == "" {
			client.ClientUnauthorized("未登录或非法访问，请登录", c)
			c.Abort()
			return
		}

		valid, claims := utils.ValidateClientToken(token)
		if !valid || claims == nil {
			client.ClientUnauthorized("登录已过期，请重新登录", c)
			c.Abort()
			return
		}

		c.Set("clientUserId", claims.UserId)
		c.Set("clientPhone", claims.PhoneNumber)
		c.Next()
	}
}

func getClientToken(c *gin.Context) string {
	// 优先从 authorization header 获取 Bearer token
	authHeader := c.GetHeader("authorization")
	if authHeader != "" {
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) == 2 && strings.ToLower(parts[0]) == "bearer" {
			return parts[1]
		}
	}

	// 从 token header 获取
	token := c.GetHeader("token")
	if token != "" {
		return token
	}

	// 从 x-token header 获取
	token = c.GetHeader("x-token")
	if token != "" {
		return token
	}

	// 从 cookie 获取
	token, _ = c.Cookie("x-token")
	return token
}
