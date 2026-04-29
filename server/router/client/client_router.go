package client

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type ClientRouter struct{}

// InitClientPublicRouter 注册客户端公开路由（不需要 JWT 认证）
func (r *ClientRouter) InitClientPublicRouter(publicGroup *gin.RouterGroup) {
	clientGroup := publicGroup.Group("client")
	{
		// 设备管理
		codeGroup := clientGroup.Group("code")
		{
			codeGroup.GET("app", clientDeviceApi.GetAppVersion)
			codeGroup.GET("keyboard", clientDeviceApi.GetKeyboardVersion)
			codeGroup.GET("app/optometer", clientDeviceApi.GetOptometerVersion)
			codeGroup.GET("app/optometer/manual", clientDeviceApi.GetOptometerManualVersion)
			codeGroup.POST("equipment", clientDeviceApi.RegisterDevice)
			codeGroup.POST("upload", clientDeviceApi.UploadErrorLog)
		}

		// 用户登录（公开路由）
		clientGroup.POST("login", clientUserApi.Login)
		// 用户注册（公开路由）
		clientGroup.POST("register", clientUserApi.Register)
		// 修改密码（公开路由）
		clientGroup.POST("change_password", clientUserApi.ChangePassword)
	}

	// 需要客户端JWT认证的路由
	clientPrivateGroup := publicGroup.Group("client")
	clientPrivateGroup.Use(middleware.ClientAuth())
	{
		clientPrivateGroup.POST("logout", clientUserApi.Logout)
		clientPrivateGroup.DELETE("logout", clientUserApi.Logout)
		clientPrivateGroup.POST("refresh", clientUserApi.RefreshToken)
		clientPrivateGroup.GET("user/info", clientUserApi.GetUserInfo)

		// MxUser RESTful 路由
		mxuserGroup := clientPrivateGroup.Group("mxuser")
		{
			mxuserGroup.GET("/list", clientMxUserApi.List)
			mxuserGroup.GET("", clientMxUserApi.GetInfo)
			mxuserGroup.POST("", clientMxUserApi.Add)
			mxuserGroup.PUT("", clientMxUserApi.Edit)
			mxuserGroup.DELETE("/:userIds", clientMxUserApi.Remove)
		}

		// MxUserFlow RESTful 路由
		flowGroup := clientPrivateGroup.Group("flow")
		{
			flowGroup.GET("/list", clientMxUserFlowApi.List)
			flowGroup.POST("", clientMxUserFlowApi.Add)
			flowGroup.PUT("", clientMxUserFlowApi.Edit)
			flowGroup.DELETE("/:flowIds", clientMxUserFlowApi.Remove)
		}

		// MxStoreMember RESTful 路由
		memberGroup := clientPrivateGroup.Group("member")
		{
			memberGroup.GET("/list", clientMxStoreMemberApi.List)
			memberGroup.GET("/byStoreIdUserId", clientMxStoreMemberApi.GetInfo)
			memberGroup.POST("", clientMxStoreMemberApi.Add)
			memberGroup.PUT("", clientMxStoreMemberApi.Edit)
			memberGroup.DELETE("/:storeIds", clientMxStoreMemberApi.Remove)
		}

		// MxStore RESTful 路由
		storeGroup := clientPrivateGroup.Group("store")
		{
			storeGroup.GET("/list", clientMxStoreApi.List)
			storeGroup.GET("/:storeId", clientMxStoreApi.GetInfo)
			storeGroup.POST("", clientMxStoreApi.Add)
			storeGroup.PUT("", clientMxStoreApi.Edit)
			storeGroup.DELETE("/:storeIds", clientMxStoreApi.Remove)
		}

		// OptometryData RESTful 路由
		dataGroup := clientPrivateGroup.Group("data")
		{
			dataGroup.GET("/list", clientOptometryDataApi.List)
			dataGroup.GET("/:optometryId", clientOptometryDataApi.GetInfo)
			dataGroup.GET("/byRecord/:recordsId", clientOptometryDataApi.GetByRecordId)
			dataGroup.POST("", clientOptometryDataApi.Add)
			dataGroup.PUT("", clientOptometryDataApi.Edit)
			dataGroup.DELETE("/:optometryIds", clientOptometryDataApi.Remove)
		}

		// VisionTestResult RESTful 路由
		resultsGroup := clientPrivateGroup.Group("results")
		{
			resultsGroup.GET("/list", clientVisionTestResultApi.List)
			resultsGroup.GET("/:resultsId", clientVisionTestResultApi.GetInfo)
			resultsGroup.GET("/byRecord/:recordsId", clientVisionTestResultApi.GetByRecordId)
			resultsGroup.POST("", clientVisionTestResultApi.Add)
			resultsGroup.PUT("", clientVisionTestResultApi.Edit)
			resultsGroup.DELETE("/:resultsIds", clientVisionTestResultApi.Remove)
		}

		// OptometryRecord RESTful 路由
		recordsGroup := clientPrivateGroup.Group("records")
		{
			recordsGroup.GET("/list", clientOptometryRecordApi.List)
			recordsGroup.GET("/list/byCustomerId", clientOptometryRecordApi.ListByCustomerId)
			recordsGroup.GET("/Optometry", clientOptometryRecordApi.GetOptometry)
			recordsGroup.GET("/VisionTestResultsTryOptomentry", clientOptometryRecordApi.GetVisionTestResultsTryOptomentry)
			recordsGroup.GET("/:recordsId", clientOptometryRecordApi.GetInfo)
			recordsGroup.POST("", clientOptometryRecordApi.Add)
			recordsGroup.POST("/insert", clientOptometryRecordApi.Insert)
			recordsGroup.PUT("", clientOptometryRecordApi.Edit)
			recordsGroup.DELETE("/:recordsIds", clientOptometryRecordApi.Remove)
		}

		// TryOptometry RESTful 路由
		optometryGroup := clientPrivateGroup.Group("optometry")
		{
			optometryGroup.GET("/list", clientTryOptometryApi.List)
			optometryGroup.GET("/:tryOptometryId", clientTryOptometryApi.GetInfo)
			optometryGroup.GET("/byResults/:resultsId", clientTryOptometryApi.GetByResultsId)
			optometryGroup.POST("", clientTryOptometryApi.Add)
			optometryGroup.PUT("", clientTryOptometryApi.Edit)
			optometryGroup.DELETE("/:tryOptometryIds", clientTryOptometryApi.Remove)
		}
	}
}
