package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type PictureRouter struct{}

func (p *PictureRouter) InitMxPictureRouter(Router *gin.RouterGroup) {
	pictureRouter := Router.Group("store").Use(middleware.OperationRecord())
	pictureRouterWithoutRecord := Router.Group("store")
	{
		pictureRouter.POST("mxPicture", mxPictureApi.CreateMxPicture)   // 创建图片
		pictureRouter.PUT("mxPicture", mxPictureApi.UpdateMxPicture)    // 更新图片
		pictureRouter.DELETE("mxPicture", mxPictureApi.DeleteMxPicture) // 删除图片
	}
	{
		pictureRouterWithoutRecord.GET("mxPicture", mxPictureApi.GetMxPicture)         // 获取图片
		pictureRouterWithoutRecord.GET("mxPictureList", mxPictureApi.GetMxPictureList) // 获取图片列表
	}
}
