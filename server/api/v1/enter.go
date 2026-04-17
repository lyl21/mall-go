package v1

import (
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/client"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/example"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/optometry"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/store"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/system"
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1/wechat"
)

var ApiGroupApp = new(ApiGroup)

type ApiGroup struct {
	SystemApiGroup     system.ApiGroup
	ExampleApiGroup    example.ApiGroup
	StoreApiGroup      store.ApiGroup
	OptometryApiGroup  optometry.ApiGroup
	MallApiGroup       mall.ApiGroup
	WechatApiGroup     wechat.ApiGroup
	ClientApiGroup     client.ApiGroup
}
