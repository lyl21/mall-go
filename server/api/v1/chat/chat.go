package chat

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/service/chat"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

type ChatApi struct{}

// StreamChat 流式聊天接口（SSE）
// @Tags      Chat
// @Summary   流式聊天
// @accept    application/json
// @Produce   text/event-stream
// @Param     data  body  chat.ChatRequest  true  "聊天请求"
// @Router    /api/chat/stream [post]
func (a *ChatApi) StreamChat(c *gin.Context) {
	var req chat.ChatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	if len(req.Messages) == 0 {
		response.FailWithMessage("messages不能为空", c)
		return
	}

	// 获取模型配置
	cfg, err := chatService.GetModelConfig()
	if err != nil {
		global.GVA_LOG.Error("获取模型配置失败", zap.Error(err))
		response.FailWithMessage("获取模型配置失败: "+err.Error(), c)
		return
	}

	// 设置 SSE 响应头
	c.Header("Content-Type", "text/event-stream")
	c.Header("Cache-Control", "no-cache")
	c.Header("Connection", "keep-alive")
	c.Header("X-Accel-Buffering", "no")
	c.Status(http.StatusOK)

	flusher, ok := c.Writer.(http.Flusher)
	if !ok {
		global.GVA_LOG.Error("响应Writer不支持Flush")
		response.FailWithMessage("服务器不支持流式响应", c)
		return
	}

	var fullResponse strings.Builder

	err = chatService.StreamChat(cfg, &req, func(content string, done bool) {
		if done {
			fmt.Fprintf(c.Writer, "data: [DONE]\n\n")
			flusher.Flush()
			// 记录日志
			chatService.LogChat(
				extractUserMessage(req.Messages),
				fullResponse.String(),
				cfg.Model,
			)
		} else if content != "" {
			fullResponse.WriteString(content)
			data, _ := json.Marshal(map[string]string{"content": content})
			fmt.Fprintf(c.Writer, "data: %s\n\n", data)
			flusher.Flush()
		}
	})

	if err != nil {
		global.GVA_LOG.Error("流式聊天失败", zap.Error(err))
		errData, _ := json.Marshal(map[string]string{"error": err.Error()})
		fmt.Fprintf(c.Writer, "data: %s\n\n", errData)
		flusher.Flush()
	}
}

// GetConfig 获取聊天配置
// @Tags      Chat
// @Summary   获取聊天配置
// @Produce   application/json
// @Router    /api/chat/config [get]
func (a *ChatApi) GetConfig(c *gin.Context) {
	config := chatService.GetChatConfig()
	response.OkWithData(config, c)
}

// Chat 非流式聊天接口
// @Tags      Chat
// @Summary   非流式聊天
// @accept    application/json
// @Produce   application/json
// @Param     data  body  chat.ChatRequest  true  "聊天请求"
// @Router    /api/chat [post]
func (a *ChatApi) Chat(c *gin.Context) {
	var req chat.ChatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	if len(req.Messages) == 0 {
		response.FailWithMessage("messages不能为空", c)
		return
	}

	cfg, err := chatService.GetModelConfig()
	if err != nil {
		global.GVA_LOG.Error("获取模型配置失败", zap.Error(err))
		response.FailWithMessage("获取模型配置失败: "+err.Error(), c)
		return
	}

	result, err := chatService.Chat(cfg, &req)
	if err != nil {
		global.GVA_LOG.Error("聊天请求失败", zap.Error(err))
		response.FailWithMessage("请求失败: "+err.Error(), c)
		return
	}

	chatService.LogChat(
		extractUserMessage(req.Messages),
		result,
		cfg.Model,
	)

	response.OkWithData(map[string]string{"content": result}, c)
}

// extractUserMessage 提取最后一条用户消息
func extractUserMessage(messages []chat.ChatMessage) string {
	for i := len(messages) - 1; i >= 0; i-- {
		if messages[i].Role == "user" {
			return messages[i].Content
		}
	}
	return ""
}
