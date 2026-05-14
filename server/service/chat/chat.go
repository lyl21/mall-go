package chat

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
)

// ChatService 大模型桥接服务
type ChatService struct{}

// ChatRequest 前端请求体
type ChatRequest struct {
	Messages []ChatMessage `json:"messages"`
}

// ChatMessage 对话消息
type ChatMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

// ModelConfig 大模型配置
type ModelConfig struct {
	ApiKey       string
	Model        string
	BaseUrl      string
	SystemPrompt string
}

const (
	sysParamApiKey       = "control.app.modelApiKey"
	sysParamModel        = "control.app.model"
	sysParamBaseUrl      = "control.app.modelBaseUrl"
	sysParamSystemPrompt = "control.app.systemPrompt"
	defaultSystemPrompt  = "你是一个专业验光人员,需要解答用户的验光问题,使用中文回答,回答字数控制在200字到300字以内,使用专业、简洁的回答"
)

// StreamCallback SSE 事件回调
type StreamCallback func(content string, done bool)

// GetModelConfig 从 sys_params 获取大模型配置（含系统提示词）
func (s *ChatService) GetModelConfig() (*ModelConfig, error) {
	var modelCfg ModelConfig

	apiKeyParam, err := s.getSysParam(sysParamApiKey)
	if err != nil {
		return nil, fmt.Errorf("获取API Key失败: %w", err)
	}
	modelCfg.ApiKey = apiKeyParam

	modelParam, err := s.getSysParam(sysParamModel)
	if err != nil {
		return nil, fmt.Errorf("获取Model失败: %w", err)
	}
	modelCfg.Model = modelParam

	baseUrlParam, err := s.getSysParam(sysParamBaseUrl)
	if err != nil {
		return nil, fmt.Errorf("获取BaseUrl失败: %w", err)
	}
	modelCfg.BaseUrl = baseUrlParam

	if modelCfg.ApiKey == "" || modelCfg.Model == "" || modelCfg.BaseUrl == "" {
		return nil, fmt.Errorf("大模型配置不完整，请在参数管理中配置 control.app.modelApiKey/model/baseUrl")
	}

	// 获取系统提示词，不存在或为空时使用默认值
	modelCfg.SystemPrompt = s.GetSystemPrompt()

	return &modelCfg, nil
}

// GetSystemPrompt 获取系统提示词
func (s *ChatService) GetSystemPrompt() string {
	prompt, err := s.getSysParam(sysParamSystemPrompt)
	if err != nil || prompt == "" {
		return defaultSystemPrompt
	}
	return prompt
}

// buildMessages 将系统提示词注入到消息列表头部（除非前端已传 system role）
func (s *ChatService) buildMessages(cfg *ModelConfig, msgs []ChatMessage) []ChatMessage {
	// 如果前端已包含 system 消息，不再重复注入
	for _, m := range msgs {
		if m.Role == "system" {
			return msgs
		}
	}
	// 注入系统提示词到消息列表头部
	systemMsg := ChatMessage{Role: "system", Content: cfg.SystemPrompt}
	return append([]ChatMessage{systemMsg}, msgs...)
}

// getSysParam 从数据库获取参数值
func (s *ChatService) getSysParam(key string) (string, error) {
	var result struct {
		Value string `gorm:"column:value"`
	}
	err := global.GVA_DB.Table("sys_params").Select("value").Where("`key` = ?", key).First(&result).Error
	if err != nil {
		return "", err
	}
	return result.Value, nil
}

// StreamChat 流式转发聊天请求到豆包API
func (s *ChatService) StreamChat(cfg *ModelConfig, req *ChatRequest, onEvent StreamCallback) error {
	messages := s.buildMessages(cfg, req.Messages)
	// 构建请求体
	body := map[string]interface{}{
		"model":    cfg.Model,
		"messages": messages,
		"stream":   true,
	}
	bodyBytes, err := json.Marshal(body)
	if err != nil {
		return fmt.Errorf("序列化请求体失败: %w", err)
	}

	// 构建 HTTP 请求
	apiURL := strings.TrimRight(cfg.BaseUrl, "/")

	// 打印请求日志（隐藏 API Key 敏感信息）
	global.GVA_LOG.Info("大模型请求",
		zap.String("url", apiURL),
		zap.String("model", cfg.Model),
		zap.String("body", string(bodyBytes)),
	)

	httpReq, err := http.NewRequest("POST", apiURL, bytes.NewReader(bodyBytes))
	if err != nil {
		return fmt.Errorf("创建HTTP请求失败: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Bearer "+cfg.ApiKey)

	client := &http.Client{
		Timeout: 120 * time.Second,
	}

	resp, err := client.Do(httpReq)
	if err != nil {
		return fmt.Errorf("请求大模型API失败: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("大模型API返回错误(%d): %s", resp.StatusCode, string(bodyBytes))
	}

	// 读取 SSE 流并回调
	reader := bufio.NewScanner(resp.Body)
	reader.Buffer(make([]byte, 0, 64*1024), 1024*1024) // 增加缓冲区

	for reader.Scan() {
		line := reader.Text()
		if line == "" || !strings.HasPrefix(line, "data:") {
			continue
		}

		data := strings.TrimPrefix(line, "data: ")
		data = strings.TrimSpace(data)

		// 判断结束标记
		if data == "[DONE]" {
			onEvent("", true)
			return nil
		}

		// 解析 SSE 数据
		var sseData struct {
			Choices []struct {
				Delta struct {
					Content string `json:"content"`
				} `json:"delta"`
			} `json:"choices"`
		}
		if err := json.Unmarshal([]byte(data), &sseData); err != nil {
			continue
		}

		if len(sseData.Choices) > 0 && sseData.Choices[0].Delta.Content != "" {
			onEvent(sseData.Choices[0].Delta.Content, false)
		}
	}

	if err := reader.Err(); err != nil {
		return fmt.Errorf("读取流式响应失败: %w", err)
	}

	onEvent("", true)
	return nil
}

// Chat 非流式转发聊天请求到豆包API
func (s *ChatService) Chat(cfg *ModelConfig, req *ChatRequest) (string, error) {
	messages := s.buildMessages(cfg, req.Messages)
	body := map[string]interface{}{
		"model":    cfg.Model,
		"messages": messages,
		"stream":   false,
	}
	bodyBytes, err := json.Marshal(body)
	if err != nil {
		return "", fmt.Errorf("序列化请求体失败: %w", err)
	}

	apiURL := strings.TrimRight(cfg.BaseUrl, "/") 

	// 打印请求日志
	global.GVA_LOG.Info("大模型请求(非流式)",
		zap.String("url", apiURL),
		zap.String("model", cfg.Model),
		zap.String("body", string(bodyBytes)),
	)

	httpReq, err := http.NewRequest("POST", apiURL, bytes.NewReader(bodyBytes))
	if err != nil {
		return "", fmt.Errorf("创建HTTP请求失败: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Bearer "+cfg.ApiKey)

	client := &http.Client{
		Timeout: 120 * time.Second,
	}

	resp, err := client.Do(httpReq)
	if err != nil {
		return "", fmt.Errorf("请求大模型API失败: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("大模型API返回错误(%d): %s", resp.StatusCode, string(bodyBytes))
	}

	var result struct {
		Choices []struct {
			Message struct {
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", fmt.Errorf("解析响应失败: %w", err)
	}

	if len(result.Choices) > 0 {
		return result.Choices[0].Message.Content, nil
	}

	return "", fmt.Errorf("大模型返回了空响应")
}

// GetChatConfig 获取聊天配置（问题列表等）
func (s *ChatService) GetChatConfig() map[string]interface{} {
	config := map[string]interface{}{
		"questionBatches": [][]string{
			{"请问您的视力是否有模糊、重影或眼疲劳的情况？", "您每天使用电子产品的时间大约是多长？", "您是否有戴眼镜或隐形眼镜的习惯？", "您最近一次验光是什么时候？"},
			{"您在夜间开车时是否感到视力下降？", "您是否有头痛或眼睛酸痛的情况？", "您的家族中是否有近视、远视或散光的遗传史？", "您是否有糖尿病、高血压等慢性疾病？"},
			{"您是否对强光敏感？", "您在阅读时是否需要将书本放得很近才能看清？", "您是否有过眼部手术经历？", "您目前是否在服用任何可能影响视力的药物？"},
		},
		"systemPrompt":   s.GetSystemPrompt(),
		"welcomeMessage": "您好！我是智能验光助手，请问有什么可以帮您的？",
	}

	return config
}

// LogChat 记录聊天日志
func (s *ChatService) LogChat(userMessage string, assistantMessage string, model string) {
	global.GVA_LOG.Info("大模型对话记录",
		zap.String("userMessage", truncate(userMessage, 200)),
		zap.String("assistantMessage", truncate(assistantMessage, 200)),
		zap.String("model", model),
	)
}

func truncate(s string, maxLen int) string {
	if len(s) > maxLen {
		return s[:maxLen] + "..."
	}
	return s
}
