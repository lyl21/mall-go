package mall

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// OrderInfo 订单
type OrderInfo struct {
	Id            string           `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	DelFlag       string           `json:"-" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记"`
	UserId        string           `json:"userId" gorm:"column:user_id;type:varchar(32);not null;comment:用户id"`
	OrderNo       string           `json:"orderNo" gorm:"column:order_no;type:varchar(50);not null;uniqueIndex:uk_order_no;comment:订单单号"`
	PaymentWay    string           `json:"paymentWay" gorm:"column:payment_way;type:char(2);not null;comment:支付方式1、货到付款；2、在线支付"`
	IsPay         string           `json:"isPay" gorm:"column:is_pay;type:char(2);not null;comment:是否支付0、未支付 1、已支付"`
	Name          *string          `json:"name" gorm:"column:name;type:varchar(255);comment:订单名"`
	Status        *string          `json:"status" gorm:"column:status;type:char(2);comment:订单状态0、待付款 1、待发货 2、待收货 3、已完成 5、已关闭"`
	FreightPrice  float64          `json:"freightPrice" gorm:"column:freight_price;type:decimal(10,2);not null;default:0.00;comment:运费金额"`
	SalesPrice    float64          `json:"salesPrice" gorm:"column:sales_price;type:decimal(10,2);not null;default:0.00;comment:销售金额"`
	PaymentPrice  float64          `json:"paymentPrice" gorm:"column:payment_price;type:decimal(10,2);not null;default:0.00;comment:支付金额"`
	PaymentTime   *common.DateTime `json:"paymentTime" gorm:"column:payment_time;comment:付款时间"`
	DeliveryTime  *common.DateTime `json:"deliveryTime" gorm:"column:delivery_time;comment:发货时间"`
	ReceiverTime  *common.DateTime `json:"receiverTime" gorm:"column:receiver_time;comment:收货时间"`
	ClosingTime   *common.DateTime `json:"closingTime" gorm:"column:closing_time;comment:成交时间"`
	UserMessage   *string          `json:"userMessage" gorm:"column:user_message;type:varchar(100);comment:买家留言"`
	TransactionId *string          `json:"transactionId" gorm:"column:transaction_id;type:varchar(32);comment:支付交易ID"`
	LogisticsId   *string          `json:"logisticsId" gorm:"column:logistics_id;type:varchar(32);comment:物流id"`
	Remark        *string          `json:"remark" gorm:"column:remark;type:varchar(255);comment:备注"`
	CreateTime    common.DateTime  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime    common.DateTime  `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
	// 关联
	OrderItems []OrderItem `json:"orderItems" gorm:"foreignKey:OrderId"`
	Logistics  *OrderLogistics `json:"logistics" gorm:"-"`
}

func (OrderInfo) TableName() string { return "order_info" }
