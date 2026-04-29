package optometry

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	optometryModel "github.com/flipped-aurora/gin-vue-admin/server/model/optometry"
)

type OptometryDataService struct{}

var OptometryDataServiceApp = new(OptometryDataService)

func (s *OptometryDataService) CreateOptometryData(data optometryModel.OptometryData) (err error) {
	err = global.GVA_DB.Create(&data).Error
	return err
}

func (s *OptometryDataService) DeleteOptometryData(id int64) (err error) {
	err = global.GVA_DB.Where("optometry_id = ?", id).Delete(&optometryModel.OptometryData{}).Error
	return err
}

func (s *OptometryDataService) UpdateOptometryData(data optometryModel.OptometryData) (err error) {
	err = global.GVA_DB.Select("spherical_mirror", "cylindrical_mirror", "position_of_axis", "addend", "distance_of_pupil", "horizontal_prism", "vertical_prism", "type", "near_far", "left_right_eyes").Where("optometry_id = ?", data.OptometryId).Updates(&data).Error
	return err
}

func (s *OptometryDataService) GetOptometryData(id int64) (data optometryModel.OptometryData, err error) {
	err = global.GVA_DB.Where("optometry_id = ?", id).First(&data).Error
	return
}

func (s *OptometryDataService) GetByRecordId(recordsId int64) (list []optometryModel.OptometryData, err error) {
	err = global.GVA_DB.Where("optometry_records_id = ?", recordsId).Find(&list).Error
	return
}

func (s *OptometryDataService) GetOptometryDataList(pageInfo request.PageInfo, search optometryModel.OptometryData) (list []optometryModel.OptometryData, total int64, err error) {
	limit := pageInfo.PageSize
	offset := pageInfo.PageSize * (pageInfo.Page - 1)
	
	if limit == 0 {
		limit = 10000
	}
	
	db := global.GVA_DB.Model(&optometryModel.OptometryData{})

	if search.OptometryRecordsId != nil {
		db = db.Where("optometry_records_id = ?", *search.OptometryRecordsId)
	}
	if search.Type != 0 {
		db = db.Where("type = ?", search.Type)
	}
	if search.LeftRightEyes != 0 {
		db = db.Where("left_right_eyes = ?", search.LeftRightEyes)
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Order("create_time DESC").Find(&list).Error
	return
}

// strPtr returns a pointer to s; helper for building transformed rows.
func strPtr(s string) *string { return &s }

// OptometryDataRow1 is the table row format for type-1 (电脑验光仪) and type-2 (查片仪) data.
type OptometryDataRow1 struct {
	Label   string  `json:"label"`
	DataRt1 *string `json:"dataRt1"` // 电脑验光仪 右眼
	DataLt1 *string `json:"dataLt1"` // 电脑验光仪 左眼
	DataRt2 *string `json:"dataRt2"` // 查片仪 右眼
	DataLt2 *string `json:"dataLt2"` // 查片仪 左眼
}

// OptometryDataRow2 is the table row format for type-3 (验光头) and type-4 (最终配镜) data.
type OptometryDataRow2 struct {
	Label  string  `json:"label"`
	DataRf *string `json:"dataRf"` // 远用 右眼
	DataLf *string `json:"dataLf"` // 远用 左眼
	DataRn *string `json:"dataRn"` // 近用 右眼
	DataLn *string `json:"dataLn"` // 近用 左眼
}

type dataKey struct{ t, lr, nf int } // type, leftRightEyes, nearFar(-1 = nil)

func buildKeyMap(list []optometryModel.OptometryData) map[dataKey]*optometryModel.OptometryData {
	m := make(map[dataKey]*optometryModel.OptometryData, len(list))
	for i := range list {
		nf := -1
		if list[i].NearFar != nil {
			nf = *list[i].NearFar
		}
		k := dataKey{list[i].Type, list[i].LeftRightEyes, nf}
		m[k] = &list[i]
	}
	return m
}

type fieldExtractor struct {
	label string
	get   func(*optometryModel.OptometryData) *string
}

var measurementFields = []fieldExtractor{
	{"球镜", func(d *optometryModel.OptometryData) *string { return strPtr(d.SphericalMirror) }},
	{"柱镜", func(d *optometryModel.OptometryData) *string { return strPtr(d.CylindricalMirror) }},
	{"轴位", func(d *optometryModel.OptometryData) *string { return strPtr(d.PositionOfAxis) }},
	{"ADD", func(d *optometryModel.OptometryData) *string { return d.Addend }},
	{"瞳距", func(d *optometryModel.OptometryData) *string { return strPtr(d.DistanceOfPupil) }},
	{"水平棱镜", func(d *optometryModel.OptometryData) *string { return strPtr(d.HorizontalPrism) }},
	{"垂直棱镜", func(d *optometryModel.OptometryData) *string { return strPtr(d.VerticalPrism) }},
}

// GetByRecordIdForType1 returns rows for types 1 (电脑验光仪) and 2 (查片仪).
func (s *OptometryDataService) GetByRecordIdForType1(recordsId int64) (rows []OptometryDataRow1, err error) {
	var data []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ? AND type IN (1, 2)", recordsId).Find(&data).Error
	if err != nil {
		return
	}
	m := buildKeyMap(data)
	for _, f := range measurementFields {
		row := OptometryDataRow1{Label: f.label}
		if d := m[dataKey{1, 1, -1}]; d != nil {
			row.DataRt1 = f.get(d)
		}
		if d := m[dataKey{1, 0, -1}]; d != nil {
			row.DataLt1 = f.get(d)
		}
		if d := m[dataKey{2, 1, -1}]; d != nil {
			row.DataRt2 = f.get(d)
		}
		if d := m[dataKey{2, 0, -1}]; d != nil {
			row.DataLt2 = f.get(d)
		}
		rows = append(rows, row)
	}
	return
}

// GetByRecordIdForType2 returns rows for type 3 (验光头).
func (s *OptometryDataService) GetByRecordIdForType2(recordsId int64) (rows []OptometryDataRow2, err error) {
	var data []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ? AND type = 3", recordsId).Find(&data).Error
	if err != nil {
		return
	}
	return buildType234Rows(data), nil
}

// GetByRecordIdForType3 returns rows for type 4 (最终配镜).
func (s *OptometryDataService) GetByRecordIdForType3(recordsId int64) (rows []OptometryDataRow2, err error) {
	var data []optometryModel.OptometryData
	err = global.GVA_DB.Where("optometry_records_id = ? AND type = 4", recordsId).Find(&data).Error
	if err != nil {
		return
	}
	return buildType234Rows(data), nil
}

func buildType234Rows(data []optometryModel.OptometryData) []OptometryDataRow2 {
	if len(data) == 0 {
		return []OptometryDataRow2{}
	}
	t := data[0].Type
	m := buildKeyMap(data)
	var rows []OptometryDataRow2
	for _, f := range measurementFields {
		row := OptometryDataRow2{Label: f.label}
		if d := m[dataKey{t, 1, 0}]; d != nil {
			row.DataRf = f.get(d)
		}
		if d := m[dataKey{t, 0, 0}]; d != nil {
			row.DataLf = f.get(d)
		}
		if d := m[dataKey{t, 1, 1}]; d != nil {
			row.DataRn = f.get(d)
		}
		if d := m[dataKey{t, 0, 1}]; d != nil {
			row.DataLn = f.get(d)
		}
		rows = append(rows, row)
	}
	return rows
}
