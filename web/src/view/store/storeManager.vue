<template>
  <div>
    <div class="gva-search-box">
      <el-form ref="searchForm" :inline="true" :model="searchInfo">
        <el-form-item label="门店名称">
          <el-input v-model="searchInfo.storeNameEnglish" placeholder="门店名称" clearable />
        </el-form-item>
        <el-form-item label="品牌编号">
          <el-input v-model="searchInfo.brandId" placeholder="品牌编号" clearable />
        </el-form-item>
        <el-form-item label="门店编号">
          <el-input v-model="searchInfo.storeNumber" placeholder="门店编号" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增门店</el-button>
      </div>
      <el-table :data="tableData" row-key="storeId">
        <el-table-column align="left" label="门店ID" prop="storeId" min-width="80" />
        <el-table-column align="left" label="用户姓名" prop="name" min-width="100" />
        <el-table-column align="left" label="品牌编号" prop="brandId" min-width="100" />
        <el-table-column align="left" label="门店编号" prop="storeNumber" min-width="100" />
        <el-table-column align="left" label="门店名称" prop="storeNameEnglish" min-width="150" />
        <el-table-column align="left" label="门店电话" prop="storePhone" min-width="130" />
        <el-table-column align="left" label="门店地址" prop="address" min-width="200" />
        <el-table-column align="left" label="操作" min-width="250" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="goMember(scope.row)">门店成员</el-button>
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination
          layout="total, prev, pager, next, jumper"
          :current-page="page"
          :page-size="pageSize"
          :total="total"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <el-dialog v-model="dialogFormVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="用户" prop="userId">
          <el-select v-model="form.userId" filterable placeholder="请选择用户" style="width: 100%">
            <el-option v-for="item in userList" :key="item.userId" :label="item.name" :value="item.userId" />
          </el-select>
        </el-form-item>
        <el-form-item label="品牌编号" prop="brandId">
          <el-input v-model="form.brandId" placeholder="请输入品牌编号" />
        </el-form-item>
        <el-form-item label="门店编号" prop="storeNumber">
          <el-input v-model="form.storeNumber" placeholder="请输入门店编号" />
        </el-form-item>
        <el-form-item label="门店名称" prop="storeNameEnglish">
          <el-input v-model="form.storeNameEnglish" placeholder="请输入门店名称" />
        </el-form-item>
        <el-form-item label="门店电话" prop="storePhone">
          <el-input v-model="form.storePhone" placeholder="请输入门店电话" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import {
  getStoreList, createStore, updateStore, deleteStore
} from '@/api/store'
import { getMxUserList } from '@/api/mxuser'

const router = useRouter()

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const dialogFormVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const userList = ref([])
const rules = reactive({
  userId: [{ required: true, message: '请选择用户', trigger: 'blur' }],
  brandId: [{ required: true, message: '请输入品牌编号', trigger: 'blur' }],
  storeNumber: [{ required: true, message: '请输入门店编号', trigger: 'blur' }],
  storeNameEnglish: [{ required: true, message: '请输入门店名称', trigger: 'blur' }]
})

const getTableData = async () => {
  const res = await getStoreList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) {
    tableData.value = res.data.list
    total.value = res.data.total
  }
}

const onSubmit = () => {
  page.value = 1
  getTableData()
}

const onReset = () => {
  searchInfo.value = {}
  getTableData()
}

const handleCurrentChange = (val) => {
  page.value = val
  getTableData()
}

const openDialog = (type, row) => {
  if (type === 'add') {
    dialogTitle.value = '新增门店'
    form.value = {}
    loadUserList()
  } else {
    dialogTitle.value = '编辑门店'
    form.value = { ...row }
    loadUserList()
  }
  dialogFormVisible.value = true
}

const loadUserList = async () => {
  const res = await getMxUserList({ page: 1, pageSize: 1000 })
  if (res.code === 0) {
    userList.value = res.data.list || []
  }
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    let res
    if (form.value.storeId) {
      res = await updateStore(form.value)
    } else {
      res = await createStore(form.value)
    }
    if (res.code === 0) {
      ElMessage.success(form.value.storeId ? '修改成功' : '新增成功')
      dialogFormVisible.value = false
      getTableData()
    }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除该门店吗？', '提示', { type: 'warning' })
  const res = await deleteStore({ storeId: row.storeId })
  if (res.code === 0) {
    ElMessage.success('删除成功')
    getTableData()
  }
}

const goMember = (row) => {
  router.push({ path: '/store/storeMember', query: { storeId: row.storeId } })
}

onMounted(() => {
  getTableData()
})
</script>
