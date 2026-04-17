package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type SpuTryOnImgUrlRouter struct{}

func (r *SpuTryOnImgUrlRouter) InitSpuTryOnImgUrlRouter(Router *gin.RouterGroup) {
	router := Router.Group("mall").Use(middleware.OperationRecord())
	routerWithoutRecord := Router.Group("mall")
	{
		router.POST("spuTryOnImgUrl", spuTryOnImgUrlApi.CreateSpuTryOnImgUrl)   // 创建商品试戴图片
		router.PUT("spuTryOnImgUrl", spuTryOnImgUrlApi.UpdateSpuTryOnImgUrl)    // 更新商品试戴图片
		router.DELETE("spuTryOnImgUrl", spuTryOnImgUrlApi.DeleteSpuTryOnImgUrl) // 删除商品试戴图片
	}
	{
		routerWithoutRecord.GET("spuTryOnImgUrl", spuTryOnImgUrlApi.GetSpuTryOnImgUrl)         // 获取商品试戴图片信息
		routerWithoutRecord.GET("spuTryOnImgUrlList", spuTryOnImgUrlApi.GetSpuTryOnImgUrlList) // 获取商品试戴图片列表
	}
}
