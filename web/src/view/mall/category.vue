<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="分类名称">
          <el-input v-model="searchInfo.name" placeholder="分类名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增分类</el-button>
      </div>
      <el-table :data="tableData" row-key="id" border>
        <el-table-column align="left" label="分类ID" prop="id" min-width="120" />
        <el-table-column align="left" label="分类名称" prop="name" min-width="150" />
        <el-table-column align="left" label="父分类ID" prop="parentId" min-width="120" />
        <el-table-column align="left" label="排序" prop="sort" min-width="80" />
        <el-table-column align="left" label="状态" prop="enable" min-width="80">
          <template #default="scope">
            <el-tag :type="scope.row.enable === 1 ? 'success' : 'danger'">{{ scope.row.enable === 1 ? '启用' : '禁用' }}</el-tag>
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="form.name" placeholder="分类名称" />
        </el-form-item>
        <el-form-item label="父分类ID" prop="parentId">
          <el-input v-model="form.parentId" placeholder="0为顶级分类" />
        </el-form-item>
        <el-form-item label="图标">
          <el-input v-model="form.icon" placeholder="图标URL" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.enable" :active-value="1" :inactive-value="0" />
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
import { getGoodsCategoryList, createGoodsCategory, updateGoodsCategory, deleteGoodsCategory } from '@/api/mall'

const searchInfo = ref({})
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const rules = reactive({ name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }] })

const getTableData = async () => {
  const res = await getGoodsCategoryList({ ...searchInfo.value })
  if (res.code === 0) tableData.value = res.data.list || []
}
const onSubmit = () => getTableData()
const onReset = () => { searchInfo.value = {}; getTableData() }

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增分类' : '编辑分类'
  form.value = type === 'add' ? { enable: 1, sort: 0, parentId: '0' } : { ...row }
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const res = form.value.id ? await updateGoodsCategory(form.value) : await createGoodsCategory(form.value)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; getTableData() }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteGoodsCategory({ id: row.id })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

onMounted(() => getTableData())
</script>
