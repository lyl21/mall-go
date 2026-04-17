package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type OptometryDataRouter struct{}

func (r *OptometryDataRouter) InitOptometryDataRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.POST("createOptometryData", optometryDataApi.CreateOptometryData)
		withRecord.PUT("updateOptometryData", optometryDataApi.UpdateOptometryData)
		withRecord.DELETE("deleteOptometryData", optometryDataApi.DeleteOptometryData)
	}
	{
		noRecord.POST("getOptometryDataList", optometryDataApi.GetOptometryDataList)
		noRecord.GET("getOptometryData", optometryDataApi.GetOptometryData)
		noRecord.GET("getOptometryDataByType1", optometryDataApi.GetOptometryDataByType1)
		noRecord.GET("getOptometryDataByType2", optometryDataApi.GetOptometryDataByType2)
		noRecord.GET("getOptometryDataByType3", optometryDataApi.GetOptometryDataByType3)
	}
}
