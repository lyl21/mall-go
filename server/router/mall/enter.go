package mall

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	GoodsCategoryRouter
	GoodsSpuRouter
	GoodsSpuBannerRouter
	SpuTryOnImgUrlRouter
	TryOnGlassImgUrlRouter
	OrderInfoRouter
	OrderItemRouter
	OrderLogisticsRouter
	DoorLockRouter
	DoorLockHistoryRouter
}

var (
	goodsCategoryApi    = api.ApiGroupApp.MallApiGroup.GoodsCategoryApi
	goodsSpuApi         = api.ApiGroupApp.MallApiGroup.GoodsSpuApi
	goodsSpuBannerApi   = api.ApiGroupApp.MallApiGroup.GoodsSpuBannerApi
	spuTryOnImgUrlApi   = api.ApiGroupApp.MallApiGroup.SpuTryOnImgUrlApi
	tryOnGlassImgUrlApi = api.ApiGroupApp.MallApiGroup.TryOnGlassImgUrlApi
	orderInfoApi        = api.ApiGroupApp.MallApiGroup.OrderInfoApi
	orderItemApi        = api.ApiGroupApp.MallApiGroup.OrderItemApi
	orderLogisticsApi   = api.ApiGroupApp.MallApiGroup.OrderLogisticsApi
	doorLockApi         = api.ApiGroupApp.MallApiGroup.DoorLockApi
	doorLockHistoryApi  = api.ApiGroupApp.MallApiGroup.DoorLockHistoryApi
)
