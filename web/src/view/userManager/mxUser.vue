<template>
  <div>
    <div class="gva-search-box">
      <el-form ref="searchForm" :inline="true" :model="searchInfo">
        <el-form-item label="姓名">
          <el-input v-model="searchInfo.name" placeholder="姓名" clearable />
        </el-form-item>
        <el-form-item label="手机号码">
          <el-input v-model="searchInfo.phoneNumber" placeholder="手机号码" clearable />
        </el-form-item>
        <el-form-item label="主视眼">
          <el-input v-model="searchInfo.dominantEye" placeholder="主视眼" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增用户</el-button>
      </div>
      <el-table :data="tableData" row-key="userId">
        <el-table-column align="left" label="用户ID" prop="userId" min-width="80" />
        <el-table-column align="left" label="姓名" prop="name" min-width="100" />
        <el-table-column align="left" label="性别" prop="gender" min-width="60">
          <template #default="scope">
            <span>{{ scope.row.gender === 0 ? '未知' : scope.row.gender === 1 ? '男' : '女' }}</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="年龄" prop="age" min-width="60" />
        <el-table-column align="left" label="手机号码" prop="phoneNumber" min-width="130" />
        <el-table-column align="left" label="身份" min-width="80">
          <template #default="scope">
            <el-tag v-if="scope.row.userRole === 1" type="danger">店长</el-tag>
            <el-tag v-else-if="scope.row.userRole === 2" type="warning">验光师</el-tag>
            <el-tag v-else type="info">顾客</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="微信信息" min-width="180">
          <template #default="scope">
            <div v-if="scope.row.openid" class="wx-info">
              <el-avatar :size="24" :src="scope.row.avatarUrl" />
              <div class="wx-detail">
                <div class="wx-name">{{ scope.row.wxNickName || '微信用户' }}</div>
                <div v-if="scope.row.wxPhone" class="wx-phone">{{ scope.row.wxPhone }}</div>
              </div>
            </div>
            <span v-else class="no-wx">未绑定</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="主视眼" prop="dominantEye" min-width="80" />
        <el-table-column align="left" label="最近验光" prop="latestCheckupDateTime" min-width="120" />
        <el-table-column align="left" label="操作" min-width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="goOptometry(scope.row)">验光数据</el-button>
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>

    <el-dialog v-model="dialogFormVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="form.name" placeholder="请输入姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择" style="width: 100%">
                <el-option label="男" :value="1" />
                <el-option label="女" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="年龄" prop="age">
              <el-input v-model="form.age" placeholder="年龄" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号码" prop="phoneNumber">
              <el-input v-model="form.phoneNumber" placeholder="手机号码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="密码" prop="password">
              <el-input v-model="form.password" placeholder="密码" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="身份" prop="userRole">
              <el-select v-model="form.userRole" placeholder="请选择身份" style="width: 100%">
                <el-option label="普通顾客" :value="0" />
                <el-option label="店长" :value="1" />
                <el-option label="验光师" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="主视眼" prop="dominantEye">
              <el-input v-model="form.dominantEye" placeholder="主视眼" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="微信号">
              <el-input v-model="form.wechat" placeholder="微信号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="openid">
              <el-input v-model="form.openid" placeholder="微信openid" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="unionid">
              <el-input v-model="form.unionid" placeholder="微信unionid" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="微信昵称">
              <el-input v-model="form.wxNickName" placeholder="微信昵称" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="微信手机">
              <el-input v-model="form.wxPhone" placeholder="微信手机号" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="微信头像">
          <el-avatar v-if="form.avatarUrl" :size="64" :src="form.avatarUrl" />
          <span v-else>无头像</span>
        </el-form-item>
        <el-form-item label="关注时间">
          <el-input v-model="form.subscribeTime" placeholder="关注时间" disabled />
        </el-form-item>
        <el-form-item label="城市">
          <el-input v-model="form.city" placeholder="城市" />
        </el-form-item>
        <el-form-item label="联系地址">
          <el-input v-model="form.contactAddress" type="textarea" placeholder="联系地址" />
        </el-form-item>
        <el-form-item label="职业">
          <el-input v-model="form.occupation" placeholder="职业" />
        </el-form-item>
        <el-form-item label="单位">
          <el-input v-model="form.company" placeholder="单位" />
        </el-form-item>
        <el-form-item label="配镜需求">
          <el-input v-model="form.glassesNeed" placeholder="配镜需求" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remarks" type="textarea" placeholder="备注" />
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
import { getMxUserList, createMxUser, updateMxUser, deleteMxUser } from '@/api/mxuser'

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
const rules = reactive({
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  phoneNumber: [{ required: true, message: '请输入手机号码', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
})

const getTableData = async () => {
  const res = await getMxUserList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) {
    tableData.value = res.data.list
    total.value = res.data.total
  }
}

const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (val) => { page.value = val; getTableData() }

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增用户' : '编辑用户'
  form.value = type === 'add' ? {} : { ...row }
  dialogFormVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const res = form.value.userId ? await updateMxUser(form.value) : await createMxUser(form.value)
    if (res.code === 0) {
      ElMessage.success(form.value.userId ? '修改成功' : '新增成功')
      dialogFormVisible.value = false
      getTableData()
    }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除该用户吗？', '提示', { type: 'warning' })
  const res = await deleteMxUser({ userId: row.userId })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

const goOptometry = (row) => {
  router.push({ path: '/optometry/optometryRecords', query: { userId: row.userId } })
}

onMounted(() => { getTableData() })
</script>

<style scoped>
.wx-info {
  display: flex;
  align-items: center;
  gap: 8px;
}
.wx-detail {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.wx-name {
  font-size: 13px;
  color: #303133;
}
.wx-phone {
  font-size: 11px;
  color: #909399;
}
.wx-tag {
  color: #67c23a;
  font-size: 12px;
}
.no-wx {
  color: #909399;
  font-size: 12px;
}
</style>
