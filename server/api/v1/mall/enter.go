package mall

import (
	"github.com/flipped-aurora/gin-vue-admin/server/service"
)

type ApiGroup struct {
	GoodsCategoryApi
	GoodsSpuApi
	GoodsSpuBannerApi
	SpuTryOnImgUrlApi
	TryOnGlassImgUrlApi
	OrderInfoApi
	OrderItemApi
	OrderLogisticsApi
	DoorLockApi
	DoorLockHistoryApi
}

var (
	goodsCategoryService    = service.ServiceGroupApp.MallServiceGroup.GoodsCategoryService
	goodsSpuService         = service.ServiceGroupApp.MallServiceGroup.GoodsSpuService
	goodsSpuBannerService   = service.ServiceGroupApp.MallServiceGroup.GoodsSpuBannerService
	spuTryOnImgUrlService   = service.ServiceGroupApp.MallServiceGroup.SpuTryOnImgUrlService
	tryOnGlassImgUrlService = service.ServiceGroupApp.MallServiceGroup.TryOnGlassImgUrlService
	orderInfoService        = service.ServiceGroupApp.MallServiceGroup.OrderInfoService
	orderItemService        = service.ServiceGroupApp.MallServiceGroup.OrderItemService
	orderLogisticsService   = service.ServiceGroupApp.MallServiceGroup.OrderLogisticsService
	doorLockService         = service.ServiceGroupApp.MallServiceGroup.DoorLockService
	doorLockHistoryService  = service.ServiceGroupApp.MallServiceGroup.DoorLockHistoryService
)
