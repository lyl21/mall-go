package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type OptometryRecordRouter struct{}

func (r *OptometryRecordRouter) InitOptometryRecordRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.PUT("updateOptometryRecord", optometryRecordApi.UpdateOptometryRecord)
		withRecord.DELETE("deleteOptometryRecord", optometryRecordApi.DeleteOptometryRecord)
	}
	{
		noRecord.POST("getOptometryRecordList", optometryRecordApi.GetOptometryRecordList)
		noRecord.GET("getOptometryRecord", optometryRecordApi.GetOptometryRecord)
	}
}
