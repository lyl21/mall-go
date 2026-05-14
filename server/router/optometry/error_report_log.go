package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type ErrorReportLogRouter struct{}

func (s *ErrorReportLogRouter) InitErrorReportLogRouter(Router *gin.RouterGroup) {
	withRecord := Router.Group("").Use(middleware.OperationRecord())
	noRecord := Router
	{
		withRecord.DELETE("errorReportLog", errorReportLogApi.DeleteErrorReportLog)
		withRecord.DELETE("errorReportLogBatch", errorReportLogApi.DeleteErrorReportLogByIds)
	}
	{
		noRecord.GET("errorReportLogList", errorReportLogApi.GetErrorReportLogList)
		noRecord.GET("errorReportLog", errorReportLogApi.GetErrorReportLog)
	}
}
