package chat

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	ChatApi
}

var (
	chatService = service.ServiceGroupApp.ChatServiceGroup.ChatService
)
