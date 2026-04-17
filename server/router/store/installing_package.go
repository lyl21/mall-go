package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type InstallingPackageRouter struct{}

func (i *InstallingPackageRouter) InitInstallingPackageRouter(Router *gin.RouterGroup) {
	pkgRouter := Router.Group("store").Use(middleware.OperationRecord())
	pkgRouterWithoutRecord := Router.Group("store")
	{
		pkgRouter.POST("installingPackage", mxInstallingPkgApi.CreateInstallingPackage)   // 创建安装包
		pkgRouter.PUT("installingPackage", mxInstallingPkgApi.UpdateInstallingPackage)    // 更新安装包
		pkgRouter.DELETE("installingPackage", mxInstallingPkgApi.DeleteInstallingPackage) // 删除安装包
	}
	{
		pkgRouterWithoutRecord.GET("installingPackage", mxInstallingPkgApi.GetInstallingPackage)         // 获取安装包
		pkgRouterWithoutRecord.GET("installingPackageList", mxInstallingPkgApi.GetInstallingPackageList) // 获取安装包列表
	}
}
