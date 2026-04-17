import service from '@/utils/request'

/**
 * 查询门店列表
 * @description 对齐后端路由：GET /store/mxStoreList
 * @param {Object} params 查询参数（page、pageSize、search等）
 * @returns {Promise}
 */
export const getStoreList = (data) => {
  return service({
    // url: '/store/getStoreList',
    // method: 'post',
    url: '/store/mxStoreList',
    method: 'get',
    params: data
  })
}

/**
 * 查询门店详情
 * @description 对齐后端路由：GET /store/mxStore
 * @param {Object} params 查询参数（storeId）
 * @returns {Promise}
 */
export const getStore = (data) => {
  return service({
    // url: '/store/getStore',
    url: '/store/mxStore',
    method: 'get',
    params: data
  })
}

/**
 * 创建门店
 * @description 对齐后端路由：POST /store/mxStore
 * @param {Object} data 门店表单数据
 * @returns {Promise}
 */
export const createStore = (data) => {
  // 后端创建接口要求 body 为 { store, member } 结构
  // 兼容当前页面表单，仅使用 userId 自动组装店长成员信息
  const payload = {
    store: data,
    member: {
      userId: data?.userId,
      post: 1
    }
  }
  return service({
    // url: '/store/createStore',
    url: '/store/mxStore',
    method: 'post',
    data: payload
  })
}

/**
 * 更新门店
 * @description 对齐后端路由：PUT /store/mxStore
 * @param {Object} data 门店数据
 * @returns {Promise}
 */
export const updateStore = (data) => {
  return service({
    // url: '/store/updateStore',
    url: '/store/mxStore',
    method: 'put',
    data
  })
}

/**
 * 删除门店
 * @description 对齐后端路由：DELETE /store/mxStore
 * @param {Object} data 删除参数（storeId）
 * @returns {Promise}
 */
export const deleteStore = (data) => {
  return service({
    // url: '/store/deleteStore',
    url: '/store/mxStore',
    method: 'delete',
    data
  })
}

/**
 * 查询门店成员列表
 * @description 对齐后端路由：GET /store/mxStoreMemberList
 * @param {Object} params 查询参数（storeId、page、pageSize）
 * @returns {Promise}
 */
export const getStoreMemberList = (data) => {
  return service({
    // url: '/store/getStoreMemberList',
    // method: 'post',
    url: '/store/mxStoreMemberList',
    method: 'get',
    params: data
  })
}

/**
 * 查询门店成员详情
 * @description 对齐后端路由：GET /store/mxStoreMember
 * @param {Object} params 查询参数（storeId、userId）
 * @returns {Promise}
 */
export const getStoreMember = (data) => {
  return service({
    // url: '/store/getStoreMember',
    url: '/store/mxStoreMember',
    method: 'get',
    params: data
  })
}

/**
 * 创建门店成员
 * @description 对齐后端路由：POST /store/mxStoreMember
 * @param {Object} data 成员数据
 * @returns {Promise}
 */
export const createStoreMember = (data) => {
  return service({
    // url: '/store/createStoreMember',
    url: '/store/mxStoreMember',
    method: 'post',
    data
  })
}

/**
 * 更新门店成员
 * @description 对齐后端路由：PUT /store/mxStoreMember
 * @param {Object} data 成员数据
 * @returns {Promise}
 */
export const updateStoreMember = (data) => {
  return service({
    // url: '/store/updateStoreMember',
    url: '/store/mxStoreMember',
    method: 'put',
    data
  })
}

/**
 * 删除门店成员
 * @description 对齐后端路由：DELETE /store/mxStoreMember
 * @param {Object} params 删除参数（storeId、userId）
 * @returns {Promise}
 */
export const deleteStoreMember = (data) => {
  return service({
    // url: '/store/deleteStoreMember',
    url: '/store/mxStoreMember',
    method: 'delete',
    params: data
  })
}
