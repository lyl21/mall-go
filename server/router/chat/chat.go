package chat

import (
	"github.com/gin-gonic/gin"
)

type ChatRouter struct{}

// InitChatPublicRouter 初始化聊天公开路由（无需JWT鉴权）
func (r *ChatRouter) InitChatPublicRouter(Router *gin.RouterGroup) {
	chatGroup := Router.Group("api/chat")
	{
		chatGroup.POST("stream", chatApi.StreamChat) // 流式聊天
		chatGroup.POST("", chatApi.Chat)             // 非流式聊天
		chatGroup.GET("config", chatApi.GetConfig)   // 获取聊天配置
	}
}
