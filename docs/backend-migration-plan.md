# 智能验光助手 — 豆包 API 迁移到后端方案

## 1. 背景

当前前端直连豆包（火山方舟）API，API Key 暴露在前端代码中，存在安全隐患且不利于扩展。
本方案将 API 调用迁移至后端，由后端统一管理密钥、转发流式请求。

---

## 2. 架构对比

### 2.1 现状（前端直连）

```
用户 → 前端(Vue) → 豆包API (ark.cn-beijing.volces.com)
```

### 2.2 目标（后端代理）

```
用户 → 前端(Vue) → 后端服务 → 豆包API
```

---

## 3. 后端接口设计

### 3.1 流式聊天接口

```
POST /api/chat/stream
```

**请求体：**

```json
{
  "messages": [
    { "role": "user", "content": "验光前需要做哪些准备？" }
  ]
}
```

**响应：**
- Content-Type: `text/event-stream`
- 流式返回 SSE 事件：

```
data: {"content": "验"}
data: {"content": "光"}
data: {"content": "前"}
...
data: [DONE]
```

**错误响应：**

```json
{ "error": "请求失败的具体原因" }
```

### 3.2 配置接口（可选）

```
GET /api/config
```

**响应：**

```json
{
  "questionBatches": [
    ["问题1", "问题2", "问题3", "问题4"],
    ["问题5", "问题6", "问题7", "问题8"]
  ]
}
```

---

## 4. 前端改造

### 4.1 改动点

| 项目 | 改造前 | 改造后 |
|------|--------|--------|
| API 地址 | `ark.cn-beijing.volces.com` | `后端服务地址/api/chat/stream` |
| 鉴权方式 | `Bearer <豆包API Key>` | 无或业务 Token |
| 请求体 | model、messages、stream 等 | 仅 messages |
| 响应格式 | OpenAI SSE | 自定义 SSE（兼容） |
| API Key 存储 | 前端 localStorage | 完全移除 |

### 4.2 新增文件 `src/utils/chatApi.ts`

替代现有 `src/utils/doubaoApi.ts`，仅保留 `streamChat` 函数，改为调用后端接口。

### 4.3 修改文件

- `src/components/ChatPanel.vue`：import 路径改为 `chatApi`
- `src/utils/doubaoApi.ts`：删除

---

## 5. 职责划分

| 职责 | 归属 |
|------|------|
| API Key 存储 | 后端（环境变量） |
| System Prompt | 后端（配置文件） |
| Model 选择 | 后端 |
| Temperature / MaxTokens | 后端（支持参数覆盖） |
| 流式转发 | 后端 |
| 对话历史维护 | 前端（当前会话） |
| 问题列表 | 后端（/api/config 下发） |
| 交互展示 | 前端（不变） |

---

## 6. 迁移步骤

### 第一阶段：后端开发
1. 搭建后端服务（Node.js + Fastify / Python + FastAPI）
2. 实现 `POST /api/chat/stream` 流式转发
3. 配置豆包 API Key 到环境变量
4. 本地测试流式转发

### 第二阶段：前端改造
1. 新建 `src/utils/chatApi.ts`
2. 修改 `ChatPanel.vue` import 路径
3. 删除 `src/utils/doubaoApi.ts`
4. 添加 `.env` 配置 `VITE_API_BASE_URL`
5. 构建验证

### 第三阶段：联调部署
1. 前后端联调
2. 部署后端服务
3. 前端构建产物部署
4. 端到端测试

---

## 7. 技术选型建议

| 方案 | 适用场景 | 推荐度 |
|------|---------|--------|
| Node.js + Fastify | 前端团队主导，快速开发 | ⭐⭐⭐⭐⭐ |
| Python + FastAPI | 有 Python 经验，后续接 AI 库 | ⭐⭐⭐⭐ |
| Go + Gin | 高并发，追求性能 | ⭐⭐⭐⭐ |
| Java + Spring Boot | 已有 Java 技术栈 | ⭐⭐⭐ |

---

## 8. 注意事项

1. **CORS**：后端需允许前端域名跨域
2. **超时**：后端到豆包 API 建议 30-60s 超时
3. **错误转发**：后端捕获错误后统一格式返回
4. **限流**：防止恶意调用
5. **日志**：记录每次请求输入输出，便于排查
