package store

type ServiceGroup struct {
	StoreService
	StoreMemberService
	UserService
	UserFlowService
	ActivationCodeService
	PictureService
	InstallingPackageService
}
