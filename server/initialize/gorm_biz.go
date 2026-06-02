package initialize

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
	sysModel "github.com/flipped-aurora/gin-vue-admin/server/model/system"
	wechatModel "github.com/flipped-aurora/gin-vue-admin/server/model/wechat"
	"go.uber.org/zap"
)

func bizModel() error {
	db := global.GVA_DB

	// 迁移前预处理: installing_packages表version_code列已有NULL值时设为1, 避免NOT NULL约束报Data truncated
	if db.Migrator().HasTable(&storeModel.InstallingPackage{}) {
		if db.Migrator().HasColumn(&storeModel.InstallingPackage{}, "version_code") {
			db.Exec("UPDATE installing_packages SET version_code = 1 WHERE version_code IS NULL")
		}
	}

	err := db.AutoMigrate(
		// 门店管理
		&storeModel.MxStore{},
		&storeModel.MxStoreMember{},
		&storeModel.MxUser{},
		&storeModel.MxUserFlow{},
		&storeModel.MxActivationCode{},
		&storeModel.MxPicture{},
		&storeModel.InstallingPackage{},
		&storeModel.ErrorReportLog{},
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

// InitSysParams 初始化系统参数（微信/门锁/支付/声网配置）
// 仅插入 sys_params 表中不存在的 key，已存在的不会覆盖
func InitSysParams() {
	if global.GVA_DB == nil {
		return
	}

	// 从 config.yaml 读取默认值
	cfg := global.GVA_CONFIG
	params := []sysModel.SysParams{
		// 微信相关（小程序 + 支付）
		{Name: "微信小程序AppID", Key: "wechat.mini.app.id", Value: cfg.WechatMiniProgram.AppID, Desc: "微信小程序AppID（登录+支付共用），优先级高于config.yaml"},
		{Name: "微信小程序AppSecret", Key: "wechat.mini.app.secret", Value: cfg.WechatMiniProgram.AppSecret, Desc: "微信小程序AppSecret，优先级高于config.yaml"},
		{Name: "微信登录回调域", Key: "wx.miniapp.redirecturi", Value: "", Desc: "微信登录回调域名"},
		{Name: "微信支付商户号", Key: "wechat.pay.mch.id", Value: cfg.Wechat.MchID, Desc: "微信支付商户号，优先级高于config.yaml"},
		{Name: "微信支付API密钥", Key: "wechat.pay.api.key", Value: cfg.Wechat.APIKey, Desc: "微信支付API密钥(V2)，优先级高于config.yaml"},
		{Name: "微信支付回调地址", Key: "wechat.pay.notify.url", Value: cfg.Wechat.NotifyURL, Desc: "微信支付回调通知地址，优先级高于config.yaml"},
		{Name: "微信支付APIv3密钥", Key: "wechat.pay.apiv3.key", Value: cfg.Wechat.MchAPIv3Key, Desc: "微信支付APIv3密钥(V3)，优先级高于config.yaml"},
		{Name: "微信支付证书序列号", Key: "wx.pay.certificate.serialnumber", Value: cfg.Wechat.MchCertificateSerialNumber, Desc: "微信支付商户证书序列号，优先级高于config.yaml"},
		{Name: "微信支付p12证书路径", Key: "wechat.pay.certificate.p12.path", Value: cfg.Wechat.MchCertP12Path, Desc: "微信支付商户p12证书(apiclient_cert.p12)路径(V2退款使用)，优先级高于config.yaml"},
		{Name: "微信支付私钥路径", Key: "wx.pay.privatekey.path", Value: cfg.Wechat.MchPrivateKeyPath, Desc: "微信支付商户私钥(apiclient_key.pem)路径，优先级高于config.yaml"},

		// 第三方门锁平台
		{Name: "门锁平台地址", Key: "door.lock.base.url", Value: cfg.DoorLock.BaseURL, Desc: "第三方门锁云平台地址"},
		{Name: "门锁平台用户名", Key: "door.lock.username", Value: cfg.DoorLock.Username, Desc: "第三方门锁云平台登录用户名"},
		{Name: "门锁平台密码", Key: "door.lock.password", Value: cfg.DoorLock.Password, Desc: "第三方门锁云平台登录密码"},
		{Name: "门锁平台场站编号", Key: "door.lock.yard.sn", Value: cfg.DoorLock.YardSn, Desc: "第三方门锁云平台场站编号"},
		{Name: "门锁平台供应商编码", Key: "door.lock.gyscode", Value: cfg.DoorLock.Gyscode, Desc: "第三方门锁云平台供应商编码"},

		// 声网
		{Name: "声网AppID", Key: "agora.app.id", Value: cfg.Agora.AppId, Desc: "声网Agora AppID"},
		{Name: "声网AppCertificate", Key: "agora.app.certificate", Value: cfg.Agora.AppCertificate, Desc: "声网Agora AppCertificate"},
	}

	for _, p := range params {
		var count int64
		global.GVA_DB.Model(&sysModel.SysParams{}).Where("`key` = ?", p.Key).Count(&count)
		if count == 0 {
			if err := global.GVA_DB.Create(&p).Error; err != nil {
				global.GVA_LOG.Error("初始化系统参数失败", zap.String("key", p.Key), zap.Error(err))
			}
		}
	}
}
