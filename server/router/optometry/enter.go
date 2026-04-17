package optometry

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	OptometryRecordRouter
	OptometryDataRouter
	VisionTestResultRouter
	TryOptometryRouter
}

var (
	optometryRecordApi  = api.ApiGroupApp.OptometryApiGroup.OptometryRecordApi
	optometryDataApi    = api.ApiGroupApp.OptometryApiGroup.OptometryDataApi
	visionTestResultApi = api.ApiGroupApp.OptometryApiGroup.VisionTestResultApi
	tryOptometryApi     = api.ApiGroupApp.OptometryApiGroup.TryOptometryApi
)
