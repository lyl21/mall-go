<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="用户">
          <el-input v-model="searchInfo.fromUserName" placeholder="用户标识" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="ID" prop="id" min-width="60" />
        <el-table-column align="left" label="用户" prop="fromUserName" min-width="200" />
        <el-table-column align="left" label="消息类型" prop="msgType" min-width="100" />
        <el-table-column align="left" label="消息内容" prop="content" min-width="300" show-overflow-tooltip />
        <el-table-column align="left" label="创建时间" prop="createTime" min-width="170" />
        <el-table-column align="left" label="操作" min-width="100" fixed="right">
          <template #default="scope">
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getWxMsgList, deleteWxMsg } from '@/api/wechat'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const getTableData = async () => {
  const res = await getWxMsgList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) { tableData.value = res.data.list; total.value = res.data.total }
}
const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (v) => { page.value = v; getTableData() }

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteWxMsg({ id: row.id })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

onMounted(() => getTableData())
</script>
