package config

// WechatMiniProgram 微信小程序配置
type WechatMiniProgram struct {
	AppID     string `mapstructure:"app-id" json:"appId" yaml:"app-id"`
	AppSecret string `mapstructure:"app-secret" json:"appSecret" yaml:"app-secret"`
}
