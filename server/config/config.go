package config

type Server struct {
	JWT       JWT     `mapstructure:"jwt" json:"jwt" yaml:"jwt"`
	Zap       Zap     `mapstructure:"zap" json:"zap" yaml:"zap"`
	Redis     Redis   `mapstructure:"redis" json:"redis" yaml:"redis"`
	RedisList []Redis `mapstructure:"redis-list" json:"redis-list" yaml:"redis-list"`
	Mongo     Mongo   `mapstructure:"mongo" json:"mongo" yaml:"mongo"`
	Email     Email   `mapstructure:"email" json:"email" yaml:"email"`
	System    System  `mapstructure:"system" json:"system" yaml:"system"`
	Captcha   Captcha `mapstructure:"captcha" json:"captcha" yaml:"captcha"`
	// auto
	AutoCode Autocode `mapstructure:"autocode" json:"autocode" yaml:"autocode"`
	// gorm
	Mysql  Mysql           `mapstructure:"mysql" json:"mysql" yaml:"mysql"`
	Mssql  Mssql           `mapstructure:"mssql" json:"mssql" yaml:"mssql"`
	Pgsql  Pgsql           `mapstructure:"pgsql" json:"pgsql" yaml:"pgsql"`
	Oracle Oracle          `mapstructure:"oracle" json:"oracle" yaml:"oracle"`
	Sqlite Sqlite          `mapstructure:"sqlite" json:"sqlite" yaml:"sqlite"`
	DBList []SpecializedDB `mapstructure:"db-list" json:"db-list" yaml:"db-list"`
	// oss
	Local        Local        `mapstructure:"local" json:"local" yaml:"local"`
	Qiniu        Qiniu        `mapstructure:"qiniu" json:"qiniu" yaml:"qiniu"`
	AliyunOSS    AliyunOSS    `mapstructure:"aliyun-oss" json:"aliyun-oss" yaml:"aliyun-oss"`
	HuaWeiObs    HuaWeiObs    `mapstructure:"hua-wei-obs" json:"hua-wei-obs" yaml:"hua-wei-obs"`
	TencentCOS   TencentCOS   `mapstructure:"tencent-cos" json:"tencent-cos" yaml:"tencent-cos"`
	AwsS3        AwsS3        `mapstructure:"aws-s3" json:"aws-s3" yaml:"aws-s3"`
	CloudflareR2 CloudflareR2 `mapstructure:"cloudflare-r2" json:"cloudflare-r2" yaml:"cloudflare-r2"`
	Minio        Minio        `mapstructure:"minio" json:"minio" yaml:"minio"`

	Excel Excel `mapstructure:"excel" json:"excel" yaml:"excel"`

	DiskList []DiskList `mapstructure:"disk-list" json:"disk-list" yaml:"disk-list"`

	// 跨域配置
	Cors CORS `mapstructure:"cors" json:"cors" yaml:"cors"`

	// MCP配置
	MCP MCP `mapstructure:"mcp" json:"mcp" yaml:"mcp"`

	// 微信小程序配置
	WechatMiniProgram WechatMiniProgram `mapstructure:"wechat-mini-program" json:"wechatMiniProgram" yaml:"wechat-mini-program"`

	// 微信支付配置
	Wechat WechatPayConfig `mapstructure:"wechat" json:"wechat" yaml:"wechat"`

	// Agora音视频配置
	Agora AgoraConfig `mapstructure:"agora" json:"agora" yaml:"agora"`

	// 第三方门锁平台配置
	DoorLock DoorLockConfig `mapstructure:"door-lock" json:"doorLock" yaml:"door-lock"`
}

// WechatPayConfig 微信支付配置（V2/V3 通用）
type WechatPayConfig struct {
	MiniAppID                  string `mapstructure:"mini-app-id" json:"miniAppId" yaml:"mini-app-id"`
	MchID                      string `mapstructure:"mch-id" json:"mchId" yaml:"mch-id"`
	APIKey                     string `mapstructure:"api-key" json:"apiKey" yaml:"api-key"`
	NotifyURL                  string `mapstructure:"notify-url" json:"notifyUrl" yaml:"notify-url"`
	MchCertificateSerialNumber string `mapstructure:"mch-cert-serial-no" json:"mchCertSerialNo" yaml:"mch-cert-serial-no"`
	MchPrivateKeyPath          string `mapstructure:"mch-private-key-path" json:"mchPrivateKeyPath" yaml:"mch-private-key-path"`
	MchCertP12Path             string `mapstructure:"mch-cert-p12-path" json:"mchCertP12Path" yaml:"mch-cert-p12-path"`
	MchAPIv3Key                string `mapstructure:"mch-apiv3-key" json:"mchApiv3Key" yaml:"mch-apiv3-key"`
}

// AgoraConfig Agora音视频配置
type AgoraConfig struct {
	AppId          string `mapstructure:"app-id" json:"appId" yaml:"app-id"`
	AppCertificate string `mapstructure:"app-certificate" json:"appCertificate" yaml:"app-certificate"`
}

// DoorLockConfig 第三方门锁平台配置
type DoorLockConfig struct {
	BaseURL  string `mapstructure:"base-url" json:"baseUrl" yaml:"base-url"`
	Username string `mapstructure:"username" json:"username" yaml:"username"`
	Password string `mapstructure:"password" json:"password" yaml:"password"`
	YardSn   string `mapstructure:"yard-sn" json:"yardSn" yaml:"yard-sn"`
	Gyscode  string `mapstructure:"gyscode" json:"gyscode" yaml:"gyscode"`
}
