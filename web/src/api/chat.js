import service from '@/utils/request'

// ========== 大模型聊天 ==========

// 流式聊天（SSE）
export const streamChat = (data) => {
  return service({
    url: '/api/chat/stream',
    method: 'post',
    data,
    responseType: 'stream',
    adapter: 'fetch',
    timeout: 120000
  })
}

// 非流式聊天
export const chat = (data) => {
  return service({
    url: '/api/chat',
    method: 'post',
    data
  })
}

// 获取聊天配置（问题列表等）
export const getChatConfig = () => {
  return service({
    url: '/api/chat/config',
    method: 'get'
  })
}
