package mall

import "time"

// OrderItem 订单详情
type OrderItem struct {
	Id           string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	DelFlag      string     `json:"-" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记"`
	OrderId      string     `json:"orderId" gorm:"column:order_id;type:varchar(32);not null;comment:订单编号"`
	SpuId        *string    `json:"spuId" gorm:"column:spu_id;type:varchar(32);comment:商品Id"`
	SpuName      *string    `json:"spuName" gorm:"column:spu_name;type:varchar(200);comment:商品名"`
	PicUrl       string     `json:"picUrl" gorm:"column:pic_url;type:varchar(500);not null;comment:图片"`
	Quantity     int        `json:"quantity" gorm:"column:quantity;not null;comment:商品数量"`
	SalesPrice   float64    `json:"salesPrice" gorm:"column:sales_price;type:decimal(10,2);not null;comment:购买单价"`
	FreightPrice float64    `json:"freightPrice" gorm:"column:freight_price;type:decimal(10,2);default:0.00;comment:运费金额"`
	PaymentPrice float64    `json:"paymentPrice" gorm:"column:payment_price;type:decimal(10,2);default:0.00;comment:支付金额"`
	Remark       *string    `json:"remark" gorm:"column:remark;type:varchar(250);comment:备注"`
	Status       string     `json:"status" gorm:"column:status;type:char(2);default:'0';comment:状态0：正常；1：退款中；2:拒绝退款；3：同意退款"`
	IsRefund     string     `json:"isRefund" gorm:"column:is_refund;type:char(2);default:'0';comment:是否退款0:否 1：是"`
	CreateTime   time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime   time.Time  `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
}

func (OrderItem) TableName() string { return "order_item" }
