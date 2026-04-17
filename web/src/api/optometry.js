import service from '@/utils/request'

// 查询验光记录列表
export const getOptometryRecordList = (data) => {
  return service({
    url: '/optometry/getOptometryRecordList',
    method: 'post',
    data
  })
}

// 查询验光记录详情
export const getOptometryRecord = (data) => {
  return service({
    url: '/optometry/getOptometryRecord',
    method: 'get',
    params: data
  })
}

// 更新验光记录
export const updateOptometryRecord = (data) => {
  return service({
    url: '/optometry/updateOptometryRecord',
    method: 'put',
    data
  })
}

// 查询验光数据列表
export const getOptometryDataList = (data) => {
  return service({
    url: '/optometry/getOptometryDataList',
    method: 'post',
    data
  })
}

// 查询验光数据详情
export const getOptometryData = (data) => {
  return service({
    url: '/optometry/getOptometryData',
    method: 'get',
    params: data
  })
}

// 创建验光数据
export const createOptometryData = (data) => {
  return service({
    url: '/optometry/createOptometryData',
    method: 'post',
    data
  })
}

// 更新验光数据
export const updateOptometryData = (data) => {
  return service({
    url: '/optometry/updateOptometryData',
    method: 'put',
    data
  })
}

// 删除验光数据
export const deleteOptometryData = (data) => {
  return service({
    url: '/optometry/deleteOptometryData',
    method: 'delete',
    data
  })
}

// 按类型查询（电脑验光仪/查片仪）
export const getOptometryDataByType1 = (data) => {
  return service({
    url: '/optometry/getOptometryDataByType1',
    method: 'get',
    params: data
  })
}

// 按类型查询（验光头）
export const getOptometryDataByType2 = (data) => {
  return service({
    url: '/optometry/getOptometryDataByType2',
    method: 'get',
    params: data
  })
}

// 按类型查询（最终配镜）
export const getOptometryDataByType3 = (data) => {
  return service({
    url: '/optometry/getOptometryDataByType3',
    method: 'get',
    params: data
  })
}

// 查询视图验光列表
export const getVisionTestResultList = (data) => {
  return service({
    url: '/optometry/getVisionTestResultList',
    method: 'post',
    data
  })
}

// 查询视图验光详情
export const getVisionTestResult = (data) => {
  return service({
    url: '/optometry/getVisionTestResult',
    method: 'get',
    params: data
  })
}

// 创建视图验光
export const createVisionTestResult = (data) => {
  return service({
    url: '/optometry/createVisionTestResult',
    method: 'post',
    data
  })
}

// 更新视图验光
export const updateVisionTestResult = (data) => {
  return service({
    url: '/optometry/updateVisionTestResult',
    method: 'put',
    data
  })
}

// 删除视图验光
export const deleteVisionTestResult = (data) => {
  return service({
    url: '/optometry/deleteVisionTestResult',
    method: 'delete',
    data
  })
}

// 查询视图验光+试戴（按验光记录ID）
export const getVisionTestAndTryOn = (data) => {
  return service({
    url: '/optometry/getVisionTestAndTryOn',
    method: 'get',
    params: data
  })
}

// 查询试戴验光列表
export const getTryOptometryList = (data) => {
  return service({
    url: '/optometry/getTryOptometryList',
    method: 'post',
    data
  })
}

// 查询试戴验光详情
export const getTryOptometry = (data) => {
  return service({
    url: '/optometry/getTryOptometry',
    method: 'get',
    params: data
  })
}

// 创建试戴验光
export const createTryOptometry = (data) => {
  return service({
    url: '/optometry/createTryOptometry',
    method: 'post',
    data
  })
}

// 更新试戴验光
export const updateTryOptometry = (data) => {
  return service({
    url: '/optometry/updateTryOptometry',
    method: 'put',
    data
  })
}

// 删除试戴验光
export const deleteTryOptometry = (data) => {
  return service({
    url: '/optometry/deleteTryOptometry',
    method: 'delete',
    data
  })
}
