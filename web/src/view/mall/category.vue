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
        <el-button icon="expand" @click="expandAll">展开全部</el-button>
        <el-button icon="fold" @click="collapseAll">折叠全部</el-button>
      </div>
      <el-table
        ref="tableRef"
        :data="treeData"
        row-key="id"
        border
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        default-expand-all
      >
        <el-table-column align="left" label="分类名称" prop="name" min-width="180" />
        <el-table-column align="left" label="分类ID" prop="id" min-width="160" show-overflow-tooltip />
        <el-table-column align="left" label="父分类" min-width="120">
          <template #default="scope">
            {{ getParentName(scope.row.parentId) }}
          </template>
        </el-table-column>
        <el-table-column align="left" label="排序" prop="sort" min-width="70" />
        <el-table-column align="left" label="状态" min-width="80">
          <template #default="scope">
            <el-tag :type="scope.row.enable === 1 ? 'success' : 'danger'">
              {{ scope.row.enable === 1 ? '启用' : '禁用' }}
            </el-tag>
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

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="父分类" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="parentCategoryOptions"
            :props="{ label: 'name', value: 'id', children: 'children' }"
            placeholder="请选择父分类（空为顶级）"
            check-strictly
            :render-after-expand="false"
            clearable
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="form.name" placeholder="分类名称" />
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
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getGoodsCategoryTree, createGoodsCategory, updateGoodsCategory, deleteGoodsCategory } from '@/api/mall'

const searchInfo = ref({})
const tableRef = ref(null)
const treeData = ref([])
const flatList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({})
const rules = reactive({ name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }] })

// 构建树结构
const buildTree = (list) => {
  const map = {}
  const roots = []
  // 先建立 id 映射
  list.forEach(item => {
    map[item.id] = { ...item, children: [] }
  })
  list.forEach(item => {
    const node = map[item.id]
    const pid = item.parentId || '0'
    if (pid && pid !== '0' && map[pid]) {
      map[pid].children.push(node)
    } else {
      roots.push(node)
    }
  })
  return roots
}

// 获取所有分类数据（用于表格和下拉选项）
const fetchAllCategories = async () => {
  const res = await getGoodsCategoryTree()
  if (res.code === 0) {
    flatList.value = res.data || []
    treeData.value = buildTree(flatList.value)
  }
}

// 根据名称过滤树
const getTableData = async () => {
  const res = await getGoodsCategoryTree()
  if (res.code === 0) {
    const all = res.data || []
    flatList.value = all
    const name = searchInfo.value.name
    if (name) {
      const filtered = all.filter(item => item.name && item.name.includes(name))
      treeData.value = buildTree(filtered)
    } else {
      treeData.value = buildTree(all)
    }
  }
}

// 获取父分类名称
const getParentName = (parentId) => {
  if (!parentId || parentId === '0') return '顶级分类'
  const parent = flatList.value.find(item => item.id === parentId)
  return parent ? parent.name : parentId
}

// 展开/折叠全部
const expandAll = () => {
  toggleRowExpansion(true)
}
const collapseAll = () => {
  toggleRowExpansion(false)
}
const toggleRowExpansion = (expanded) => {
  if (!tableRef.value) return
  const table = tableRef.value
  const doToggle = (nodes) => {
    nodes.forEach(node => {
      table.toggleRowExpansion(node, expanded)
      if (node.children && node.children.length) {
        doToggle(node.children)
      }
    })
  }
  doToggle(treeData.value)
}

// 父分类下拉选项（编辑时排除自身及子分类）
const parentCategoryOptions = computed(() => {
  if (!form.value.id) {
    // 新增模式：展示全部分类 + 顶级选项
    return buildTree(flatList.value)
  }
  // 编辑模式：排除当前分类及其所有子孙分类
  const excludeIds = new Set()
  // 构建 children 索引
  const mapChildren = {}
  flatList.value.forEach(item => {
    const pid = item.parentId || '0'
    if (!mapChildren[pid]) mapChildren[pid] = []
    mapChildren[pid].push(item.id)
  })
  // 收集要排除的ID
  const stack = [form.value.id]
  while (stack.length) {
    const id = stack.pop()
    excludeIds.add(id)
    ;(mapChildren[id] || []).forEach(childId => stack.push(childId))
  }
  const filtered = flatList.value.filter(item => !excludeIds.has(item.id))
  return buildTree(filtered)
})

const onSubmit = () => getTableData()
const onReset = () => { searchInfo.value = {}; getTableData() }

// 打开新增/编辑弹窗
const openDialog = (type, row) => {
  dialogTitle.value = type === 'add' ? '新增分类' : '编辑分类'
  if (type === 'add') {
    form.value = { enable: 1, sort: 0, parentId: '' }
  } else {
    form.value = { ...row }
  }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    // 父分类为空字符串时设为 "0"（顶级分类）
    const data = { ...form.value }
    if (!data.parentId || data.parentId === '') {
      data.parentId = '0'
    }
    const res = data.id ? await updateGoodsCategory(data) : await createGoodsCategory(data)
    if (res.code === 0) { ElMessage.success('操作成功'); dialogVisible.value = false; fetchAllCategories() }
  })
}

// 删除分类
const deleteRow = async (row) => {
  await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' })
  const res = await deleteGoodsCategory({ id: row.id })
  if (res.code === 0) { ElMessage.success('删除成功'); fetchAllCategories() }
}

onMounted(() => fetchAllCategories())
</script>
