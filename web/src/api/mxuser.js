import service from '@/utils/request'

/**
 * 查询用户列表
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getMxUserList = (data) => {
  return service({
    // url: '/store/getMxUserList',
    // method: 'post',
    url: '/store/mxUserList',
    method: 'get',
    params: data
  })
}

/**
 * 查询用户详情
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getMxUser = (data) => {
  return service({
    // url: '/store/getMxUser',
    url: '/store/mxUser',
    method: 'get',
    params: data
  })
}

/**
 * 创建用户
 * @param {Object} data 用户数据
 * @returns {Promise}
 */
export const createMxUser = (data) => {
  return service({
    // url: '/store/createMxUser',
    url: '/store/mxUser',
    method: 'post',
    data
  })
}

/**
 * 更新用户
 * @param {Object} data 用户数据
 * @returns {Promise}
 */
export const updateMxUser = (data) => {
  return service({
    // url: '/store/updateMxUser',
    url: '/store/mxUser',
    method: 'put',
    data
  })
}

/**
 * 删除用户
 * @param {Object} data 用户数据
 * @returns {Promise}
 */
export const deleteMxUser = (data) => {
  return service({
    // url: '/store/deleteMxUser',
    url: '/store/mxUser',
    method: 'delete',
    data
  })
}

/**
 * 查询用户流程列表
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getUserFlowList = (data) => {
  return service({
    // url: '/store/getUserFlowList',
    // method: 'post',
    url: '/store/mxUserFlowList',
    method: 'get',
    params: data
  })
}

/**
 * 查询用户流程详情
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getUserFlow = (data) => {
  return service({
    // url: '/store/getUserFlow',
    url: '/store/mxUserFlow',
    method: 'get',
    params: data
  })
}

/**
 * 查询激活码列表
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getActivationCodeList = (data) => {
  return service({
    // url: '/store/getActivationCodeList',
    // method: 'post',
    url: '/store/mxActivationCodeList',
    method: 'get',
    params: data
  })
}

/**
 * 生成激活码
 * @description 使用后端生成接口，兼容页面传入的 deviceId 字段
 * @param {Object} data 表单数据
 * @returns {Promise}
 */
export const createActivationCode = (data) => {
  const equipment = data?.equipment || data?.deviceId || ''
  const app = data?.app || ''
  return service({
    url: '/store/mxActivationCode/generate',
    method: 'post',
    params: { app, equipment }
  })
}

export const deleteActivationCode = (data) => {
  return service({
    url: '/store/mxActivationCode',
    method: 'delete',
    data
  })
}

/**
 * 更新激活码/设备信息
 * @param {Object} data 设备数据
 * @returns {Promise}
 */
export const updateActivationCode = (data) => {
  return service({
    url: '/store/mxActivationCode',
    method: 'put',
    data
  })
}

/**
 * 查询安装包列表
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getPackageList = (data) => {
  return service({
    // url: '/store/getPackageList',
    // method: 'post',
    url: '/store/installingPackageList',
    method: 'get',
    params: data
  })
}

/**
 * 创建安装包
 * @param {Object} data 安装包数据
 * @returns {Promise}
 */
export const createPackage = (data) => {
  return service({
    // url: '/store/createPackage',
    url: '/store/installingPackage',
    method: 'post',
    data
  })
}

/**
 * 更新安装包
 * @param {Object} data 安装包数据
 * @returns {Promise}
 */
export const updatePackage = (data) => {
  return service({
    // url: '/store/updatePackage',
    url: '/store/installingPackage',
    method: 'put',
    data
  })
}

/**
 * 删除安装包
 * @param {Object} data 安装包数据
 * @returns {Promise}
 */
export const deletePackage = (data) => {
  return service({
    // url: '/store/deletePackage',
    url: '/store/installingPackage',
    method: 'delete',
    data
  })
}

/**
 * 查询视图图片列表
 * @param {Object} data 查询参数
 * @returns {Promise}
 */
export const getPictureList = (data) => {
  return service({
    // url: '/store/getPictureList',
    // method: 'post',
    url: '/store/mxPictureList',
    method: 'get',
    params: data
  })
}

/**
 * 删除视图图片
 * @param {Object} data 图片数据
 * @returns {Promise}
 */
export const deletePicture = (data) => {
  return service({
    // url: '/store/deletePicture',
    url: '/store/mxPicture',
    method: 'delete',
    data
  })
}
