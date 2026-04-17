package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type TryOnGlassImgUrlRouter struct{}

func (r *TryOnGlassImgUrlRouter) InitTryOnGlassImgUrlRouter(Router *gin.RouterGroup) {
	router := Router.Group("mall").Use(middleware.OperationRecord())
	routerWithoutRecord := Router.Group("mall")
	{
		router.POST("tryOnGlassImgUrl", tryOnGlassImgUrlApi.CreateTryOnGlassImgUrl)   // 创建试戴眼镜图片
		router.PUT("tryOnGlassImgUrl", tryOnGlassImgUrlApi.UpdateTryOnGlassImgUrl)    // 更新试戴眼镜图片
		router.DELETE("tryOnGlassImgUrl", tryOnGlassImgUrlApi.DeleteTryOnGlassImgUrl) // 删除试戴眼镜图片
	}
	{
		routerWithoutRecord.GET("tryOnGlassImgUrl", tryOnGlassImgUrlApi.GetTryOnGlassImgUrl)         // 获取试戴眼镜图片信息
		routerWithoutRecord.GET("tryOnGlassImgUrlList", tryOnGlassImgUrlApi.GetTryOnGlassImgUrlList) // 获取试戴眼镜图片列表
	}
}
