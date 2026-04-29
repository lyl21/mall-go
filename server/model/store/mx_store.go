package store

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// MxStore 门店信息表
type MxStore struct {
	StoreId         int64       `json:"storeId" gorm:"column:store_id;primaryKey;autoIncrement;comment:门店ID"`
	CreateTime      common.BizModel `gorm:"embedded"`
	UserId          int64       `json:"userId" gorm:"column:user_id;not null;comment:用户ID"`
	BrandId         string      `json:"brandId" gorm:"column:brand_id;type:varchar(50);default:'';comment:品牌编号"`
	StoreNumber     string      `json:"storeNumber" gorm:"column:store_number;type:varchar(50);default:'';comment:门店编号"`
	StoreNameEnglish string     `json:"storeNameEnglish" gorm:"column:store_name_english;type:varchar(50);default:'';comment:门店名称"`
	StorePhone      string      `json:"storePhone" gorm:"column:store_phone;type:varchar(20);default:'';comment:门店电话"`
	IsDelete        int         `json:"isDelete" gorm:"column:is_delete;type:int(1);default:0;comment:逻辑删0否1是"`
}

func (MxStore) TableName() string { return "mx_store" }
