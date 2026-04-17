package service

import (
	"github.com/flipped-aurora/gin-vue-admin/server/service/example"
	"github.com/flipped-aurora/gin-vue-admin/server/service/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/service/optometry"
	"github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/flipped-aurora/gin-vue-admin/server/service/system"
	"github.com/flipped-aurora/gin-vue-admin/server/service/wechat"
)

var ServiceGroupApp = new(ServiceGroup)

type ServiceGroup struct {
	SystemServiceGroup    system.ServiceGroup
	ExampleServiceGroup   example.ServiceGroup
	StoreServiceGroup     store.ServiceGroup
	OptometryServiceGroup optometry.ServiceGroup
	MallServiceGroup      mall.ServiceGroup
	WechatServiceGroup    wechat.ServiceGroup
}
