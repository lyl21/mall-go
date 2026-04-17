-- 插入微信小程序和支付相关配置到 sys_params 表
INSERT INTO sys_params (created_at, updated_at, name, `key`, value, `desc`) VALUES
(NOW(), NOW(), '微信小程序AppID', 'wx.miniapp.appId', 'wx457a99d69770774d', '微信小程序AppID'),
(NOW(), NOW(), '微信小程序密钥', 'wx.miniapp.secret', '86b1d5a3dea580856ed3b5a735b4168a', '微信小程序Secret密钥'),
(NOW(), NOW(), '微信支付商户号', 'wx.pay.mchId', '1712186848', '微信支付商户号'),
(NOW(), NOW(), '微信支付APIv2密钥', 'wx.pay.mchKey', '3eafd7767e5243488e79b0f68e7da100', '微信支付商户APIv2密钥'),
(NOW(), NOW(), '微信支付APIv3密钥', 'wx.pay.APIv3Key', '3597c0de7d914163acb6fcf02fc21ff9', '微信支付商户APIv3密钥'),
(NOW(), NOW(), '微信支付证书序列号', 'wx.pay.merchantSerialNumber', '52AE444F0BE10E6CDB089F8FB8D4E4E2F1086E0E', '商户证书序列号'),
(NOW(), NOW(), '微信支付p12证书路径', 'wx.pay.keyPath', '/home/wxPay/apiclient_cert.p12', 'p12证书绝对路径'),
(NOW(), NOW(), '微信支付私钥路径', 'wx.pay.privateKeyPath', '/home/wxPay/apiclient_key.pem', '商户私钥绝对路径'),
(NOW(), NOW(), '微信登录回调域', 'wx.miniapp.redirectUri', 'admin.ximingtech.com', '微信登录回调授权域'),
(NOW(), NOW(), '支付物流回调地址', 'mall.notify-host', 'http://xx.xxxx.com', '支付、物流回调地址'),
(NOW(), NOW(), '验证码类型', 'sys.captchaType', 'math', '验证码类型：math数字计算/char字符验证'),
(NOW(), NOW(), '密码最大错误次数', 'user.password.maxRetryCount', '5', '密码最大错误次数，超过则锁定'),
(NOW(), NOW(), '密码锁定时间', 'user.password.lockTime', '10', '密码锁定时间（分钟）'),
(NOW(), NOW(), 'Token有效期', 'token.expireTime', '300', 'Token有效期（分钟）'),
(NOW(), NOW(), 'Token密钥', 'token.secret', 'abcdefghijklmnopqrstuvwxyz', 'Token签名密钥'),
(NOW(), NOW(), '文件上传路径', 'sys.profile', '/home/ruoyi/uploadPath', '文件上传存储路径'),
(NOW(), NOW(), '获取IP地址开关', 'sys.addressEnabled', 'true', '是否开启获取IP地址功能');
