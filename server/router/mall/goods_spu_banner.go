package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type GoodsSpuBannerRouter struct{}

func (r *GoodsSpuBannerRouter) InitGoodsSpuBannerRouter(Router *gin.RouterGroup) {
	bannerRouter := Router.Group("mall").Use(middleware.OperationRecord())
	bannerRouterWithoutRecord := Router.Group("mall")
	{
		bannerRouter.POST("goodsSpuBanner", goodsSpuBannerApi.CreateGoodsSpuBanner)   // 创建商品轮播图
		bannerRouter.PUT("goodsSpuBanner", goodsSpuBannerApi.UpdateGoodsSpuBanner)    // 更新商品轮播图
		bannerRouter.DELETE("goodsSpuBanner", goodsSpuBannerApi.DeleteGoodsSpuBanner) // 删除商品轮播图
	}
	{
		bannerRouterWithoutRecord.GET("goodsSpuBanner", goodsSpuBannerApi.GetGoodsSpuBanner)         // 获取商品轮播图信息
		bannerRouterWithoutRecord.GET("goodsSpuBannerList", goodsSpuBannerApi.GetGoodsSpuBannerList) // 获取商品轮播图列表
	}
}
