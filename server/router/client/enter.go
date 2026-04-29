package client

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

var (
	clientDeviceApi = api.ApiGroupApp.ClientApiGroup.ClientDeviceApi
	clientUserApi   = api.ApiGroupApp.ClientApiGroup.ClientUserApi
	clientMxUserApi = api.ApiGroupApp.ClientApiGroup.ClientMxUserApi
	clientMxUserFlowApi = api.ApiGroupApp.ClientApiGroup.ClientMxUserFlowApi
	clientMxStoreMemberApi = api.ApiGroupApp.ClientApiGroup.ClientMxStoreMemberApi
	clientMxStoreApi = api.ApiGroupApp.ClientApiGroup.ClientMxStoreApi
	clientOptometryDataApi = api.ApiGroupApp.ClientApiGroup.ClientOptometryDataApi
	clientVisionTestResultApi = api.ApiGroupApp.ClientApiGroup.ClientVisionTestResultApi
	clientOptometryRecordApi = api.ApiGroupApp.ClientApiGroup.ClientOptometryRecordApi
	clientTryOptometryApi = api.ApiGroupApp.ClientApiGroup.ClientTryOptometryApi
)

type RouterGroup struct {
	ClientRouter
}
