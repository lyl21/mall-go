package store

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	StoreApi
	StoreMemberApi
	UserApi
	UserFlowApi
	ActivationCodeApi
	PictureApi
	InstallingPackageApi
	RemoteOptometryAdminApi
}

var (
	storeService          = service.ServiceGroupApp.StoreServiceGroup.StoreService
	storeMemberService    = service.ServiceGroupApp.StoreServiceGroup.StoreMemberService
	userService           = service.ServiceGroupApp.StoreServiceGroup.UserService
	userFlowService       = service.ServiceGroupApp.StoreServiceGroup.UserFlowService
	activationCodeService = service.ServiceGroupApp.StoreServiceGroup.ActivationCodeService
	pictureService        = service.ServiceGroupApp.StoreServiceGroup.PictureService
	installingPkgService  = service.ServiceGroupApp.StoreServiceGroup.InstallingPackageService
)
