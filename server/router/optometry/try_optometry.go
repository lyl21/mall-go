package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type TryOptometryRouter struct{}

func (r *TryOptometryRouter) InitTryOptometryRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.POST("createTryOptometry", tryOptometryApi.CreateTryOptometry)
		withRecord.PUT("updateTryOptometry", tryOptometryApi.UpdateTryOptometry)
		withRecord.DELETE("deleteTryOptometry", tryOptometryApi.DeleteTryOptometry)
	}
	{
		noRecord.POST("getTryOptometryList", tryOptometryApi.GetTryOptometryList)
		noRecord.GET("getTryOptometry", tryOptometryApi.GetTryOptometry)
	}
}
