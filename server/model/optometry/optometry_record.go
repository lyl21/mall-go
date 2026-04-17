package optometry

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// OptometryRecord 验光记录表
type OptometryRecord struct {
	OptometryRecordsId int64           `json:"optometryRecordsId" gorm:"column:optometry_records_id;primaryKey;autoIncrement;comment:验光记录ID"`
	CreateTime         common.BizModel `gorm:"embedded"`
	CustomerId         *int64          `json:"customerId" gorm:"column:customer_id;comment:顾客ID"`
	CustomerName       string          `json:"customerName" gorm:"column:customer_name;type:varchar(255);not null;comment:顾客姓名"`
	OptometristId      int64           `json:"optometristId" gorm:"column:optometrist_id;not null;comment:验光师ID"`
	OptometristName    string          `json:"optometristName" gorm:"column:optometrist_name;type:varchar(255);comment:验光师姓名"`
	StoreId            int64           `json:"storeId" gorm:"column:store_id;not null;comment:门店ID"`
	StoreName          string          `json:"storeName" gorm:"column:store_name;type:varchar(255);not null;comment:门店名称"`
	StorePhone         string          `json:"storePhone" gorm:"column:store_phone;type:varchar(20);not null;comment:门店电话"`
	IsDelete           int             `json:"isDelete" gorm:"column:is_delete;type:int(1);not null;default:0;comment:逻辑删0否1是"`
	// 关联
	DataList         []OptometryData   `json:"dataList" gorm:"foreignKey:OptometryRecordsId"`
	VisionResult     *VisionTestResult `json:"visionResult" gorm:"foreignKey:OptometryRecordsId"`
	TryOptometryList []TryOptometry    `json:"tryOptometryList" gorm:"foreignKey:ResultsId"`
}

func (OptometryRecord) TableName() string { return "optometry_records" }
