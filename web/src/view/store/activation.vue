<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="设备ID">
          <el-input v-model="searchInfo.equipment" placeholder="设备ID" clearable />
        </el-form-item>
        <el-form-item label="设备名称">
          <el-input v-model="searchInfo.deviceName" placeholder="设备名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">生成激活码</el-button>
      </div>
      <el-table :data="tableData" row-key="activationId">
        <el-table-column align="left" label="ID" prop="activationId" min-width="60" />
        <el-table-column align="left" label="设备名称" prop="deviceName" min-width="120" />
        <el-table-column align="left" label="应用" prop="app" min-width="100" />
        <el-table-column align="left" label="设备ID" prop="equipment" min-width="180" />
        <el-table-column align="left" label="激活码" prop="activationCode" min-width="200" />
        <el-table-column align="left" label="在线状态" min-width="100">
          <template #default="scope">
            <div class="online-status">
              <span class="status-dot" :class="scope.row.onlineStatus === 1 ? 'online' : 'offline'"></span>
              <span>{{ scope.row.onlineStatus === 1 ? '在线' : '离线' }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column align="left" label="最后在线时间" min-width="150">
          <template #default="scope">
            {{ scope.row.lastOnlineTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="设备位置" prop="deviceLocation" min-width="120" />
        <el-table-column align="left" label="创建时间" min-width="150">
          <template #default="scope">
            {{ scope.row.CreateTime?.createTime }}
          </template>
        </el-table-column>
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

    <!-- 生成/编辑激活码对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="应用" prop="app">
              <el-select v-model="form.app" placeholder="请选择应用" style="width: 100%">
                <el-option label="牛头control" value="牛头control" />
                <el-option label="验光仪" value="验光仪" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="equipment">
              <el-input v-model="form.equipment" placeholder="设备唯一标识" :disabled="isEdit" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="设备名称">
              <el-input v-model="form.deviceName" placeholder="设备名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备位置">
              <el-input v-model="form.deviceLocation" placeholder="设备位置" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="激活码" v-if="isEdit">
          <el-input v-model="form.activationCode" placeholder="激活码" disabled />
        </el-form-item>
        <el-form-item label="在线状态" v-if="isEdit">
          <div class="online-status">
            <span class="status-dot" :class="form.onlineStatus === 1 ? 'online' : 'offline'"></span>
            <span>{{ form.onlineStatus === 1 ? '在线' : '离线' }}</span>
          </div>
        </el-form-item>
        <el-form-item label="最后在线时间" v-if="isEdit">
          <el-input v-model="form.lastOnlineTime" placeholder="最后在线时间" disabled />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" placeholder="备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getActivationCodeList, createActivationCode, updateActivationCode, deleteActivationCode } from '@/api/mxuser'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref(null)
const form = ref({})
const ws = ref(null)

const rules = reactive({
  app: [{ required: true, message: '请选择应用', trigger: 'change' }],
  equipment: [{ required: true, message: '请输入设备ID', trigger: 'blur' }]
})

const getTableData = async () => {
  const res = await getActivationCodeList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) {
    tableData.value = res.data.list
    total.value = res.data.total
  }
}

const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (v) => { page.value = v; getTableData() }

const openDialog = (type, row) => {
  isEdit.value = type === 'edit'
  dialogTitle.value = type === 'edit' ? '编辑设备' : '生成激活码'
  form.value = type === 'edit' ? { ...row } : {}
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const api = isEdit.value ? updateActivationCode : createActivationCode
    const res = await api(form.value)
    if (res.code === 0) {
      ElMessage.success(isEdit.value ? '修改成功' : '生成成功')
      dialogVisible.value = false
      getTableData()
    }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除该设备吗？', '提示', { type: 'warning' })
  const res = await deleteActivationCode({ activationId: row.activationId })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

// WebSocket连接
const connectWebSocket = () => {
  const wsUrl = `ws://${window.location.host}/ws/device`
  ws.value = new WebSocket(wsUrl)

  ws.value.onopen = () => {
    console.log('WebSocket连接成功')
  }

  ws.value.onmessage = (event) => {
    const data = JSON.parse(event.data)
    if (data.type === 'deviceStatus') {
      updateDeviceStatus(data.equipment, data.onlineStatus, data.lastOnlineTime)
    }
  }

  ws.value.onerror = (error) => {
    console.error('WebSocket错误:', error)
  }

  ws.value.onclose = () => {
    console.log('WebSocket连接关闭，5秒后重连...')
    setTimeout(connectWebSocket, 5000)
  }
}

// 更新设备状态
const updateDeviceStatus = (equipment, onlineStatus, lastOnlineTime) => {
  const index = tableData.value.findIndex(item => item.equipment === equipment)
  if (index !== -1) {
    tableData.value[index].onlineStatus = onlineStatus
    tableData.value[index].lastOnlineTime = lastOnlineTime
  }
}

onMounted(() => {
  getTableData()
  connectWebSocket()
})

onUnmounted(() => {
  if (ws.value) {
    ws.value.close()
  }
})
</script>

<style scoped>
.online-status {
  display: flex;
  align-items: center;
  gap: 8px;
}
.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
}
.status-dot.online {
  background-color: #67c23a;
  box-shadow: 0 0 4px #67c23a;
}
.status-dot.offline {
  background-color: #909399;
}
</style>
