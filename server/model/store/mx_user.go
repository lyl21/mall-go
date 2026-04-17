package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
)

// MxUser 用户信息表
type MxUser struct {
	UserId                 int64           `json:"userId" gorm:"column:user_id;primaryKey;autoIncrement;comment:用户ID"`
	CreateTime             common.BizModel `gorm:"embedded"`
	LatestCheckupDateTime  *common.DateTime `json:"latestCheckupDateTime" gorm:"column:latest_checkup_date_time;comment:最近检查日期"`
	Name                   string          `json:"name" gorm:"column:name;type:varchar(24);default:'';comment:姓名"`
	Gender                 int             `json:"gender" gorm:"column:gender;type:int(1);default:1;comment:性别 1:男性 0:女性"`
	DateOfBirth            *common.DateTime `json:"dateOfBirth" gorm:"column:date_of_birth;comment:出生年月"`
	Age                    *int       `json:"age" gorm:"column:age;type:int(11);comment:年龄"`
	PhoneNumber            string     `json:"phoneNumber" gorm:"column:phone_number;type:varchar(50);not null;uniqueIndex:u_p;comment:手机号码"`
	Password               string     `json:"password" gorm:"column:password;type:varchar(255);not null;default:'';comment:密码"`
	QQNumber               string     `json:"qqNumber" gorm:"column:qq_number;type:varchar(50);default:'';comment:qq号"`
	EmailAddress           string     `json:"emailAddress" gorm:"column:email_address;type:varchar(50);default:'';comment:邮箱"`
	IdentificationNumber   string     `json:"identificationNumber" gorm:"column:identification_number;type:varchar(50);default:'';comment:身份证号"`
	Wechat                 string     `json:"wechat" gorm:"column:wechat;type:varchar(50);default:'';comment:微信"`
	Openid                 string     `json:"openid" gorm:"column:openid;type:varchar(100);default:'';comment:微信openid"`
	Unionid                string     `json:"unionid" gorm:"column:unionid;type:varchar(100);default:'';comment:微信unionid"`
	AvatarUrl              string     `json:"avatarUrl" gorm:"column:avatar_url;type:varchar(500);default:'';comment:微信头像"`
	WxNickName             string     `json:"wxNickName" gorm:"column:wx_nick_name;type:varchar(200);default:'';comment:微信昵称"`
	WxPhone                string     `json:"wxPhone" gorm:"column:wx_phone;type:varchar(50);default:'';comment:微信手机号"`
	SubscribeTime          *common.DateTime `json:"subscribeTime" gorm:"column:subscribe_time;comment:关注时间"`
	UserRole               int        `json:"userRole" gorm:"column:user_role;type:int(1);default:0;comment:用户身份0普通顾客1店长2验光师"`
	MedicalInsuranceAccount string     `json:"medicalInsuranceAccount" gorm:"column:medical_insurance_account;type:varchar(50);default:'';comment:医保账号"`
	City                   string     `json:"city" gorm:"column:city;type:varchar(50);default:'';comment:城市"`
	ContactAddress         string     `json:"contactAddress" gorm:"column:contact_address;type:varchar(500);default:'';comment:联系地址"`
	Occupation             string     `json:"occupation" gorm:"column:occupation;type:varchar(50);default:'';comment:职业"`
	Company                string     `json:"company" gorm:"column:company;type:varchar(50);default:'';comment:单位"`
	Remarks                string     `json:"remarks" gorm:"column:remarks;type:varchar(500);default:'';comment:备注"`
	GlassesNeed            string     `json:"glassesNeed" gorm:"column:glasses_need;type:varchar(50);default:'';comment:配镜需求"`
	DominantEye            string     `json:"dominantEye" gorm:"column:dominant_eye;type:varchar(50);default:'';comment:主视眼"`
	IsDelete               int        `json:"isDelete" gorm:"column:is_delete;type:int(1);default:0;comment:逻辑删0否1是"`
}

func (MxUser) TableName() string { return "mx_user" }
