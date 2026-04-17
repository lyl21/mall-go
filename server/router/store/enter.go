package store

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	StoreRouter
	StoreMemberRouter
	UserRouter
	UserFlowRouter
	ActivationCodeRouter
	PictureRouter
	InstallingPackageRouter
	RemoteOptometryAdminRouter
}

var (
	mxStoreApi          = api.ApiGroupApp.StoreApiGroup.StoreApi
	mxStoreMemberApi    = api.ApiGroupApp.StoreApiGroup.StoreMemberApi
	mxUserApi           = api.ApiGroupApp.StoreApiGroup.UserApi
	mxUserFlowApi       = api.ApiGroupApp.StoreApiGroup.UserFlowApi
	mxActivationCodeApi = api.ApiGroupApp.StoreApiGroup.ActivationCodeApi
	mxPictureApi        = api.ApiGroupApp.StoreApiGroup.PictureApi
	mxInstallingPkgApi  = api.ApiGroupApp.StoreApiGroup.InstallingPackageApi
)
