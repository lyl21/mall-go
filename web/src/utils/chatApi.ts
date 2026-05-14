/**
 * 大模型聊天桥接工具
 * 替代原有的 doubaoApi.ts，将请求转发至后端桥接接口
 */

interface ChatMessage {
  role: 'user' | 'assistant' | 'system'
  content: string
}

type StreamCallback = (content: string) => void
type ErrorCallback = (error: Error) => void
type DoneCallback = () => void

/**
 * 流式聊天（SSE）
 * @param messages 消息列表
 * @param onContent 内容回调（每收到一段内容触发）
 * @param onDone 完成回调
 * @param onError 错误回调
 */
export async function streamChat(
  messages: ChatMessage[],
  onContent: StreamCallback,
  onDone: DoneCallback,
  onError: ErrorCallback
): Promise<void> {
  // 构建请求URL（VITE_BASE_API 已由 vite 注入）
  const baseUrl = (import.meta as any).env?.VITE_BASE_API || ''
  const url = `${baseUrl}/api/chat/stream`

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ messages })
    })

    if (!response.ok) {
      const errorText = await response.text()
      throw new Error(`请求失败(${response.status}): ${errorText}`)
    }

    const reader = response.body?.getReader()
    if (!reader) throw new Error('无法读取响应流')

    const decoder = new TextDecoder()
    let buffer = ''

    while (true) {
      const { done, value } = await reader.read()
      if (done) break

      buffer += decoder.decode(value, { stream: true })
      const lines = buffer.split('\n')
      buffer = lines.pop() || ''

      for (const line of lines) {
        const trimmed = line.trim()
        if (!trimmed || !trimmed.startsWith('data:')) continue

        const data = trimmed.slice(5).trim()
        if (data === '[DONE]') { onDone(); return }

        try {
          const parsed = JSON.parse(data)
          if (parsed.content) onContent(parsed.content)
          if (parsed.error) throw new Error(parsed.error)
        } catch (e: any) {
          if (e instanceof SyntaxError) continue
          throw e
        }
      }
    }
    onDone()
  } catch (error: any) {
    onError(error instanceof Error ? error : new Error(String(error)))
  }
}

/**
 * 非流式聊天
 * @param messages 消息列表
 * @returns 助手回复内容
 */
export async function chat(messages: ChatMessage[]): Promise<string> {
  const { chat: chatApi } = await import('@/api/chat')
  const res: any = await chatApi({ messages })
  if (res.code === 0 && res.data?.content) return res.data.content
  throw new Error(res.msg || '请求失败')
}

/**
 * 获取聊天配置（问题列表等）
 */
export async function getChatConfig(): Promise<any> {
  const { getChatConfig: getConfig } = await import('@/api/chat')
  const res: any = await getConfig()
  if (res.code === 0) return res.data
  throw new Error(res.msg || '获取配置失败')
}
