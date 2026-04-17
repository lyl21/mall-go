<template>
  <div>
    <div class="gva-search-box">
      <el-form :inline="true" :model="searchInfo">
        <el-form-item label="菜单名称">
          <el-input v-model="searchInfo.name" placeholder="菜单名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button icon="refresh" @click="onReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="openDialog('add')">新增菜单</el-button>
        <el-button type="success" icon="upload" @click="syncMenu">同步到微信</el-button>
      </div>
      <el-table :data="tableData" row-key="menuId" border>
        <el-table-column align="left" label="菜单ID" prop="menuId" min-width="100" />
        <el-table-column align="left" label="菜单名称" prop="name" min-width="150" />
        <el-table-column align="left" label="父菜单ID" prop="parentId" min-width="100" />
        <el-table-column align="left" label="菜单类型" prop="menuType" min-width="100">
          <template #default="scope">
            <el-tag>{{ scope.row.menuType === 'click' ? '点击' : scope.row.menuType === 'view' ? '跳转' : scope.row.menuType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="left" label="菜单KEY" prop="menuKey" min-width="150" />
        <el-table-column align="left" label="URL" prop="url" min-width="200" show-overflow-tooltip />
        <el-table-column align="left" label="排序" prop="sort" min-width="80" />
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
        <el-form-item label="菜单名称" prop="name"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="父菜单ID"><el-input v-model="form.parentId" placeholder="0为顶级" /></el-form-item>
        <el-form-item label="菜单类型" prop="menuType">
          <el-select v-model="form.menuType" style="width: 100%">
            <el-option label="点击事件" value="click" />
            <el-option label="跳转URL" value="view" />
            <el-option label="小程序" value="miniprogram" />
          </el-select>
        </el-form-item>
        <el-form-item label="菜单KEY"><el-input v-model="form.menuKey" placeholder="click类型必填" /></el-form-item>
        <el-form-item label="URL"><el-input v-model="form.url" placeholder="view类型必填" /></el-form-item>
        <el-form-item label="小程序AppId"><el-input v-model="form.appId" /></el-form-item>
        <el-form-item label="小程序路径"><el-input v-model="form.pagePath" /></el-form-item>
        <el-form-item label="媒体ID"><el-input v-model="form.mediaId" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="form.sort" :min="0" /></el-form-item>
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
import { getWxMenuList, createWxMenu, updateWxMenu, deleteWxMenu } from '@/api/wechat'

const searchInfo = ref({})
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const rules = reactive({ name: [{ required: true, message: '菜单名称', trigger: 'blur' }], menuType: [{ required: true, message: '菜单类型', trigger: 'change' }] })

const getTableData = async () => {
  const res = await getWxMenuList({ ...searchInfo.value })
  if (res.code === 0) tableData.value = res.data.list || []
}
const onSubmit = () => getTableData()
const onReset = () => { searchInfo.value = {}; getTableData() }

const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增菜单' : '编辑菜单'
  form.value = type === 'add' ? { sort: 0, parentId: '0', menuType: 'click' } : { ...row }
  dialogVisible.value = true
}

const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    const res = form.value.menuId ? await updateWxMenu(form.value) : await createWxMenu(form.value)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; getTableData() }
  })
}

const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteWxMenu({ menuId: row.menuId })
  if (res.code === 0) { ElMessage.success('删除成功'); getTableData() }
}

const syncMenu = () => { ElMessage.info('同步菜单功能需要在后端实现微信API对接') }

onMounted(() => getTableData())
</script>
