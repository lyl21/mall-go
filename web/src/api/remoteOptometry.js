import service from '@/utils/request'

// 获取远程验光实时状态列表
export const getRemoteOptometryStatusList = (params) => {
  return service({
    url: '/store/remoteOptometry/statusList',
    method: 'get',
    params
  })
}

// 获取远程验光日志列表
export const getRemoteOptometryLogList = (params) => {
  return service({
    url: '/store/remoteOptometry/logList',
    method: 'get',
    params
  })
}

// 获取远程验光会话详情
export const getRemoteOptometryDetail = (params) => {
  return service({
    url: '/store/remoteOptometry/detail',
    method: 'get',
    params
  })
}

// 获取牛头设备状态
export const getNiuTouDeviceStatus = (params) => {
  return service({
    url: '/store/remoteOptometry/deviceStatus',
    method: 'get',
    params
  })
}

// 获取牛头设备列表（带远控状态）
export const getNiuTouDeviceList = (params) => {
  return service({
    url: '/store/remoteOptometry/deviceList',
    method: 'get',
    params
  })
}
