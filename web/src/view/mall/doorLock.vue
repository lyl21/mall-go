<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="门禁名称">
          <el-input v-model="searchInfo.doorName" placeholder="门禁名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增门锁</el-button>
      </div>
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="门锁ID" prop="id" min-width="80" />
        <el-table-column align="left" label="园区SN" prop="yardSn" min-width="150" />
        <el-table-column align="left" label="门禁ID" prop="doorGuid" min-width="150" />
        <el-table-column align="left" label="门禁名称" prop="doorName" min-width="150" />
        <el-table-column align="left" label="省" prop="provinceName" min-width="80" />
        <el-table-column align="left" label="市" prop="cityName" min-width="80" />
        <el-table-column align="left" label="区" prop="countyName" min-width="80" />
        <el-table-column align="left" label="详情地址" prop="detailInfo" min-width="200" show-overflow-tooltip />
        <el-table-column align="left" label="操作" min-width="320" fixed="right">
          <template #default="scope">
            <el-button type="success" link icon="Unlock" @click="handleOpenDoor(scope.row)">远程开门</el-button>
            <el-button type="primary" link @click="viewHistory(scope.row)">操作记录</el-button>
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination
          :current-page="page"
          :page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        />
      </div>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="园区SN" prop="yardSn">
          <el-input v-model="form.yardSn" placeholder="请输入园区SN（第三方）" />
        </el-form-item>
        <el-form-item label="门禁ID" prop="doorGuid">
          <el-input v-model="form.doorGuid" placeholder="请输入门禁ID（第三方）" />
        </el-form-item>
        <el-form-item label="门禁名称" prop="doorName">
          <el-input v-model="form.doorName" placeholder="请输入门禁名称" />
        </el-form-item>
        <el-form-item label="省">
          <el-input v-model="form.provinceName" placeholder="请输入省名" />
        </el-form-item>
        <el-form-item label="市">
          <el-input v-model="form.cityName" placeholder="请输入市名" />
        </el-form-item>
        <el-form-item label="区">
          <el-input v-model="form.countyName" placeholder="请输入区名" />
        </el-form-item>
        <el-form-item label="详情地址">
          <el-input v-model="form.detailInfo" type="textarea" placeholder="请输入详情地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="historyVisible" title="门锁操作记录" width="80%" destroy-on-close>
      <el-table :data="historyData" border>
        <el-table-column align="center" label="记录ID" prop="id" min-width="80" />
        <el-table-column align="center" label="园区SN" prop="yardSn" min-width="150" />
        <el-table-column align="center" label="门禁ID" prop="doorGuid" min-width="150" />
        <el-table-column align="center" label="操作类型" prop="operation" min-width="100">
          <template #default="scope">
            <el-tag :type="scope.row.operation === 'open' ? 'success' : 'info'">
              {{ scope.row.operation === 'open' ? '远程开门' : scope.row.operation }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column align="center" label="用户标识" prop="openId" min-width="120" />
        <el-table-column align="center" label="第三方响应" prop="response" min-width="150" show-overflow-tooltip />
        <el-table-column align="center" label="详情地址" prop="detailInfo" min-width="200" show-overflow-tooltip />
        <el-table-column align="center" label="操作时间" prop="createTime" min-width="160" />
      </el-table>
      <div class="gva-pagination" style="margin-top: 15px;">
        <el-pagination
          :current-page="historyPage"
          :page-size="historyPageSize"
          :page-sizes="[10, 20, 50]"
          :total="historyTotal"
          layout="total, sizes, prev, pager, next, jumper"
          @current-change="handleHistoryPageChange"
          @size-change="handleHistorySizeChange"
        />
      </div>
    </el-dialog>

    <!-- 远程开门选择用户对话框 -->
    <el-dialog v-model="openDoorVisible" title="远程开门 - 选择用户" width="700px" destroy-on-close>
      <div v-if="currentLock" style="margin-bottom: 15px; padding: 10px; background: #f5f7fa; border-radius: 4px;">
        <strong>当前门锁：</strong>{{ currentLock.doorName || currentLock.id }}
        <span v-if="currentLock.detailInfo" style="margin-left: 20px; color: #666;">
          <strong>地址：</strong>{{ currentLock.detailInfo }}
        </span>
      </div>
      
      <el-form :inline="true" :model="wxUserSearch" style="margin-bottom: 15px;">
        <el-form-item label="昵称">
          <el-input v-model="wxUserSearch.nickName" placeholder="请输入昵称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="getWxUserData">查询</el-button>
          <el-button icon="refresh" @click="wxUserSearch = {}; getWxUserData()">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="wxUserList" border highlight-current-row @current-change="handleWxUserSelect">
        <el-table-column type="index" width="50" />
        <el-table-column align="center" label="头像" width="60">
          <template #default="scope">
            <el-avatar v-if="scope.row.headimgUrl" :size="40" :src="scope.row.headimgUrl" />
            <el-avatar v-else :size="40" :icon="UserFilled" />
          </template>
        </el-table-column>
        <el-table-column align="center" label="昵称" prop="nickName" min-width="120" />
        <el-table-column align="center" label="OpenID" prop="openId" min-width="180" show-overflow-tooltip />
        <el-table-column align="center" label="手机号" prop="phone" min-width="120" />
        <el-table-column align="center" label="性别" width="70">
          <template #default="scope">
            {{ scope.row.sex === '1' ? '男' : scope.row.sex === '2' ? '女' : '未知' }}
          </template>
        </el-table-column>
      </el-table>
      
      <div class="gva-pagination" style="margin-top: 15px;">
        <el-pagination
          :current-page="wxUserPage"
          :page-size="wxUserPageSize"
          :page-sizes="[5, 10, 20]"
          :total="wxUserTotal"
          layout="total, sizes, prev, pager, next, jumper"
          @current-change="handleWxUserPageChange"
          @size-change="handleWxUserSizeChange"
        />
      </div>

      <div style="margin-top: 15px; padding: 10px; background: #e6f7ff; border-radius: 4px;">
        <strong>已选用户：</strong>
        <span v-if="selectedWxUser">
          {{ selectedWxUser.nickName || selectedWxUser.openId }}
          <el-tag size="small" style="margin-left: 10px;">{{ selectedWxUser.openId }}</el-tag>
        </span>
        <span v-else style="color: #999;">请点击表格选择用户</span>
      </div>

      <template #footer>
        <el-button @click="openDoorVisible = false">取消</el-button>
        <el-button type="primary" :disabled="!selectedWxUser" @click="confirmOpenDoor">确认开门</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { UserFilled } from '@element-plus/icons-vue'
import { getDoorLockList, createDoorLock, updateDoorLock, deleteDoorLock, getDoorLockHistoryList, openDoor } from '@/api/mall'
import { getWxUserList } from '@/api/wechat'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const rules = reactive({
  yardSn: [{ required: true, message: '请输入园区SN', trigger: 'blur' }],
  doorGuid: [{ required: true, message: '请输入门禁ID', trigger: 'blur' }],
  doorName: [{ required: true, message: '请输入门禁名称', trigger: 'blur' }]
})

const historyVisible = ref(false)
const historyData = ref([])
const historyPage = ref(1)
const historyPageSize = ref(10)
const historyTotal = ref(0)
const currentLock = ref(null)

// 远程开门相关
const openDoorVisible = ref(false)
const wxUserList = ref([])
const wxUserPage = ref(1)
const wxUserPageSize = ref(10)
const wxUserTotal = ref(0)
const wxUserSearch = ref({})
const selectedWxUser = ref(null)

const getTableData = async () => {
  const res = await getDoorLockList({ 
    page: page.value, 
    pageSize: pageSize.value,
    doorName: searchInfo.value.doorName 
  })
  if (res.code === 0) {
    tableData.value = res.data.list || []
    total.value = res.data.total || 0
  }
}

const handleCurrentChange = (val) => {
  page.value = val
  getTableData()
}

const handleSizeChange = (val) => {
  pageSize.value = val
  page.value = 1
  getTableData()
}

const onSubmit = () => {
  page.value = 1
  getTableData()
}

const onReset = () => { 
  searchInfo.value = {}
  page.value = 1
  getTableData() 
}

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增门锁' : '编辑门锁'
  form.value = type === 'add' ? {} : { ...row }
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const isEdit = !!form.value.id
    const res = isEdit ? await updateDoorLock(form.value) : await createDoorLock(form.value)
    if (res.code === 0) { 
      ElMessage.success(isEdit ? '修改成功' : '创建成功')
      dialogVisible.value = false
      getTableData() 
    } else {
      ElMessage.error(res.msg || '操作失败')
    }
  })
}

const deleteRow = async (row) => {
  try {
    await ElMessageBox.confirm('确定删除该门锁吗？', '提示', { type: 'warning' })
    const res = await deleteDoorLock({ id: row.id })
    if (res.code === 0) { 
      ElMessage.success('删除成功')
      getTableData() 
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
    }
  }
}

const viewHistory = async (row) => {
  currentLock.value = row
  historyPage.value = 1
  await getHistoryData()
}

const getHistoryData = async () => {
  const res = await getDoorLockHistoryList({ 
    page: historyPage.value, 
    pageSize: historyPageSize.value,
    doorGuid: currentLock.value?.doorGuid 
  })
  if (res.code === 0) { 
    historyData.value = res.data.list || []
    historyTotal.value = res.data.total || 0
    historyVisible.value = true
  }
}

const handleHistoryPageChange = (val) => {
  historyPage.value = val
  getHistoryData()
}

const handleHistorySizeChange = (val) => {
  historyPageSize.value = val
  historyPage.value = 1
  getHistoryData()
}

// 远程开门 - 打开选择用户对话框
const handleOpenDoor = async (row) => {
  currentLock.value = row
  selectedWxUser.value = null
  wxUserSearch.value = {}
  wxUserPage.value = 1
  openDoorVisible.value = true
  await getWxUserData()
}

// 获取微信用户列表
const getWxUserData = async () => {
  const res = await getWxUserList({
    page: wxUserPage.value,
    pageSize: wxUserPageSize.value,
    nickName: wxUserSearch.value.nickName
  })
  if (res.code === 0) {
    wxUserList.value = res.data.list || []
    wxUserTotal.value = res.data.total || 0
  }
}

const handleWxUserPageChange = (val) => {
  wxUserPage.value = val
  getWxUserData()
}

const handleWxUserSizeChange = (val) => {
  wxUserPageSize.value = val
  wxUserPage.value = 1
  getWxUserData()
}

const handleWxUserSelect = (row) => {
  selectedWxUser.value = row
}

// 确认开门
const confirmOpenDoor = async () => {
  if (!selectedWxUser.value) {
    ElMessage.warning('请选择用户')
    return
  }

  try {
    await ElMessageBox.confirm(
      `确定为用户 "${selectedWxUser.value.nickName || selectedWxUser.value.openId}" 开启门锁 "${currentLock.value.doorName || currentLock.value.id}" 吗？`,
      '远程开门确认',
      { type: 'warning', confirmButtonText: '确认开门' }
    )

    const res = await openDoor({ 
      id: currentLock.value.id, 
      openId: selectedWxUser.value.openId 
    })
    
    if (res.code === 0) {
      ElMessage.success('开门指令已发送成功')
      openDoorVisible.value = false
    } else {
      ElMessage.error(res.msg || '开门失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('开门失败:', error)
      ElMessage.error(error?.response?.data?.msg || '开门失败')
    }
  }
}

onMounted(() => getTableData())
</script>

<style scoped>
.gva-pagination {
  margin-top: 15px;
  display: flex;
  justify-content: flex-end;
}
</style>
