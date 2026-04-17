<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="订单号">
          <el-input v-model="searchInfo.orderNo" placeholder="订单号" clearable />
        </el-form-item>
        <el-form-item label="用户ID">
          <el-input v-model="searchInfo.userId" placeholder="用户ID" clearable />
        </el-form-item>
        <el-form-item label="订单状态">
          <el-select v-model="searchInfo.status" placeholder="订单状态" clearable>
            <el-option label="待付款" value="0" />
            <el-option label="待发货" value="1" />
            <el-option label="待收货" value="2" />
            <el-option label="已完成" value="3" />
            <el-option label="已关闭" value="5" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="订单号" prop="orderNo" min-width="180" />
        <el-table-column align="left" label="用户ID" prop="userId" min-width="100" />
        <el-table-column align="left" label="商品信息" min-width="200" show-overflow-tooltip>
          <template #default="scope">
            <span v-if="scope.row.orderItems && scope.row.orderItems.length">
              {{ getGoodsSummary(scope.row.orderItems) }}
            </span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="商品数量" min-width="80">
          <template #default="scope">
            <span v-if="scope.row.orderItems && scope.row.orderItems.length">
              {{ getTotalQuantity(scope.row.orderItems) }}件
            </span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="支付金额" prop="paymentPrice" min-width="100">
          <template #default="scope">
            <span class="text-price">¥{{ scope.row.paymentPrice }}</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="运费" prop="freightPrice" min-width="70">
          <template #default="scope">
            <span v-if="scope.row.freightPrice > 0">¥{{ scope.row.freightPrice }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column align="left" label="支付方式" min-width="90">
          <template #default="scope">
            <el-tag size="small">{{ paymentWayLabel(scope.row.paymentWay) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="订单状态" min-width="90">
          <template #default="scope">
            <el-tag :type="statusType(scope.row.status)">{{ statusLabel(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="创建时间" prop="createTime" min-width="160" />
        <el-table-column align="left" label="操作" min-width="280" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="view" @click="viewOrder(scope.row)">详情</el-button>
            <el-button type="primary" link icon="edit" @click="openStatusDialog(scope.row)">改状态</el-button>
            <el-button v-if="scope.row.status === '0'" type="danger" link icon="close" @click="cancelOrder(scope.row)">取消</el-button>
            <el-button v-if="scope.row.status === '1'" type="success" link icon="box" @click="openShipDialog(scope.row)">发货</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination layout="total, prev, pager, next, jumper" :current-page="page" :page-size="pageSize" :total="total" @current-change="handleCurrentChange" />
      </div>
    </div>

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="900px" destroy-on-close>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="订单号">{{ detail.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ detail.userId }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">{{ paymentWayLabel(detail.paymentWay) }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="statusType(detail.status)">{{ statusLabel(detail.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="销售金额">¥{{ detail.salesPrice }}</el-descriptions-item>
        <el-descriptions-item label="运费">¥{{ detail.freightPrice }}</el-descriptions-item>
        <el-descriptions-item label="支付金额">
          <span class="text-price text-bold">¥{{ detail.paymentPrice }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="买家留言">{{ detail.userMessage || '-' }}</el-descriptions-item>
        <el-descriptions-item label="收货人">{{ detail.logistics?.userName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ detail.logistics?.telNum || '-' }}</el-descriptions-item>
        <el-descriptions-item label="收货地址" :span="2">{{ detail.logistics?.address || '-' }}</el-descriptions-item>
        <el-descriptions-item label="物流公司">{{ detail.logistics?.logistics || '-' }}</el-descriptions-item>
        <el-descriptions-item label="物流单号">{{ detail.logistics?.logisticsNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detail.createTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ detail.paymentTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="发货时间">{{ detail.deliveryTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="收货时间">{{ detail.receiverTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detail.remark || '-' }}</el-descriptions-item>
      </el-descriptions>

      <!-- 商品明细 -->
      <div class="goods-section" v-if="detail.orderItems && detail.orderItems.length">
        <h4>商品明细</h4>
        <el-table :data="detail.orderItems" border size="small">
          <el-table-column label="商品图片" width="80">
            <template #default="scope">
              <el-image 
                v-if="scope.row.picUrl" 
                :src="getFullImageUrl(scope.row.picUrl)" 
                fit="cover" 
                style="width: 50px; height: 50px; border-radius: 4px;"
                :preview-src-list="[getFullImageUrl(scope.row.picUrl)]"
              />
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="商品名称" prop="spuName" min-width="150" show-overflow-tooltip />
          <el-table-column label="商品ID" prop="spuId" width="120" show-overflow-tooltip />
          <el-table-column label="单价" width="100">
            <template #default="scope">¥{{ scope.row.salesPrice }}</template>
          </el-table-column>
          <el-table-column label="数量" prop="quantity" width="70" align="center" />
          <el-table-column label="小计" width="100">
            <template #default="scope">¥{{ (scope.row.salesPrice * scope.row.quantity).toFixed(2) }}</template>
          </el-table-column>
          <el-table-column label="退款状态" width="90">
            <template #default="scope">
              <el-tag v-if="scope.row.isRefund === '1'" type="warning" size="small">已退款</el-tag>
              <el-tag v-else-if="scope.row.status === '1'" type="warning" size="small">退款中</el-tag>
              <el-tag v-else type="success" size="small">正常</el-tag>
            </template>
          </el-table-column>
        </el-table>
        <div class="goods-total">
          共 {{ detail.orderItems.length }} 种商品，合计 {{ getTotalQuantity(detail.orderItems) }} 件
        </div>
      </div>

      <!-- 物流信息 -->
      <div class="logistics-section" v-if="detail.logistics && detail.logistics.logisticsNo">
        <h4>物流信息</h4>
        <el-descriptions :column="2" border size="small">
          <el-descriptions-item label="物流公司">{{ detail.logistics.logistics || '-' }}</el-descriptions-item>
          <el-descriptions-item label="物流单号">{{ detail.logistics.logisticsNo || '-' }}</el-descriptions-item>
          <el-descriptions-item label="快递状态">
            <el-tag v-if="detail.logistics.isCheck === '1'" type="success" size="small">已签收</el-tag>
            <el-tag v-else type="info" size="small">运输中</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="邮编">{{ detail.logistics.postalCode || '-' }}</el-descriptions-item>
        </el-descriptions>
        <div class="logistics-message" v-if="detail.logistics.message">
          <h5>物流详情：</h5>
          <p>{{ detail.logistics.message }}</p>
        </div>
      </div>
    </el-dialog>

    <!-- 修改状态弹窗 -->
    <el-dialog v-model="statusVisible" title="修改订单状态" width="400px">
      <el-form :model="statusForm" label-width="100px">
        <el-form-item label="当前状态">
          <el-tag :type="statusType(statusForm.currentStatus)">{{ statusLabel(statusForm.currentStatus) }}</el-tag>
        </el-form-item>
        <el-form-item label="新状态">
          <el-select v-model="statusForm.newStatus" placeholder="请选择新状态">
            <el-option
              v-for="item in availableStatuses"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="statusVisible = false">取消</el-button>
        <el-button type="primary" @click="updateStatus">确定</el-button>
      </template>
    </el-dialog>

    <!-- 发货弹窗 -->
    <el-dialog v-model="shipVisible" title="订单发货" width="500px">
      <el-form :model="shipForm" label-width="100px" :rules="shipRules" ref="shipFormRef">
        <el-form-item label="订单号">
          <span>{{ shipForm.orderNo }}</span>
        </el-form-item>
        <el-form-item label="物流公司" prop="logistics">
          <el-input v-model="shipForm.logistics" placeholder="请输入物流公司" />
        </el-form-item>
        <el-form-item label="物流单号" prop="logisticsNo">
          <el-input v-model="shipForm.logisticsNo" placeholder="请输入物流单号" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="shipVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmShip">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { getOrderInfoList, getOrderInfo, updateOrderStatus, cancelOrder as apiCancelOrder, shipOrder as apiShipOrder } from '@/api/mall'
import { getUrl } from '@/utils/image'
import { ElMessage, ElMessageBox } from 'element-plus'

const searchInfo = ref({})
const tableData = ref([])
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const detailVisible = ref(false)
const detail = ref({})
const statusVisible = ref(false)
const statusForm = ref({
  id: '',
  currentStatus: '',
  newStatus: ''
})
const shipVisible = ref(false)
const shipFormRef = ref(null)
const shipForm = ref({
  id: '',
  orderNo: '',
  logistics: '',
  logisticsNo: ''
})

const shipRules = {
  logistics: [{ required: true, message: '请输入物流公司', trigger: 'blur' }],
  logisticsNo: [{ required: true, message: '请输入物流单号', trigger: 'blur' }]
}

const statusMap = { '0': '待付款', '1': '待发货', '2': '待收货', '3': '已完成', '5': '已关闭' }
const paymentWayMap = { '1': '货到付款', '2': '在线支付' }
const typeMap = { '0': 'info', '1': 'warning', '2': '', '3': 'success', '5': 'danger' }
const statusLabel = (s) => statusMap[s] || '未知'
const statusType = (s) => typeMap[s] || 'info'
const paymentWayLabel = (w) => paymentWayMap[w] || '-'

const getGoodsSummary = (items) => {
  if (!items || !items.length) return '-'
  const names = items.map(item => item.spuName || '未知商品').slice(0, 2)
  const suffix = items.length > 2 ? `...等${items.length}种` : ''
  return names.join('、') + suffix
}

const getTotalQuantity = (items) => {
  if (!items || !items.length) return 0
  return items.reduce((sum, item) => sum + (item.quantity || 0), 0)
}

const getFullImageUrl = (url) => {
  if (!url) return null
  return getUrl(url)
}

// 状态流转规则
const statusTransitions = {
  '0': ['1', '5'],      // 待付款 -> 待发货/已关闭
  '1': ['2', '5'],      // 待发货 -> 待收货/已关闭
  '2': ['3', '5'],      // 待收货 -> 已完成/已关闭
  '3': [],              // 已完成（终态）
  '5': []               // 已关闭（终态）
}

const availableStatuses = computed(() => {
  const allowed = statusTransitions[statusForm.value.currentStatus] || []
  return allowed.map(value => ({
    value,
    label: statusMap[value]
  }))
})

const getTableData = async () => {
  const res = await getOrderInfoList({ page: page.value, pageSize: pageSize.value, ...searchInfo.value })
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
  getTableData() 
}

const handleCurrentChange = (v) => { 
  page.value = v
  getTableData() 
}

const viewOrder = async (row) => {
  const res = await getOrderInfo({ id: row.id })
  if (res.code === 0) { 
    detail.value = res.data
    detailVisible.value = true 
  }
}

// 打开修改状态弹窗
const openStatusDialog = (row) => {
  statusForm.value = {
    id: row.id,
    currentStatus: row.status,
    newStatus: ''
  }
  statusVisible.value = true
}

// 更新订单状态
const updateStatus = async () => {
  if (!statusForm.value.newStatus) {
    ElMessage.warning('请选择新状态')
    return
  }
  
  try {
    const res = await updateOrderStatus({ 
      id: statusForm.value.id, 
      status: statusForm.value.newStatus 
    })
    if (res.code === 0) {
      ElMessage.success('状态更新成功')
      statusVisible.value = false
      getTableData()
    } else {
      ElMessage.error(res.msg || '状态更新失败')
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.msg || '状态更新失败')
  }
}

// 取消订单
const cancelOrder = (row) => {
  ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await apiCancelOrder({ id: row.id })
      if (res.code === 0) {
        ElMessage.success('订单已取消')
        getTableData()
      } else {
        ElMessage.error(res.msg || '取消失败')
      }
    } catch (error) {
      ElMessage.error(error.response?.data?.msg || '取消失败')
    }
  }).catch(() => {})
}

// 打开发货弹窗
const openShipDialog = (row) => {
  shipForm.value = {
    id: row.id,
    orderNo: row.orderNo,
    logistics: '',
    logisticsNo: ''
  }
  shipVisible.value = true
}

// 确认发货
const confirmShip = async () => {
  if (!shipFormRef.value) return
  
  await shipFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const res = await apiShipOrder({
          id: shipForm.value.id,
          logistics: shipForm.value.logistics,
          logisticsNo: shipForm.value.logisticsNo
        })
        if (res.code === 0) {
          ElMessage.success('发货成功')
          shipVisible.value = false
          getTableData()
        } else {
          ElMessage.error(res.msg || '发货失败')
        }
      } catch (error) {
        ElMessage.error(error.response?.data?.msg || '发货失败')
      }
    }
  })
}

onMounted(() => getTableData())
</script>

<style lang="scss" scoped>
.text-price {
  color: #f56c6c;
  font-weight: 500;
}
.text-bold {
  font-weight: 600;
  font-size: 16px;
}
.goods-section,
.logistics-section {
  margin-top: 20px;
  h4 {
    margin-bottom: 12px;
    padding-left: 10px;
    border-left: 3px solid #409eff;
    color: #303133;
  }
}
.goods-total {
  margin-top: 12px;
  text-align: right;
  color: #606266;
  font-size: 14px;
}
.logistics-message {
  margin-top: 12px;
  padding: 12px;
  background: #f5f7fa;
  border-radius: 4px;
  h5 {
    margin: 0 0 8px;
    color: #303133;
  }
  p {
    margin: 0;
    color: #606266;
    white-space: pre-wrap;
  }
}
</style>
