package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type GoodsSpuRouter struct{}

func (r *GoodsSpuRouter) InitGoodsSpuRouter(Router *gin.RouterGroup) {
	spuRouter := Router.Group("mall").Use(middleware.OperationRecord())
	spuRouterWithoutRecord := Router.Group("mall")
	{
		spuRouter.POST("goodsSpu", goodsSpuApi.CreateGoodsSpu)   // 创建商品SPU
		spuRouter.PUT("goodsSpu", goodsSpuApi.UpdateGoodsSpu)    // 更新商品SPU
		spuRouter.DELETE("goodsSpu", goodsSpuApi.DeleteGoodsSpu) // 删除商品SPU
	}
	{
		spuRouterWithoutRecord.GET("goodsSpu", goodsSpuApi.GetGoodsSpu)         // 获取商品SPU信息
		spuRouterWithoutRecord.GET("goodsSpuList", goodsSpuApi.GetGoodsSpuList) // 获取商品SPU列表
	}
}
