package chat

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	ChatRouter
}

var chatApi = api.ApiGroupApp.ChatApiGroup.ChatApi
