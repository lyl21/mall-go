package mall

import (
	"encoding/json"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	mallModel "github.com/flipped-aurora/gin-vue-admin/server/model/mall"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type GoodsSpuService struct{}

var GoodsSpuServiceApp = new(GoodsSpuService)

func (s *GoodsSpuService) CreateGoodsSpu(spu mallModel.GoodsSpu) (err error) {
	if spu.Id == "" {
		spu.Id = strings.ReplaceAll(uuid.New().String(), "-", "")
	}
	err = global.GVA_DB.Create(&spu).Error
	return err
}

func (s *GoodsSpuService) DeleteGoodsSpu(id string) (err error) {
	err = global.GVA_DB.Model(&mallModel.GoodsSpu{}).Where("id = ?", id).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *GoodsSpuService) DeleteGoodsSpuByIds(ids []string) (err error) {
	err = global.GVA_DB.Model(&mallModel.GoodsSpu{}).Where("id IN ?", ids).Update("del_flag", "1").Error
	if err != nil {
		global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		return err
	}
	return nil
}

func (s *GoodsSpuService) UpdateGoodsSpu(spu mallModel.GoodsSpu) (err error) {
	err = global.GVA_DB.Select("name", "sell_point", "description", "category_first", "category_second", "tag", "pic_urls", "shelf", "sort", "sales_price", "market_price", "cost_price", "stock", "sales_num").Where("id = ?", spu.Id).Updates(&spu).Error
	return err
}

func (s *GoodsSpuService) GetGoodsSpu(id string) (spu mallModel.GoodsSpu, err error) {
	err = global.GVA_DB.Where("id = ? AND del_flag = ?", id, "0").First(&spu).Error
	return
}

func (s *GoodsSpuService) GetGoodsSpuList(info request.PageInfo, name string, categoryFirst string, shelf int) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&mallModel.GoodsSpu{}).Where("del_flag = ?", "0")
	if name != "" {
		db = db.Where("name LIKE ?", "%"+name+"%")
	}
	if categoryFirst != "" {
		db = db.Where("category_first = ?", categoryFirst)
	}
	if shelf != 0 {
		db = db.Where("shelf = ?", shelf)
	}
	err = db.Count(&total).Error
	if err != nil {
		return
	}
	var spuList []mallModel.GoodsSpu
	err = db.Limit(limit).Offset(offset).Order("sort ASC").Find(&spuList).Error
	if err != nil {
		return
	}
	var result []map[string]interface{}
	for _, spu := range spuList {
		spuMap := make(map[string]interface{})
		spuMap["id"] = spu.Id
		spuMap["spuCode"] = spu.SpuCode
		spuMap["name"] = spu.Name
		spuMap["sellPoint"] = spu.SellPoint
		spuMap["description"] = spu.Description
		spuMap["categoryFirst"] = spu.CategoryFirst
		spuMap["categorySecond"] = spu.CategorySecond
		spuMap["tag"] = parseTagToArray(spu.Tag)
		spuMap["picUrls"] = parsePicUrlsToArray(spu.PicUrls)
		spuMap["shelf"] = spu.Shelf
		spuMap["sort"] = spu.Sort
		spuMap["salesPrice"] = spu.SalesPrice
		spuMap["marketPrice"] = spu.MarketPrice
		spuMap["costPrice"] = spu.CostPrice
		spuMap["stock"] = spu.Stock
		spuMap["salesNum"] = spu.SalesNum
		spuMap["createTime"] = spu.CreateTime
		spuMap["updateTime"] = spu.UpdateTime
		spuMap["categoryFirstName"] = ""
		spuMap["categorySecondName"] = ""
		if spu.CategoryFirst != "" {
			var cat1 mallModel.GoodsCategory
			if err1 := global.GVA_DB.Where("id = ?", spu.CategoryFirst).First(&cat1).Error; err1 == nil && cat1.Name != nil {
				spuMap["categoryFirstName"] = *cat1.Name
			}
		}
		if spu.CategorySecond != nil && *spu.CategorySecond != "" {
			var cat2 mallModel.GoodsCategory
			if err2 := global.GVA_DB.Where("id = ?", *spu.CategorySecond).First(&cat2).Error; err2 == nil && cat2.Name != nil {
				spuMap["categorySecondName"] = *cat2.Name
			}
		}
		result = append(result, spuMap)
	}
	return result, total, err
}

// parsePicUrlsToArray 将 picUrls 从 JSON 字符串解析为数组
// 数据库中 picUrls 存储为 JSON 数组字符串如 '["/uploads/xxx.jpg"]'
// 前端使用 item.picUrls[0] 访问，需要返回数组而非字符串
func parsePicUrlsToArray(picUrls string) []string {
	if picUrls == "" {
		return []string{}
	}

	// 尝试解析为 JSON 数组
	var urls []string
	if err := json.Unmarshal([]byte(picUrls), &urls); err == nil && len(urls) > 0 {
		return urls
	}

	// 尝试按逗号分隔
	parts := strings.Split(picUrls, ",")
	result := make([]string, 0, len(parts))
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			result = append(result, p)
		}
	}
	return result
}

// parseTagToArray 将 tag 从逗号分隔字符串解析为数组
// 数据库中 tag 存储为逗号分隔字符串如 '国产,进口'，前端统一使用数组
func parseTagToArray(tag string) []string {
	if tag == "" {
		return []string{}
	}
	// 兼容已存为 JSON 数组格式的情况
	var tags []string
	if err := json.Unmarshal([]byte(tag), &tags); err == nil && len(tags) > 0 {
		return tags
	}
	// 按逗号分隔
	parts := strings.Split(tag, ",")
	result := make([]string, 0, len(parts))
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			result = append(result, p)
		}
	}
	return result
}
