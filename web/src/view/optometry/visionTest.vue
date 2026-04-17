<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="验光记录ID">
          <el-input v-model="searchInfo.optometryRecordsId" placeholder="验光记录ID" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <el-table :data="tableData" row-key="resultsId" border>
        <el-table-column align="center" label="ID" prop="resultsId" min-width="60" />
        <el-table-column align="center" label="验光记录ID" prop="optometryRecordsId" min-width="100" />
        <el-table-column align="center" label="沃氏4点" prop="ww4points" min-width="80" />
        <el-table-column align="center" label="立体观" prop="stereoView" min-width="80" />
        <el-table-column align="center" label="隐斜(远)BI" prop="vgfBi" min-width="100" />
        <el-table-column align="center" label="隐斜(远)BU" prop="vgfBu" min-width="100" />
        <el-table-column align="center" label="隐斜(近)BI" prop="vgnBi" min-width="100" />
        <el-table-column align="center" label="隐斜(近)BU" prop="vgnBu" min-width="100" />
        <el-table-column align="center" label="AC/A" prop="aca" min-width="80" />
        <el-table-column align="center" label="NRA" prop="nra" min-width="60" />
        <el-table-column align="center" label="BCC" prop="bcc" min-width="60" />
        <el-table-column align="center" label="PRA" prop="pra" min-width="60" />
        <el-table-column align="center" label="诊断名称" prop="diagnosisName" min-width="120" />
        <el-table-column align="center" label="建议方案" prop="sugggestions" min-width="150" />
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getVisionTestResultList } from '@/api/optometry'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const getTableData = async () => {
  const res = await getVisionTestResultList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) { tableData.value = res.data.list; total.value = res.data.total }
}
const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (val) => { page.value = val; getTableData() }

onMounted(() => { getTableData() })
</script>
