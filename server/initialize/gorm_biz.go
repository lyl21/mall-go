package initialize

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
)

func bizModel() error {
	db := global.GVA_DB
	err := db.AutoMigrate(
		// 门店管理
		&storeModel.MxStore{},
		&storeModel.MxStoreMember{},
		&storeModel.MxUser{},
		&storeModel.MxUserFlow{},
		&storeModel.MxActivationCode{},
		&storeModel.MxPicture{},
		&storeModel.InstallingPackage{},
		// 验光管理
		&optometryModel.OptometryRecord{},
		&optometryModel.OptometryData{},
		&optometryModel.VisionTestResult{},
		&optometryModel.TryOptometry{},
		// 商城管理
		&mallModel.GoodsCategory{},
		&mallModel.GoodsSpu{},
		&mallModel.GoodsSpuBanner{},
		&mallModel.SpuTryOnImgUrl{},
		&mallModel.TryOnGlassImgUrl{},
		&mallModel.OrderInfo{},
		&mallModel.OrderItem{},
		&mallModel.OrderLogistics{},
		&mallModel.DoorLock{},
		&mallModel.DoorLockHistory{},
		// 微信管理
		&wechatModel.WxUser{},
		&wechatModel.WxMsg{},
		&wechatModel.WxMenu{},
		&wechatModel.WxAutoReply{},
	)
	if err != nil {
		return err
	}
	return nil
}
