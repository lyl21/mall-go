package client

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

var (
	clientDeviceApi = api.ApiGroupApp.ClientApiGroup.ClientDeviceApi
)

type RouterGroup struct {
	ClientRouter
}
