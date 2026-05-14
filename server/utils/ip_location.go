package utils

import (
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"strings"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	"go.uber.org/zap"
)

type ipGeoResponse struct {
	Country string `json:"country"`
	Region  string `json:"regionName"`
	City    string `json:"city"`
	ISP     string `json:"isp"`
	Query   string `json:"query"`
	Status  string `json:"status"`
	Message string `json:"message"`
}

var ipGeoClient = &http.Client{Timeout: 5 * time.Second}

// GetClientIP 从 HTTP Request 提取真实客户端 IP
func GetClientIP(r *http.Request) string {
	// 优先从代理头获取
	if xff := r.Header.Get("X-Forwarded-For"); xff != "" {
		parts := strings.Split(xff, ",")
		return strings.TrimSpace(parts[0])
	}
	if xri := r.Header.Get("X-Real-IP"); xri != "" {
		return strings.TrimSpace(xri)
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return host
}

// IPToLocation 通过 IP 获取地理位置（使用 ip-api.com 免费接口）
func IPToLocation(ip string) string {
	if ip == "" || ip == "127.0.0.1" || ip == "::1" || strings.HasPrefix(ip, "192.168.") || strings.HasPrefix(ip, "10.") || strings.HasPrefix(ip, "172.") {
		return "内网"
	}

	url := fmt.Sprintf("http://ip-api.com/json/%s?lang=zh-CN&fields=country,regionName,city,isp,status,message", ip)
	resp, err := ipGeoClient.Get(url)
	if err != nil {
		return ""
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return ""
	}

	var geo ipGeoResponse
	if err := json.Unmarshal(body, &geo); err != nil {
		return ""
	}
	if geo.Status != "success" {
		return ""
	}

	location := strings.TrimSpace(geo.Country + " " + geo.Region + " " + geo.City)
	return location
}

// UpdateDeviceIPAndLocation 更新设备的 IP 和定位信息
func UpdateDeviceIPAndLocation(equipment string, ip string) {
	if ip == "" {
		return
	}
	location := IPToLocation(ip)
	updates := map[string]interface{}{
		"ip_address": ip,
	}
	if location != "" {
		updates["ip_location"] = location
	}
	// 将设备最后的位置也更新为IP定位
	if location != "" {
		updates["device_location"] = location
	}
	if err := global.GVA_DB.Model(&store.MxActivationCode{}).Where("equipment = ?", equipment).Updates(updates).Error; err != nil {
		global.GVA_LOG.Error("更新设备IP定位失败", zap.Error(err))
	}
}
