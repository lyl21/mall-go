<template>
  <div>
    <div class="gva-search-box">
      <el-form ref="searchForm" :inline="true" :model="searchInfo">
        <el-form-item label="顾客姓名">
          <el-input v-model="searchInfo.customerName" placeholder="顾客姓名" clearable />
        </el-form-item>
        <el-form-item label="验光师">
          <el-input v-model="searchInfo.optometristName" placeholder="验光师" clearable />
        </el-form-item>
        <el-form-item label="门店名称">
          <el-input v-model="searchInfo.storeName" placeholder="门店名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <el-table :data="tableData" row-key="optometryRecordsId">
        <el-table-column align="left" label="记录ID" prop="optometryRecordsId" min-width="80" />
        <el-table-column align="left" label="顾客姓名" prop="customerName" min-width="100" />
        <el-table-column align="left" label="验光师" prop="optometristName" min-width="100" />
        <el-table-column align="left" label="门店名称" prop="storeName" min-width="120" />
        <el-table-column align="left" label="门店电话" prop="storePhone" min-width="130" />
        <el-table-column align="left" label="创建时间" prop="createTime" min-width="170" />
        <el-table-column align="left" label="操作" min-width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="viewDetail(scope.row)">查看详情</el-button>
            <el-button type="primary" link icon="edit" @click="openDialog(scope.row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" title="编辑验光记录" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" label-width="100px">
        <el-form-item label="顾客姓名"><el-input v-model="form.customerName" /></el-form-item>
        <el-form-item label="验光师"><el-input v-model="form.optometristName" /></el-form-item>
        <el-form-item label="门店名称"><el-input v-model="form.storeName" /></el-form-item>
        <el-form-item label="门店电话"><el-input v-model="form.storePhone" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitEdit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailVisible" title="验光单详情" width="80%" destroy-on-close>
      <div ref="printRef">
        <el-descriptions title="基本信息" :column="3" border>
          <el-descriptions-item label="顾客姓名">{{ detailForm.customerName }}</el-descriptions-item>
          <el-descriptions-item label="验光师">{{ detailForm.optometristName }}</el-descriptions-item>
          <el-descriptions-item label="门店">{{ detailForm.storeName }}</el-descriptions-item>
          <el-descriptions-item label="门店电话">{{ detailForm.storePhone }}</el-descriptions-item>
          <el-descriptions-item label="时间">{{ detailForm.createTime }}</el-descriptions-item>
        </el-descriptions>

        <el-radio-group v-model="radio" style="margin: 16px 0">
          <el-radio-button label="1">验光单</el-radio-button>
          <el-radio-button label="2">视功能</el-radio-button>
        </el-radio-group>

        <!-- 验光单 -->
        <div v-if="radio === '1'">
          <el-table :data="headers1" border style="margin-top: 10px">
            <el-table-column prop="label" label="项目" width="140" />
            <el-table-column label="电脑验光仪">
              <el-table-column label="右眼" prop="dataRt1" />
              <el-table-column label="左眼" prop="dataLt1" />
            </el-table-column>
            <el-table-column label="查片仪">
              <el-table-column label="右眼" prop="dataRt2" />
              <el-table-column label="左眼" prop="dataLt2" />
            </el-table-column>
          </el-table>
          <el-table :data="headers2" border style="margin-top: 10px">
            <el-table-column prop="label" label="项目" width="140" />
            <el-table-column label="验光头-远用">
              <el-table-column label="右眼" prop="dataRf" />
              <el-table-column label="左眼" prop="dataLf" />
            </el-table-column>
            <el-table-column label="验光头-近用">
              <el-table-column label="右眼" prop="dataRn" />
              <el-table-column label="左眼" prop="dataLn" />
            </el-table-column>
          </el-table>
          <el-table :data="headers3" border style="margin-top: 10px">
            <el-table-column prop="label" label="项目" width="140" />
            <el-table-column label="最终配镜-远用">
              <el-table-column label="右眼" prop="dataRf" />
              <el-table-column label="左眼" prop="dataLf" />
            </el-table-column>
            <el-table-column label="最终配镜-近用">
              <el-table-column label="右眼" prop="dataRn" />
              <el-table-column label="左眼" prop="dataLn" />
            </el-table-column>
          </el-table>
        </div>

        <!-- 视功能 -->
        <div v-if="radio !== '1'">
          <el-descriptions title="视功能检查" :column="3" border style="margin-top: 10px">
            <el-descriptions-item label="远用沃氏四点">{{ vision.ww4points }}</el-descriptions-item>
            <el-descriptions-item label="立体观">{{ vision.stereoView }}</el-descriptions-item>
            <el-descriptions-item label="隐斜Von Graefe(远)BI">{{ vision.vgfBi }}</el-descriptions-item>
            <el-descriptions-item label="隐斜Von Graefe(远)BU">{{ vision.vgfBu }}</el-descriptions-item>
            <el-descriptions-item label="AC/A(梯度法)">{{ vision.aca }}</el-descriptions-item>
            <el-descriptions-item label="隐斜Von Graefe(近)BI">{{ vision.vgnBi }}</el-descriptions-item>
            <el-descriptions-item label="隐斜Von Graefe(近)BU">{{ vision.vgnBu }}</el-descriptions-item>
            <el-descriptions-item label="NRA">{{ vision.nra }}</el-descriptions-item>
            <el-descriptions-item label="BCC">{{ vision.bcc }}</el-descriptions-item>
            <el-descriptions-item label="PRA">{{ vision.pra }}</el-descriptions-item>
            <el-descriptions-item label="双眼翻转拍">{{ vision.binoculus }}</el-descriptions-item>
            <el-descriptions-item label="右眼翻转拍">{{ vision.rightEye }}</el-descriptions-item>
            <el-descriptions-item label="左眼翻转拍">{{ vision.leftEye }}</el-descriptions-item>
            <el-descriptions-item label="诊断名称">{{ vision.diagnosisName }}</el-descriptions-item>
            <el-descriptions-item label="建议方案" :span="2">{{ vision.sugggestions }}</el-descriptions-item>
          </el-descriptions>
          <el-descriptions title="试戴验光" :column="4" border style="margin-top: 10px">
            <el-descriptions-item label="右眼-球镜">{{ tryOnR.sphericalMirror }}</el-descriptions-item>
            <el-descriptions-item label="右眼-柱镜">{{ tryOnR.cylindricalMirror }}</el-descriptions-item>
            <el-descriptions-item label="右眼-轴位">{{ tryOnR.positionOfAxis }}</el-descriptions-item>
            <el-descriptions-item label="右眼-ADD">{{ tryOnR.addend }}</el-descriptions-item>
            <el-descriptions-item label="左眼-球镜">{{ tryOnL.sphericalMirror }}</el-descriptions-item>
            <el-descriptions-item label="左眼-柱镜">{{ tryOnL.cylindricalMirror }}</el-descriptions-item>
            <el-descriptions-item label="左眼-轴位">{{ tryOnL.positionOfAxis }}</el-descriptions-item>
            <el-descriptions-item label="左眼-ADD">{{ tryOnL.addend }}</el-descriptions-item>
          </el-descriptions>
        </div>
      </div>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" @click="printPage">打印</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  getOptometryRecordList, getOptometryRecord, updateOptometryRecord,
  getOptometryDataByType1, getOptometryDataByType2, getOptometryDataByType3,
  getVisionTestAndTryOn
} from '@/api/optometry'

const route = useRoute()
const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

const dialogVisible = ref(false)
const detailVisible = ref(false)
const formRef = ref(null)
const form = ref({})
const radio = ref('1')
const detailForm = ref({})
const headers1 = ref([])
const headers2 = ref([])
const headers3 = ref([])
const vision = ref({})
const tryOnR = ref({})
const tryOnL = ref({})
const printRef = ref(null)

const getTableData = async () => {
  const res = await getOptometryRecordList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
  if (res.code === 0) {
    tableData.value = res.data.list
    total.value = res.data.total
  }
}

const onSubmit = () => { page.value = 1; getTableData() }
const onReset = () => { searchInfo.value = {}; getTableData() }
const handleCurrentChange = (val) => { page.value = val; getTableData() }

const openDialog = async (row) => {
  const res = await getOptometryRecord({ optometryRecordsId: row.optometryRecordsId })
  if (res.code === 0) {
    form.value = { ...res.data }
    dialogVisible.value = true
  }
}

const submitEdit = async () => {
  const res = await updateOptometryRecord(form.value)
  if (res.code === 0) { ElMessage.success('修改成功'); dialogVisible.value = false; getTableData() }
}

const viewDetail = async (row) => {
  radio.value = '1'
  const recordId = row.optometryRecordsId
  const [recordRes, h1Res, h2Res, h3Res, visionRes] = await Promise.all([
    getOptometryRecord({ optometryRecordsId: recordId }),
    getOptometryDataByType1({ optometryRecordsId: recordId }),
    getOptometryDataByType2({ optometryRecordsId: recordId }),
    getOptometryDataByType3({ optometryRecordsId: recordId }),
    getVisionTestAndTryOn({ optometryRecordsId: recordId })
  ])
  if (recordRes.code === 0) detailForm.value = recordRes.data
  if (h1Res.code === 0) headers1.value = (h1Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
  if (h2Res.code === 0) headers2.value = (h2Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
  if (h3Res.code === 0) headers3.value = (h3Res.data.list || []).map(r => Object.fromEntries(Object.entries(r).map(([k, v]) => [k, v ?? '\\'])))
  if (visionRes.code === 0) {
    vision.value = visionRes.data.visionTestResults || {}
    const tryList = visionRes.data.optometryList || []
    tryList.forEach(item => {
      if (item.leftRightEyes === 0) tryOnL.value = item
      else tryOnR.value = item
    })
  }
  detailVisible.value = true
}

const printPage = () => {
  const content = printRef.value.innerHTML
  const iframe = document.createElement('iframe')
  iframe.style.cssText = 'position:absolute;width:0;height:0;border:none'
  document.body.appendChild(iframe)
  const doc = iframe.contentWindow.document
  doc.open()
  doc.write(`<html><head><title>验光单</title><style>body{margin:10mm;font-family:SimSun}table{border-collapse:collapse;width:100%}td,th{border:1px solid #333;padding:4px;text-align:center}</style></head><body><h2 style="text-align:center">希铭光学 - 验光单</h2>${content}</body></html>`)
  doc.close()
  iframe.contentWindow.print()
  setTimeout(() => document.body.removeChild(iframe), 1000)
}

onMounted(() => {
  // 如果 URL 中有 userId 参数，则根据用户ID筛选（转换为 customerId）
  if (route.query.userId) {
    searchInfo.value.customerId = parseInt(route.query.userId)
  }
  getTableData()
})
</script>
