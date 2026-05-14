<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="设备ID">
          <el-input v-model="searchInfo.equipmentId" placeholder="设备ID" clearable />
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="searchInfo.createTime"
            type="date"
            unlink-panels
            value-format="YYYY-MM-DD"
            placeholder="选择日期"
            clearable
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="danger" icon="delete" :disabled="!selectedIds.length" @click="onBatchDelete">批量删除</el-button>
      </div>
      <el-table :data="tableData" row-key="errorReportLogId" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column align="left" label="日志ID" prop="errorReportLogId" min-width="80" />
        <el-table-column align="left" label="设备ID" prop="equipmentId" min-width="180" />
        <el-table-column align="left" label="文件位置" prop="logPath" min-width="300">
          <template #default="scope">
            <a v-if="scope.row.logPath" :href="scope.row.logPath" target="_blank" class="blue-link">{{ scope.row.logPath }}</a>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="创建时间" min-width="170">
          <template #default="scope">
            {{ scope.row.CreateTime?.createTime || scope.row.createTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="更新时间" min-width="170">
          <template #default="scope">
            {{ scope.row.CreateTime?.updateTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="操作" min-width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="viewDetail(scope.row)">查看</el-button>
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

    <el-dialog v-model="detailVisible" title="日志详情" width="700px" destroy-on-close>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="日志ID" :span="1">{{ detail.errorReportLogId }}</el-descriptions-item>
        <el-descriptions-item label="设备ID" :span="1">{{ detail.equipmentId }}</el-descriptions-item>
        <el-descriptions-item label="文件位置" :span="2">
          <a v-if="detail.logPath" :href="detail.logPath" target="_blank" class="blue-link">{{ detail.logPath }}</a>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="1">{{ detail.CreateTime?.createTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="更新时间" :span="1">{{ detail.CreateTime?.updateTime || '-' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getErrorReportLogList,
  getErrorReportLog,
  deleteErrorReportLog,
  deleteErrorReportLogByIds
} from '@/api/errorReportLog'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const selectedIds = ref([])

const detailVisible = ref(false)
const detail = ref({})

const getTableData = async () => {
  const res = await getErrorReportLogList({
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

const handleCurrentChange = (val) => {
  page.value = val
  getTableData()
}

const handleSelectionChange = (rows) => {
  selectedIds.value = rows.map(row => row.errorReportLogId)
}

const viewDetail = async (row) => {
  const res = await getErrorReportLog({ id: row.errorReportLogId })
  if (res.code === 0) {
    detail.value = res.data
    detailVisible.value = true
  }
}

const deleteRow = (row) => {
  ElMessageBox.confirm('确认删除该日志记录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const res = await deleteErrorReportLog({ id: row.errorReportLogId })
    if (res.code === 0) {
      ElMessage.success('删除成功')
      getTableData()
    }
  }).catch(() => {})
}

const onBatchDelete = () => {
  if (!selectedIds.value.length) return
  ElMessageBox.confirm(`确认删除选中的 ${selectedIds.value.length} 条日志记录吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const res = await deleteErrorReportLogByIds({ ids: selectedIds.value })
    if (res.code === 0) {
      ElMessage.success('批量删除成功')
      selectedIds.value = []
      getTableData()
    }
  }).catch(() => {})
}

onMounted(() => {
  getTableData()
})
</script>

<style lang="scss">
.blue-link {
  color: #409eff;
  text-decoration: none;
  &:hover {
    text-decoration: underline;
  }
}
</style>
