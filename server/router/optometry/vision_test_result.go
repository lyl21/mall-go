package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type VisionTestResultRouter struct{}

func (r *VisionTestResultRouter) InitVisionTestResultRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.POST("createVisionTestResult", visionTestResultApi.CreateVisionTestResult)
		withRecord.PUT("updateVisionTestResult", visionTestResultApi.UpdateVisionTestResult)
		withRecord.DELETE("deleteVisionTestResult", visionTestResultApi.DeleteVisionTestResult)
	}
	{
		noRecord.POST("getVisionTestResultList", visionTestResultApi.GetVisionTestResultList)
		noRecord.GET("getVisionTestResult", visionTestResultApi.GetVisionTestResult)
		noRecord.GET("getVisionTestAndTryOn", visionTestResultApi.GetVisionTestAndTryOn)
	}
}
