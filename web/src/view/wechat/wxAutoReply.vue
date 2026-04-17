<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="关键词">
          <el-input v-model="searchInfo.keyword" placeholder="关键词" clearable />
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="searchInfo.replyType" placeholder="类型" clearable>
            <el-option label="文本" value="text" />
            <el-option label="图片" value="image" />
            <el-option label="关注回复" value="subscribe" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增回复规则</el-button>
      </div>
      <el-table :data="tableData" row-key="id">
        <el-table-column align="left" label="ID" prop="id" min-width="60" />
        <el-table-column align="left" label="关键词" prop="keyword" min-width="150" />
        <el-table-column align="left" label="回复类型" prop="replyType" min-width="100">
          <template #default="scope">
            <el-tag>{{ scope.row.replyType === 'text' ? '文本' : scope.row.replyType === 'image' ? '图片' : scope.row.replyType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="回复内容" prop="content" min-width="300" show-overflow-tooltip />
        <el-table-column align="left" label="状态" prop="status" min-width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">{{ scope.row.status === 1 ? '启用' : '禁用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="操作" min-width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" link icon="edit" @click="openDialog('edit', scope.row)">编辑</el-button>
            <el-button type="danger" link icon="delete" @click="deleteRow(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="关键词" prop="keyword"><el-input v-model="form.keyword" placeholder="多个关键词用逗号分隔" /></el-form-item>
        <el-form-item label="回复类型" prop="replyType">
          <el-select v-model="form.replyType" style="width: 100%">
            <el-option label="文本" value="text" />
            <el-option label="图片" value="image" />
          </el-select>
        </el-form-item>
        <el-form-item label="回复内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="5" placeholder="回复内容" />
        </el-form-item>
        <el-form-item label="媒体ID" v-if="form.replyType === 'image'">
          <el-input v-model="form.mediaId" placeholder="微信素材媒体ID" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getWxAutoReplyList, createWxAutoReply, updateWxAutoReply, deleteWxAutoReply } from '@/api/wechat'

const searchInfo = ref({})
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const rules = reactive({ keyword: [{ required: true, message: '关键词', trigger: 'blur' }], replyType: [{ required: true, message: '回复类型', trigger: 'change' }], content: [{ required: true, message: '回复内容', trigger: 'blur' }] })

const getTableData = async () => {
  const res = await getWxAutoReplyList({ ...searchInfo.value })
  if (res.code === 0) tableData.value = res.data.list || []
}
const onSubmit = () => getTableData()
const onReset = () => { searchInfo.value = {}; getTableData() }

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增回复规则' : '编辑回复规则'
  form.value = type === 'add' ? { status: 1, replyType: 'text' } : { ...row }
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const res = form.value.id ? await updateWxAutoReply(form.value) : await createWxAutoReply(form.value)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; getTableData() }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteWxAutoReply({ id: row.id })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

onMounted(() => getTableData())
</script>
