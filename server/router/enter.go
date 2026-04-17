package router

import (
	"github.com/flipped-aurora/gin-vue-admin/server/router/client"
	"github.com/flipped-aurora/gin-vue-admin/server/router/example"
	"github.com/flipped-aurora/gin-vue-admin/server/router/mall"
	"github.com/flipped-aurora/gin-vue-admin/server/router/optometry"
	"github.com/flipped-aurora/gin-vue-admin/server/router/store"
	"github.com/flipped-aurora/gin-vue-admin/server/router/system"
	"github.com/flipped-aurora/gin-vue-admin/server/router/wechat"
)

var RouterGroupApp = new(RouterGroup)

type RouterGroup struct {
	System    system.RouterGroup
	Example   example.RouterGroup
	Store     store.RouterGroup
	Optometry optometry.RouterGroup
	Mall      mall.RouterGroup
	Wechat    wechat.RouterGroup
	Client    client.RouterGroup
}
