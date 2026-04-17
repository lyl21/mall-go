package mall

import "time"

// OrderLogistics 订单物流表
type OrderLogistics struct {
	Id          string     `json:"id" gorm:"column:id;primaryKey;type:varchar(32);comment:PK"`
	DelFlag     string     `json:"delFlag" gorm:"column:del_flag;type:char(2);not null;default:'0';comment:逻辑删除标记（0：显示；1：隐藏）"`
	CreateTime  time.Time  `json:"createTime" gorm:"column:create_time;autoCreateTime;comment:创建时间"`
	UpdateTime  time.Time  `json:"updateTime" gorm:"column:update_time;autoUpdateTime;comment:最后更新时间"`
	PostalCode  *string    `json:"postalCode" gorm:"column:postal_code;type:varchar(10);comment:邮编"`
	UserName    string     `json:"userName" gorm:"column:user_name;type:varchar(50);not null;comment:收货人名字"`
	TelNum      string     `json:"telNum" gorm:"column:tel_num;type:varchar(20);not null;comment:电话号码"`
	Address     string     `json:"address" gorm:"column:address;type:varchar(255);not null;comment:详细地址"`
	Logistics   *string    `json:"logistics" gorm:"column:logistics;type:char(20);comment:物流商家"`
	LogisticsNo *string    `json:"logisticsNo" gorm:"column:logistics_no;type:varchar(30);comment:物流单号"`
	Status      *string    `json:"status" gorm:"column:status;type:char(2);comment:快递单当前状态"`
	IsCheck     *string    `json:"isCheck" gorm:"column:is_check;type:char(2);comment:签收标记（0：未签收；1：已签收）"`
	Message     *string    `json:"message" gorm:"column:message;type:varchar(500);comment:相关信息"`
}

func (OrderLogistics) TableName() string { return "order_logistics" }
