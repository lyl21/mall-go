package response

// ErrorCode 错误码结构
type ErrorCode struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// 错误码定义
var (
	// 通用错误 10000-10999
	SYSTEM_ERROR        = ErrorCode{Code: 10001, Message: "系统错误"}
	NOT_FOUND           = ErrorCode{Code: 10002, Message: "资源不存在"}
	INVALID_PARAMS      = ErrorCode{Code: 10003, Message: "参数错误"}
	UNAUTHORIZED        = ErrorCode{Code: 10004, Message: "未授权"}
	FORBIDDEN           = ErrorCode{Code: 10005, Message: "禁止访问"}

	// 订单相关错误 20000-20999
	ORDER_NOT_FOUND           = ErrorCode{Code: 20001, Message: "订单不存在"}
	ORDER_STATUS_ERROR        = ErrorCode{Code: 20002, Message: "订单状态不正确"}
	ORDER_STOCK_CONFLICT      = ErrorCode{Code: 20003, Message: "商品库存已变更，请重新下单"}
	ORDER_STOCK_INSUFFICIENT  = ErrorCode{Code: 20004, Message: "商品库存不足"}
	ORDER_ALREADY_PAID        = ErrorCode{Code: 20005, Message: "订单已支付"}
	ORDER_PAYMENT_FAILED      = ErrorCode{Code: 20006, Message: "支付失败"}
	ORDER_REFUND_FAILED       = ErrorCode{Code: 20007, Message: "退款失败"}
	ORDER_CREATE_FAILED       = ErrorCode{Code: 20008, Message: "创建订单失败"}

	// 商品相关错误 30000-30999
	GOODS_NOT_FOUND      = ErrorCode{Code: 30001, Message: "商品不存在"}
	GOODS_OFF_SHELF      = ErrorCode{Code: 30002, Message: "商品已下架"}
	GOODS_STOCK_EMPTY    = ErrorCode{Code: 30003, Message: "商品库存不足"}

	// 用户相关错误 40000-40999
	USER_NOT_FOUND       = ErrorCode{Code: 40001, Message: "用户不存在"}
	ADDRESS_NOT_FOUND    = ErrorCode{Code: 40002, Message: "收货地址不存在"}
)

// ResponseWithCode 带错误码的响应
func ResponseWithCode(code ErrorCode, c interface{}) {
	// 这里需要根据实际框架实现
	// 暂时保留结构，后续可以集成到response包中
}
