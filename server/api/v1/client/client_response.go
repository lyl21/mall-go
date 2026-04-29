package client

import (
	"net/http"

	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/gin-gonic/gin"
)

// 客户端响应码，与 Java RuoYi 服务保持一致
const (
	SUCCESS        = 200 // 操作成功
	CREATED        = 201 // 对象创建成功
	ACCEPTED       = 202 // 请求已经被接受
	NO_CONTENT     = 204 // 操作已经执行成功，但是没有返回数据
	BAD_REQUEST    = 400 // 参数列表错误（缺少，格式不匹配）
	UNAUTHORIZED   = 401 // 未授权
	FORBIDDEN      = 403 // 访问受限，授权过期
	NOT_FOUND      = 404 // 资源，服务未找到
	ERROR          = 500 // 系统内部错误
	WARN           = 601 // 系统警告消息
)

// 客户端分页响应结构(与Java TableDataInfo保持一致)
type PageResult struct {
	Total int64       `json:"total"`
	Rows  interface{} `json:"rows"`
	Code  int         `json:"code"`
	Msg   string      `json:"msg"`
}

func ClientPageResult(list interface{}, total int64, msg string, c *gin.Context) {
	c.JSON(http.StatusOK, PageResult{
		Total: total,
		Rows:  list,
		Code:  SUCCESS,
		Msg:   msg,
	})
}

func ClientResult(code int, data interface{}, msg string, c *gin.Context) {
	c.JSON(http.StatusOK, response.Response{
		Code: code,
		Data: data,
		Msg:  msg,
	})
}

func ClientOk(c *gin.Context) {
	ClientResult(SUCCESS, map[string]interface{}{}, "操作成功", c)
}

func ClientOkWithMessage(message string, c *gin.Context) {
	ClientResult(SUCCESS, map[string]interface{}{}, message, c)
}

func ClientOkWithData(data interface{}, c *gin.Context) {
	ClientResult(SUCCESS, data, "成功", c)
}

func ClientOkWithDetailed(data interface{}, message string, c *gin.Context) {
	ClientResult(SUCCESS, data, message, c)
}

func ClientFail(c *gin.Context) {
	ClientResult(ERROR, map[string]interface{}{}, "操作失败", c)
}

func ClientFailWithMessage(message string, c *gin.Context) {
	ClientResult(ERROR, map[string]interface{}{}, message, c)
}

func ClientFailWithDetailed(data interface{}, message string, c *gin.Context) {
	ClientResult(ERROR, data, message, c)
}

func ClientUnauthorized(message string, c *gin.Context) {
	ClientResult(UNAUTHORIZED, nil, message, c)
}

func ClientForbidden(message string, c *gin.Context) {
	ClientResult(FORBIDDEN, nil, message, c)
}

func ClientBadRequest(message string, c *gin.Context) {
	ClientResult(BAD_REQUEST, map[string]interface{}{}, message, c)
}

func ClientWarn(message string, c *gin.Context) {
	ClientResult(WARN, map[string]interface{}{}, message, c)
}
