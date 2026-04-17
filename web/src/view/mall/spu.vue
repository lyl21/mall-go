<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="商品名称">
          <el-input v-model="searchInfo.name" placeholder="商品名称" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchInfo.shelf" placeholder="状态" clearable>
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增商品</el-button>
      </div>
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="商品ID" prop="id" min-width="100" />
        <el-table-column align="left" label="商品图片" min-width="100">
          <template #default="scope">
            <el-image
              v-if="getFirstImage(scope.row.picUrls)"
              :src="getFirstImage(scope.row.picUrls)"
              :preview-src-list="getImageList(scope.row.picUrls)"
              fit="cover"
              style="width: 60px; height: 60px; border-radius: 4px; cursor: pointer;"
            />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="商品名称" prop="name" min-width="150" show-overflow-tooltip />
        <el-table-column align="left" label="卖点" prop="sellPoint" min-width="150" show-overflow-tooltip />
        <el-table-column align="left" label="一级分类" prop="categoryFirstName" min-width="100" />
        <el-table-column align="left" label="二级分类" prop="categorySecondName" min-width="100" />
        <el-table-column align="left" label="销售价" prop="salesPrice" min-width="80" />
        <el-table-column align="left" label="市场价" prop="marketPrice" min-width="80" />
        <el-table-column align="left" label="成本价" prop="costPrice" min-width="80" />
        <el-table-column align="left" label="库存" prop="stock" min-width="80" />
        <el-table-column align="left" label="销量" prop="salesNum" min-width="80" />
        <el-table-column align="left" label="排序" prop="sort" min-width="60" />
        <el-table-column align="left" label="状态" prop="shelf" min-width="80">
          <template #default="scope">
            <el-tag :type="scope.row.shelf === 1 ? 'success' : 'info'">{{ scope.row.shelf === 1 ? '上架' : '下架' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="操作" min-width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="商品名称" prop="name"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="一级分类" prop="categoryFirst">
          <el-select v-model="form.categoryFirst" placeholder="请选择一级分类" clearable>
            <el-option v-for="cat in categoryList" :key="cat.id" :label="cat.name" :value="cat.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="二级分类">
          <el-select v-model="form.categorySecond" placeholder="请选择二级分类" clearable :disabled="!form.categoryFirst">
            <el-option v-for="cat in secondaryCategoryList" :key="cat.id" :label="cat.name" :value="cat.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="卖点"><el-input v-model="form.sellPoint" /></el-form-item>
        <el-form-item label="主图">
          <el-upload
            v-model:file-list="picUrlList"
            action="/api/fileUploadAndDownload/upload"
            list-type="picture-card"
            :on-success="handlePicSuccess"
            :on-remove="handlePicRemove"
            :limit="5"
            :with-credentials="true"
            :headers="uploadHeaders"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="销售价"><el-input-number v-model="form.salesPrice" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="市场价"><el-input-number v-model="form.marketPrice" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="成本价"><el-input-number v-model="form.costPrice" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="库存"><el-input-number v-model="form.stock" :min="0" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="form.sort" :min="0" /></el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.shelf" :active-value="1" :inactive-value="0" />
        </el-form-item>
        <el-form-item label="商品描述"><el-input v-model="form.description" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getGoodsSpuList, createGoodsSpu, updateGoodsSpu, deleteGoodsSpu, getGoodsCategoryList } from '@/api/mall'
import { getUrl } from '@/utils/image'

const searchInfo = ref({})
const tableData = ref([])
const categoryList = ref([])
const secondaryCategoryList = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const picUrlList = ref([])
const rules = reactive({ name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }], categoryFirst: [{ required: true, message: '请选择分类', trigger: 'change' }] })

// 监听一级分类变化，加载二级分类
watch(() => form.value.categoryFirst, async (newVal) => {
  if (newVal) {
    const res = await getGoodsCategoryList({ page: 1, pageSize: 100, parentId: newVal })
    if (res.code === 0) {
      secondaryCategoryList.value = res.data.list || []
    }
    // 编辑时保留二级分类的值，但新增时清空
    if (form.value.id && form.value.categorySecond) {
      // 保持现有值
    } else {
      form.value.categorySecond = ''
    }
  } else {
    secondaryCategoryList.value = []
    form.value.categorySecond = ''
  }
})

// 上传请求头（包含认证token）
const uploadHeaders = ref({
  'x-token': localStorage.getItem('token') || ''
})

// 监听 picUrlList 变化，同步到 form.picUrls
watch(picUrlList, (val) => {
  const urls = val.map(item => {
    // 优先使用已设置的url，否则从response中获取
    if (item.url) return item.url
    if (item.response?.code === 0 && item.response?.data?.file?.url) {
      return item.response.data.file.url
    }
    return null
  }).filter(Boolean)
  form.value.picUrls = JSON.stringify(urls)
}, { deep: true })

// 图片上传成功
const handlePicSuccess = (response, uploadFile) => {
  if (response.code === 0 && response.data?.file?.url) {
    // 设置uploadFile的url属性用于显示
    uploadFile.url = response.data.file.url
    // 强制触发watch更新
    picUrlList.value = [...picUrlList.value]
  }
}

// 图片移除
const handlePicRemove = (uploadFile, uploadFiles) => {
  const urls = uploadFiles.map(item => {
    if (item.url) return item.url
    if (item.response?.data?.file?.url) return item.response.data.file.url
    return null
  }).filter(Boolean)
  form.value.picUrls = JSON.stringify(urls)
}

const getTableData = async () => {
  const res = await getGoodsSpuList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) { tableData.value = res.data.list; total.value = res.data.total }
}

const getCategoryList = async () => {
  const res = await getGoodsCategoryList({ page: 1, pageSize: 100 })
  if (res.code === 0) { categoryList.value = res.data.list || [] }
}

const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (v) => { page.value = v; getTableData() }

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增商品' : '编辑商品'
  form.value = type === 'add' ? { shelf: 1, stock: 0, sort: 0 } : { ...row }
  // 解析 picUrls 为图片列表
  picUrlList.value = []
  const picUrls = type === 'add' ? null : row?.picUrls
  if (picUrls) {
    try {
      const urls = JSON.parse(picUrls)
      picUrlList.value = urls.map(url => ({ name: url.split('/').pop(), url }))
    } catch (e) {
      const urls = picUrls.split(',').filter(Boolean)
      picUrlList.value = urls.map(url => ({ name: url.split('/').pop(), url }))
    }
  }
  // 编辑时加载二级分类
  if (type === 'edit' && row?.categoryFirst) {
    getSecondaryCategoryList(row.categoryFirst)
  }
  dialogVisible.value = true
}

// 获取二级分类列表
const getSecondaryCategoryList = async (parentId) => {
  const res = await getGoodsCategoryList({ page: 1, pageSize: 100, parentId })
  if (res.code === 0) {
    secondaryCategoryList.value = res.data.list || []
  }
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const res = form.value.id ? await updateGoodsSpu(form.value) : await createGoodsSpu(form.value)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; getTableData() }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteGoodsSpu({ id: row.id })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

// 处理图片URL，确保是完整路径
const getFullImageUrl = (url) => {
  if (!url) return null
  return getUrl(url)
}

// 获取第一张图片
const getFirstImage = (picUrls) => {
  if (!picUrls) return null
  try {
    const urls = JSON.parse(picUrls)
    return urls.length > 0 ? getFullImageUrl(urls[0]) : null
  } catch (e) {
    // 如果不是 JSON 格式，尝试按逗号分隔
    const urls = picUrls.split(',').filter(Boolean)
    return urls.length > 0 ? getFullImageUrl(urls[0]) : null
  }
}

// 获取图片列表（用于预览）
const getImageList = (picUrls) => {
  if (!picUrls) return []
  try {
    const urls = JSON.parse(picUrls)
    return urls.map(getFullImageUrl).filter(Boolean)
  } catch (e) {
    return picUrls.split(',').filter(Boolean).map(getFullImageUrl)
  }
}

onMounted(() => { getTableData(); getCategoryList() })
</script>
