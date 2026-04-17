<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="版本名称">
          <el-input v-model="searchInfo.versionName" placeholder="版本名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增安装包</el-button>
      </div>
      <el-table :data="tableData" row-key="installingId">
        <el-table-column align="left" label="ID" prop="installingId" min-width="60" />
        <el-table-column align="left" label="应用" prop="app" min-width="100" />
        <el-table-column align="left" label="版本名称" prop="versionName" min-width="120" />
        <el-table-column align="left" label="文件地址" prop="url" min-width="220" show-overflow-tooltip />
        <el-table-column align="left" label="包名" prop="packageName" min-width="200" />
        <el-table-column align="left" label="强制更新" prop="forcedUpdating" min-width="100">
          <template #default="scope">
            <el-tag :type="scope.row.forcedUpdating === 1 ? 'danger' : 'info'">{{ scope.row.forcedUpdating === 1 ? '是' : '否' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="更新说明" prop="note" min-width="200" show-overflow-tooltip />
        <el-table-column align="left" label="操作" min-width="150" fixed="right">
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="应用" prop="app"><el-input v-model="form.app" placeholder="如: Android App, iOS App" /></el-form-item>
        <el-form-item label="版本名称" prop="versionName"><el-input v-model="form.versionName" placeholder="如: 1.0.0" /></el-form-item>
        <el-form-item label="安装包" prop="url">
          <SelectFile
            v-model="uploadFiles"
            :limit="1"
            accept=".apk,.ipa,.zip,.exe,.dmg"
            @on-success="handleUploadSuccess"
          />
          <div class="mt-2 text-xs text-gray-500">上传后自动填充包名与下载地址</div>
        </el-form-item>
        <el-form-item label="包名">
          <el-input v-model="form.packageName" readonly placeholder="上传后自动生成" />
        </el-form-item>
        <el-form-item label="文件地址"><el-input v-model="form.url" readonly placeholder="上传后自动填充" /></el-form-item>
        <el-form-item label="强制更新">
          <el-switch v-model="form.forcedUpdating" :active-value="1" :inactive-value="0" />
        </el-form-item>
        <el-form-item label="更新说明"><el-input v-model="form.note" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getPackageList, createPackage, updatePackage, deletePackage } from '@/api/mxuser'
import SelectFile from '@/components/selectFile/selectFile.vue'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const uploadFiles = ref([])
const rules = reactive({
  versionName: [{ required: true, message: '版本名称', trigger: 'blur' }],
  url: [{ required: true, message: '请上传安装包', trigger: 'change' }]
})

const getTableData = async () => {
  const res = await getPackageList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) { tableData.value = res.data.list; total.value = res.data.total }
}
const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (v) => { page.value = v; getTableData() }

const parsePackageName = (name = '') => {
  const index = name.lastIndexOf('.')
  return index > 0 ? name.slice(0, index) : name
}

// 上传成功后自动填充 URL 与包名
const handleUploadSuccess = (res) => {
  const file = res?.data?.file
  if (!file) return
  form.value.url = file.url
  form.value.packageName = parsePackageName(file.name || '')
}

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增安装包' : '编辑安装包'
  // form.value = type === 'add' ? { forceUpdate: 0 } : { ...row }
  form.value = type === 'add' ? { forcedUpdating: 0 } : { ...row }
  uploadFiles.value = form.value.url ? [{ name: form.value.packageName || '已上传文件', url: form.value.url }] : []
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    // versionCode 后端是可选指针，这里不强制要求输入，默认保持空
    const payload = {
      installingId: form.value.installingId,
      packageName: form.value.packageName,
      app: form.value.app,
      url: form.value.url,
      versionName: form.value.versionName,
      note: form.value.note || '',
      forcedUpdating: form.value.forcedUpdating ?? 0
    }
    const res = form.value.installingId ? await updatePackage(payload) : await createPackage(payload)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; getTableData() }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deletePackage({ installingId: row.installingId })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

onMounted(() => getTableData())
</script>
