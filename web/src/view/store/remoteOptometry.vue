<template>
  <div>
    <!-- 设备状态列表 -->
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="设备号">
          <el-input v-model="searchInfo.equipment" placeholder="设备号" clearable />
        </el-form-item>
        <el-form-item label="在线状态">
          <el-select v-model="searchInfo.onlineStatus" placeholder="在线状态" clearable>
            <el-option label="在线" value="1" />
            <el-option label="离线" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="gva-table-box">
      <el-table :data="tableData" row-key="equipment">
        <el-table-column align="left" label="设备号" prop="equipment" min-width="180" />
        <el-table-column align="left" label="设备名称" prop="deviceName" min-width="120" />
        <el-table-column align="left" label="设备位置" prop="deviceLocation" min-width="150" />
        <el-table-column align="left" label="在线状态" min-width="100">
          <template #default="scope">
            <el-tag :type="scope.row.onlineStatus === 1 ? 'success' : 'danger'">
              {{ scope.row.onlineStatus === 1 ? '在线' : '离线' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="远控状态" min-width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.isInControl" type="warning">远控中</el-tag>
            <el-tag v-else type="info">空闲</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="牛头连接" min-width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.niuTouConnected" type="success">已连接</el-tag>
            <el-tag v-else type="info">未连接</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="镜片模式" prop="lensMode" min-width="100" />
        <el-table-column align="left" label="左眼镜片" min-width="100">
          <template #default="scope">
            {{ scope.row.leftS !== undefined && scope.row.leftS !== null ? scope.row.leftS : '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="右眼镜片" min-width="100">
          <template #default="scope">
            {{ scope.row.rightS !== undefined && scope.row.rightS !== null ? scope.row.rightS : '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="最后活跃时间" prop="lastActiveTime" min-width="170" />
        <el-table-column align="left" label="操作" min-width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="viewDeviceDetail(scope.row)">详情</el-button>
            <el-button type="primary" link icon="list" @click="viewLogs(scope.row)">日志</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>

    <!-- 设备详情弹窗 -->
    <el-dialog v-model="detailVisible" title="设备详情" width="600px" destroy-on-close>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="设备号">{{ detail.equipment }}</el-descriptions-item>
        <el-descriptions-item label="设备名称">{{ detail.deviceName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="设备位置">{{ detail.deviceLocation || '-' }}</el-descriptions-item>
        <el-descriptions-item label="在线状态">
          <el-tag :type="detail.onlineStatus === 1 ? 'success' : 'danger'">
            {{ detail.onlineStatus === 1 ? '在线' : '离线' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="远控状态">
          <el-tag v-if="detail.isInControl" type="warning">远控中</el-tag>
          <el-tag v-else type="info">空闲</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="牛头设备连接">
          <el-tag v-if="detail.niuTouConnected" type="success">已连接</el-tag>
          <el-tag v-else type="info">未连接</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="镜片模式">{{ detail.lensMode || '-' }}</el-descriptions-item>
        <el-descriptions-item label="左眼镜片">{{ detail.leftS !== undefined && detail.leftS !== null ? detail.leftS : '-' }}</el-descriptions-item>
        <el-descriptions-item label="右眼镜片">{{ detail.rightS !== undefined && detail.rightS !== null ? detail.rightS : '-' }}</el-descriptions-item>
        <el-descriptions-item label="会话ID">{{ detail.controlSessionId || '-' }}</el-descriptions-item>
        <el-descriptions-item label="最后在线时间">{{ detail.lastOnlineTime || '-' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 日志列表弹窗 -->
    <el-dialog v-model="logVisible" title="远控日志" width="900px" destroy-on-close>
      <el-table :data="logData" row-key="logId">
        <el-table-column align="left" label="会话ID" prop="sessionId" min-width="180" />
        <el-table-column align="left" label="远控状态" min-width="100">
          <template #default="scope">
            <el-tag :type="getControlStatusType(scope.row.controlStatus)">
              {{ getControlStatusLabel(scope.row.controlStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="牛头连接" min-width="100">
          <template #default="scope">
            <el-tag :type="scope.row.niuTouConnected ? 'success' : 'info'">
              {{ scope.row.niuTouConnected ? '已连接' : '未连接' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="传输方式" prop="transport" min-width="80" />
        <el-table-column align="left" label="镜片模式" prop="lensMode" min-width="80" />
        <el-table-column align="left" label="左眼镜片" min-width="80">
          <template #default="scope">
            {{ scope.row.leftS !== undefined && scope.row.leftS !== null ? scope.row.leftS : '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="右眼镜片" min-width="80">
          <template #default="scope">
            {{ scope.row.rightS !== undefined && scope.row.rightS !== null ? scope.row.rightS : '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="开始时间" prop="startTime" min-width="170" />
        <el-descriptions-item label="最后执行状态" min-width="100">
          <template #default="scope">
            <el-tag :type="getApplyStatusType(scope.row.lastApplyStatus)">
              {{ getApplyStatusLabel(scope.row.lastApplyStatus) }}
            </el-tag>
          </template>
        </el-descriptions-item>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="logPage" :page-size="logPageSize" :total="logTotal" @current-change="handleLogPageChange" />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getNiuTouDeviceList, getNiuTouDeviceStatus, getRemoteOptometryLogList } from '@/api/remoteOptometry'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const detailVisible = ref(false)
const detail = ref({})

const logVisible = ref(false)
const logData = ref([])
const logPage = ref(1)
const logPageSize = ref(10)
const logTotal = ref(0)
const currentEquipment = ref('')

// 获取设备列表
const getTableData = async () => {
  const res = await getNiuTouDeviceList({
    page: page.value,
    pageSize: pageSize.value,
    ...searchInfo.value
  })
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
  page.value = 1
  getTableData()
}

const handleCurrentChange = (v) => {
  page.value = v
  getTableData()
}

// 查看设备详情
const viewDeviceDetail = async (row) => {
  const res = await getNiuTouDeviceStatus({ equipment: row.equipment })
  if (res.code === 0) {
    detail.value = res.data
    detailVisible.value = true
  }
}

// 查看日志
const viewLogs = (row) => {
  currentEquipment.value = row.equipment
  logPage.value = 1
  getLogData()
  logVisible.value = true
}

const getLogData = async () => {
  const res = await getRemoteOptometryLogList({
    page: logPage.value,
    pageSize: logPageSize.value,
    equipment: currentEquipment.value
  })
  if (res.code === 0) {
    logData.value = res.data.list
    logTotal.value = res.data.total
  }
}

const handleLogPageChange = (v) => {
  logPage.value = v
  getLogData()
}

// 状态显示辅助函数
const getControlStatusType = (status) => {
  const typeMap = {
    'pending': 'warning',
    'accepted': 'success',
    'rejected': 'danger',
    'timeout': 'info',
    'terminated': 'info'
  }
  return typeMap[status] || 'info'
}

const getControlStatusLabel = (status) => {
  const labelMap = {
    'pending': '等待中',
    'accepted': '已接受',
    'rejected': '已拒绝',
    'timeout': '超时',
    'terminated': '已终止'
  }
  return labelMap[status] || status || '-'
}

const getApplyStatusType = (status) => {
  const typeMap = {
    'applying': 'warning',
    'success': 'success',
    'failed': 'danger',
    'timeout': 'info'
  }
  return typeMap[status] || 'info'
}

const getApplyStatusLabel = (status) => {
  const labelMap = {
    'applying': '执行中',
    'success': '成功',
    'failed': '失败',
    'timeout': '超时'
  }
  return labelMap[status] || status || '-'
}

onMounted(() => {
  getTableData()
  // 定时刷新数据
  setInterval(() => {
    getTableData()
  }, 10000) // 每10秒刷新一次
})
</script>
