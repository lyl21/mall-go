<template>
  <div>
    <warning-bar title="按用户查看验光数据" />
    <div class="gva-table-box">
      <el-table :data="tableData" border>
        <el-table-column align="center" label="验光ID" prop="optometryId" />
        <el-table-column align="center" label="验光记录ID" prop="optometryRecordsId" />
        <el-table-column align="center" label="球镜" prop="sphericalMirror" />
        <el-table-column align="center" label="柱镜" prop="cylindricalMirror" />
        <el-table-column align="center" label="轴位" prop="positionOfAxis" />
        <el-table-column align="center" label="ADD" prop="addend" />
        <el-table-column align="center" label="瞳距" prop="distanceOfPupil" />
        <el-table-column align="center" label="水平棱镜" prop="horizontalPrism" />
        <el-table-column align="center" label="垂直棱镜" prop="verticalPrism" />
        <el-table-column align="center" label="分类" prop="type" />
        <el-table-column align="center" label="远近" prop="nearFar" />
        <el-table-column align="center" label="左右眼" prop="leftRightEyes" />
      </el-table>

      <el-table :data="headers1" border style="margin-top: 16px" title="电脑验光仪/查片仪">
        <el-table-column label="电脑验光仪/查片仪">
          <el-table-column prop="label" label="项目" width="140" />
          <el-table-column label="电脑验光仪">
            <el-table-column label="右眼" prop="dataRt1" />
            <el-table-column label="左眼" prop="dataLt1" />
          </el-table-column>
          <el-table-column label="查片仪">
            <el-table-column label="右眼" prop="dataRt2" />
            <el-table-column label="左眼" prop="dataLt2" />
          </el-table-column>
        </el-table-column>
      </el-table>
      <el-table :data="headers2" border style="margin-top: 16px">
        <el-table-column label="验光头">
          <el-table-column prop="label" label="项目" width="140" />
          <el-table-column label="远用">
            <el-table-column label="右眼" prop="dataRf" />
            <el-table-column label="左眼" prop="dataLf" />
          </el-table-column>
          <el-table-column label="近用">
            <el-table-column label="右眼" prop="dataRn" />
            <el-table-column label="左眼" prop="dataLn" />
          </el-table-column>
        </el-table-column>
      </el-table>
      <el-table :data="headers3" border style="margin-top: 16px">
        <el-table-column label="最终配镜">
          <el-table-column prop="label" label="项目" width="140" />
          <el-table-column label="远用">
            <el-table-column label="右眼" prop="dataRf" />
            <el-table-column label="左眼" prop="dataLf" />
          </el-table-column>
          <el-table-column label="近用">
            <el-table-column label="右眼" prop="dataRn" />
            <el-table-column label="左眼" prop="dataLn" />
          </el-table-column>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { getOptometryDataList, getOptometryDataByType1, getOptometryDataByType2, getOptometryDataByType3 } from '@/api/optometry'

const route = useRoute()
// const userId = route.query.userId
// 路由 query 默认是字符串，这里统一转数字，避免后端 int64 反序列化报错
const userId = computed(() => Number(route.query.userId || 0))
const tableData = ref([])
const headers1 = ref([])
const headers2 = ref([])
const headers3 = ref([])

const loadData = async () => {
  // const query = { optometryRecordsId: userId }
  const query = { optometryRecordsId: userId.value }
  const [dataRes, h1Res, h2Res, h3Res] = await Promise.all([
    getOptometryDataList({ page: 1, pageSize: 100, ...query }),
    getOptometryDataByType1(query),
    getOptometryDataByType2(query),
    getOptometryDataByType3(query)
  ])
  if (dataRes.code === 0) tableData.value = dataRes.data.list || []
  if (h1Res.code === 0) headers1.value = (h1Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
  if (h2Res.code === 0) headers2.value = (h2Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
  if (h3Res.code === 0) headers3.value = (h3Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
}

onMounted(() => {
  // if (userId) loadData()
  if (userId.value && !Number.isNaN(userId.value)) {
    loadData()
  }
})
</script>
