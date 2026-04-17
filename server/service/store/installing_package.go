package store

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	storeModel "github.com/flipped-aurora/gin-vue-admin/server/model/store"
)

type InstallingPackageService struct{}

var InstallingPackageServiceApp = new(InstallingPackageService)

func (s *InstallingPackageService) CreateInstallingPackage(pkg storeModel.InstallingPackage) (err error) {
	err = global.GVA_DB.Create(&pkg).Error
	return err
}

func (s *InstallingPackageService) DeleteInstallingPackage(pkg storeModel.InstallingPackage) (err error) {
	err = global.GVA_DB.Delete(&pkg).Error
	return err
}

func (s *InstallingPackageService) UpdateInstallingPackage(pkg storeModel.InstallingPackage) (err error) {
	err = global.GVA_DB.Select("packageName", "app", "url", "versionName", "note", "forceUpdate").Save(&pkg).Error
	return err
}

func (s *InstallingPackageService) GetInstallingPackage(id int64) (pkg storeModel.InstallingPackage, err error) {
	err = global.GVA_DB.Where("installing_id = ?", id).First(&pkg).Error
	return
}

func (s *InstallingPackageService) GetInstallingPackageList(info request.PageInfo) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&storeModel.InstallingPackage{})
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var pkgList []storeModel.InstallingPackage
	err = db.Limit(limit).Offset(offset).Find(&pkgList).Error
	return pkgList, total, err
}
