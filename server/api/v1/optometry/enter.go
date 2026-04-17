package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/service"
)

type ApiGroup struct {
	OptometryRecordApi
	OptometryDataApi
	VisionTestResultApi
	TryOptometryApi
}

var (
	optometryRecordService  = service.ServiceGroupApp.OptometryServiceGroup.OptometryRecordService
	optometryDataService    = service.ServiceGroupApp.OptometryServiceGroup.OptometryDataService
	visionTestResultService = service.ServiceGroupApp.OptometryServiceGroup.VisionTestResultService
	tryOptometryService     = service.ServiceGroupApp.OptometryServiceGroup.TryOptometryService
)
