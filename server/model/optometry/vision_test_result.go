package optometry

import "github.com/flipped-aurora/gin-vue-admin/server/model/common"

// VisionTestResult 视图验光数据表
type VisionTestResult struct {
	ResultsId          int64           `json:"resultsId" gorm:"column:results_id;primaryKey;autoIncrement;comment:视图验光id"`
	OptometryRecordsId *int64          `json:"optometryRecordsId" gorm:"column:optometry_records_id;comment:验光记录ID"`
	CreateTime         common.BizModel `gorm:"embedded"`
	Ww4points          *string         `json:"ww4points" gorm:"column:ww4points;type:varchar(50);comment:沃氏4点"`
	StereoView         *string         `json:"stereoView" gorm:"column:stereo_view;type:varchar(50);comment:立体观"`
	VgfBi              *string         `json:"vgfBi" gorm:"column:vgf_bi;type:varchar(50);comment:隐斜（远）BI"`
	VgfBu              *string         `json:"vgfBu" gorm:"column:vgf_bu;type:varchar(50);comment:隐斜（远）BU"`
	PnifBi1            *string         `json:"pnifBi1" gorm:"column:pnif_bi_1;type:varchar(50);comment:正负融像（远）BI1"`
	PnifBi2            *string         `json:"pnifBi2" gorm:"column:pnif_bi_2;type:varchar(50);comment:正负融像（远）BI2"`
	PnifBi3            *string         `json:"pnifBi3" gorm:"column:pnif_bi_3;type:varchar(50);comment:正负融像（远）BI3"`
	PnifBu1            *string         `json:"pnifBu1" gorm:"column:pnif_bu_1;type:varchar(50);comment:正负融像（远）BU1"`
	PnifBu2            *string         `json:"pnifBu2" gorm:"column:pnif_bu_2;type:varchar(50);comment:正负融像（远）BU2"`
	PnifBu3            *string         `json:"pnifBu3" gorm:"column:pnif_bu_3;type:varchar(50);comment:正负融像（远）BU3"`
	VgnBi              *string         `json:"vgnBi" gorm:"column:vgn_bi;type:varchar(50);comment:隐斜（近）BI"`
	VgnBu              *string         `json:"vgnBu" gorm:"column:vgn_bu;type:varchar(50);comment:隐斜（近）BU"`
	Aca                *string         `json:"aca" gorm:"column:aca;type:varchar(50);comment:梯度法"`
	PninBi1            *string         `json:"pninBi1" gorm:"column:pnin_bi_1;type:varchar(50);comment:正负融像（近）BI1"`
	PninBi2            *string         `json:"pninBi2" gorm:"column:pnin_bi_2;type:varchar(50);comment:正负融像（近）BI2"`
	PninBi3            *string         `json:"pninBi3" gorm:"column:pnin_bi_3;type:varchar(50);comment:正负融像（近）BI3"`
	PninBu1            *string         `json:"pninBu1" gorm:"column:pnin_bu_1;type:varchar(50);comment:正负融像（近）BU1"`
	PninBu2            *string         `json:"pninBu2" gorm:"column:pnin_bu_2;type:varchar(50);comment:正负融像（近）BU2"`
	PninBu3            *string         `json:"pninBu3" gorm:"column:pnin_bu_3;type:varchar(50);comment:正负融像（近）BU3"`
	Nra                *string         `json:"nra" gorm:"column:nra;type:varchar(50);comment:负相对调节NRA"`
	Bcc                *string         `json:"bcc" gorm:"column:bcc;type:varchar(255);comment:调节反应BCC"`
	Pra                *string         `json:"pra" gorm:"column:pra;type:varchar(255);comment:正相对调节PRA"`
	ReverseBeat        *string         `json:"reverseBeat" gorm:"column:reverse_beat;type:varchar(50);comment:反转拍"`
	VisualChart        *string         `json:"visualChart" gorm:"column:visual_chart;type:varchar(50);comment:视力表"`
	Binoculus          *string         `json:"binoculus" gorm:"column:binoculus;type:varchar(50);comment:双眼"`
	LeftEye            *string         `json:"leftEye" gorm:"column:left_eye;type:varchar(50);comment:左眼"`
	RightEye           *string         `json:"rightEye" gorm:"column:right_eye;type:varchar(50);comment:右眼"`
	DiagnosisName      *string         `json:"diagnosisName" gorm:"column:diagnosis_name;type:varchar(255);comment:诊断名称"`
	DiagnosisAbnormal  *string         `json:"diagnosisAbnormal" gorm:"column:diagnosis_abnormal;type:varchar(255);comment:诊断异常名称"`
	Rests              *string         `json:"rests" gorm:"column:rests;type:varchar(255);comment:其他"`
	Sugggestions       *string         `json:"sugggestions" gorm:"column:sugggestions;type:varchar(255);comment:建议方案"`
	// 关联：TryOptometry.ResultsId = VisionTestResult.ResultsId
	TryOptometryList []TryOptometry `json:"tryOptometryList" gorm:"foreignKey:ResultsId;references:ResultsId"`
}

func (VisionTestResult) TableName() string { return "vision_test_results" }
