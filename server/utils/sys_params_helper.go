package utils

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/system"
	"go.uber.org/zap"
)

// GetParamValue 从 sys_params 表根据 key 获取参数值，不存在则返回默认值
func GetParamValue(key string, defaultVal string) string {
	var param system.SysParams
	err := global.GVA_DB.Where("`key` = ?", key).First(&param).Error
	if err != nil {
		global.GVA_LOG.Debug("sys_params 未找到参数，使用默认值",
			zap.String("key", key),
			zap.String("defaultVal", defaultVal))
		return defaultVal
	}
	return param.Value
}
