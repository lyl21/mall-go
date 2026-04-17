<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="昵称">
          <el-input v-model="searchInfo.nickName" placeholder="昵称" clearable />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="searchInfo.phone" placeholder="手机号" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="ID" prop="id" min-width="120" />
        <el-table-column align="left" label="openid" prop="openid" min-width="200" />
        <el-table-column align="left" label="unionid" prop="unionid" min-width="200" />
        <el-table-column align="left" label="昵称" prop="nickName" min-width="120" />
        <el-table-column align="left" label="头像" prop="avatarUrl" min-width="80">
          <template #default="scope">
            <el-avatar :size="32" :src="scope.row.avatarUrl" />
          </template>
        </el-table-column>
        <el-table-column align="left" label="手机号" prop="phone" min-width="130" />
        <el-table-column align="left" label="性别" prop="gender" min-width="60">
          <template #default="scope">{{ scope.row.gender === 1 ? '男' : scope.row.gender === 2 ? '女' : '未知' }}</template>
        </el-table-column>
        <el-table-column align="left" label="关注时间" prop="subscribeTime" min-width="170" />
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getWxUserList } from '@/api/wechat'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const getTableData = async () => {
  const res = await getWxUserList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) { tableData.value = res.data.list; total.value = res.data.total }
}
const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (v) => { page.value = v; getTableData() }

onMounted(() => getTableData())
</script>
