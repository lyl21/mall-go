<template>
  <div v-loading="uploading" element-loading-text="正在上传文件..." class="select-file-wrapper">
    <el-upload
      v-model:file-list="fileList"
      multiple
      :action="`${getBaseUrl()}/fileUploadAndDownload/upload?noSave=1`"
      :before-upload="beforeUpload"
      :on-error="uploadError"
      :on-success="uploadSuccess"
      :on-remove="uploadRemove"
      :show-file-list="true"
      :limit="limit"
      :accept="accept"
      class="upload-btn"
      :headers="{'x-token': token}"
    >
      <el-button type="primary"> 上传文件 </el-button>
    </el-upload>
  </div>
</template>

<script setup>
  import { ref } from 'vue'
  import { ElMessage } from 'element-plus'
  import { getBaseUrl } from '@/utils/format'
  import { useUserStore } from "@/pinia";

  defineOptions({
    name: 'UploadCommon'
  })

  defineProps({
    limit: {
      type: Number,
      default: 3
    },
    accept: {
      type: String,
      default: ''
    }
  })

  const userStore = useUserStore()

  const token = userStore.token

  const uploading = ref(false)

  const model = defineModel({ type: Array })

  const fileList = ref(model.value || [])

  const emits = defineEmits(['on-success', 'on-error'])

  // 上传前回调：开启 loading 状态
  const beforeUpload = () => {
    uploading.value = true
    return true
  }

  const uploadSuccess = (res) => {
    uploading.value = false
    const { data, code } = res
    if (code !== 0) {
      ElMessage({
        type: 'error',
        message: '上传失败' + res.msg
      })
      fileList.value.pop()
      return
    }
    model.value.push({
      name: data.file.name,
      url: data.file.url
    })
    emits('on-success', res)
  }

  const uploadRemove = (file) => {
    const index = model.value.indexOf(file)
    if (index > -1) {
      model.value.splice(index, 1)
      fileList.value = model.value
    }
  }

  const uploadError = (err) => {
    uploading.value = false
    ElMessage({
      type: 'error',
      message: '上传失败'
    })
    emits('on-error', err)
  }
</script>
