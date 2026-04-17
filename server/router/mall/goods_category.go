package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type GoodsCategoryRouter struct{}

func (r *GoodsCategoryRouter) InitGoodsCategoryRouter(Router *gin.RouterGroup) {
	categoryRouter := Router.Group("mall").Use(middleware.OperationRecord())
	categoryRouterWithoutRecord := Router.Group("mall")
	{
		categoryRouter.POST("goodsCategory", goodsCategoryApi.CreateGoodsCategory)   // 创建商品分类
		categoryRouter.PUT("goodsCategory", goodsCategoryApi.UpdateGoodsCategory)    // 更新商品分类
		categoryRouter.DELETE("goodsCategory", goodsCategoryApi.DeleteGoodsCategory) // 删除商品分类
	}
	{
		categoryRouterWithoutRecord.GET("goodsCategory", goodsCategoryApi.GetGoodsCategory)          // 获取商品分类信息
		categoryRouterWithoutRecord.GET("goodsCategoryList", goodsCategoryApi.GetGoodsCategoryList)  // 获取商品分类列表
		categoryRouterWithoutRecord.GET("goodsCategoryTree", goodsCategoryApi.GetGoodsCategoryTree) // 获取商品分类树
	}
}
