package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
)

type UserService struct{}

var UserServiceApp = new(UserService)

func (s *UserService) CreateMxUser(user storeModel.MxUser) (err error) {
	err = global.GVA_DB.Create(&user).Error
	return err
}

func (s *UserService) DeleteMxUser(user storeModel.MxUser) (err error) {
	err = global.GVA_DB.Model(&user).Where("user_id = ?", user.UserId).Update("is_delete", 1).Error
	return err
}

func (s *UserService) UpdateMxUser(user storeModel.MxUser) (err error) {
	// 只更新允许编辑的字段，避免覆盖自动计算的字段如最近验光时间
	updateData := map[string]interface{}{
		"name":                     user.Name,
		"gender":                   user.Gender,
		"date_of_birth":            user.DateOfBirth,
		"age":                      user.Age,
		"phone_number":             user.PhoneNumber,
		"qq_number":                user.QQNumber,
		"email_address":            user.EmailAddress,
		"identification_number":    user.IdentificationNumber,
		"wechat":                   user.Wechat,
		"wx_nick_name":             user.WxNickName,
		"wx_phone":                 user.WxPhone,
		"user_role":                user.UserRole,
		"medical_insurance_account": user.MedicalInsuranceAccount,
		"city":                     user.City,
		"contact_address":          user.ContactAddress,
		"occupation":               user.Occupation,
		"company":                  user.Company,
		"remarks":                  user.Remarks,
		"glasses_need":             user.GlassesNeed,
		"dominant_eye":             user.DominantEye,
	}
	err = global.GVA_DB.Table("mx_user").Where("user_id = ?", user.UserId).Updates(updateData).Error
	return err
}

func (s *UserService) GetMxUser(id int64) (user storeModel.MxUser, err error) {
	err = global.GVA_DB.Where("user_id = ? AND is_delete = ?", id, 0).First(&user).Error
	return
}

func (s *UserService) GetMxUserList(info request.PageInfo, search string) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&storeModel.MxUser{}).Where("is_delete = ?", 0)
	if search != "" {
		db = db.Where("name LIKE ? OR phone_number LIKE ?", "%"+search+"%", "%"+search+"%")
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var userList []storeModel.MxUser
	err = db.Limit(limit).Offset(offset).Find(&userList).Error
	return userList, total, err
}
