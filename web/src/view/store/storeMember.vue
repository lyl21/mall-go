<template>
  <div>
    <warning-bar title="查看门店成员信息" />
    <div class="gva-search-box">
      <el-form ref="searchForm" :inline="true" :model="searchInfo">
        <el-form-item label="职位">
          <el-select v-model="searchInfo.post" placeholder="职位" clearable>
            <el-option label="店长" :value="1" />
            <el-option label="验光师" :value="2" />
            <el-option label="顾客" :value="3" />
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
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增成员</el-button>
      </div>
      <el-table :data="tableData" row-key="userId">
        <el-table-column align="left" label="用户ID" prop="userId" min-width="80" />
        <el-table-column align="left" label="用户姓名" prop="username" min-width="120" />
        <el-table-column align="left" label="职位" prop="post" min-width="100">
          <template #default="scope">
            <el-tag :type="scope.row.post === 1 ? 'primary' : scope.row.post === 2 ? 'success' : 'info'">
              {{ scope.row.post === 1 ? '店长' : scope.row.post === 2 ? '验光师' : '顾客' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="操作" min-width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="dialogFormVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="职位" prop="post">
          <el-select v-model="form.post" placeholder="请选择职位" style="width: 100%">
            <el-option label="店长" :value="1" />
            <el-option label="验光师" :value="2" />
            <el-option label="顾客" :value="3" />
          </el-select>
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
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { useRoute } from 'vue-router'
import {
  getStoreMemberList, getStoreMember, createStoreMember, updateStoreMember
} from '@/api/store'

const route = useRoute()
const storeId = computed(() => Number(route.query.storeId || 0))

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)

const dialogFormVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const isEdit = ref(false)
const rules = reactive({
  userId: [{ required: true, message: '请输入用户ID', trigger: 'blur' }],
  post: [{ required: true, message: '请选择职位', trigger: 'change' }]
})

const getTableData = async () => {
  // 如果不是从“门店信息 -> 门店成员”跳转进入，会缺少 storeId
  if (!storeId.value) {
    // ElMessage.warning('请先从门店信息页进入门店成员页面')
    ElMessage.warning('缺少门店ID，请从“门店信息”页面点击“门店成员”进入')
    tableData.value = []
    return
  }
  const res = await getStoreMemberList({
    storeId: storeId.value,
    page: page.value,
    pageSize: pageSize.value,
    ...searchInfo.value
  })
  if (res.code === 0) {
    tableData.value = res.data.list || []
  }
}

const onSubmit = () => { getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }

const openDialog = async (type, row) => {
  if (type === 'add') {
    dialogTitle.value = '新增成员'
    form.value = { storeId: storeId.value }
    isEdit.value = false
  } else {
    dialogTitle.value = '编辑成员'
    const res = await getStoreMember({ storeId: row.storeId, userId: row.userId })
    if (res.code === 0) {
      form.value = { ...res.data }
    }
    isEdit.value = true
  }
  dialogFormVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    form.value.storeId = storeId.value
    // form.value.userId = form.value.userId
    // 用户ID输入框默认是字符串，这里统一转成数字再提交，避免后端 int64 反序列化报错
    form.value.userId = Number(form.value.userId)
    if (!form.value.userId || Number.isNaN(form.value.userId)) {
      ElMessage.warning('用户ID必须为数字')
      return
    }
    const res = isEdit.value
      ? await updateStoreMember(form.value)
      : await createStoreMember(form.value)
    if (res.code === 0) {
      ElMessage.success(isEdit.value ? '修改成功' : '新增成功')
      dialogFormVisible.value = false
      getTableData()
    }
  })
}

onMounted(() => { getTableData() })
</script>
