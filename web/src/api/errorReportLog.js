import service from '@/utils/request'

// 查询验光仪错误报告日志列表
export const getErrorReportLogList = (params) => {
  return service({
    url: '/optometry/errorReportLogList',
    method: 'get',
    params
  })
}

// 查询验光仪错误报告日志详情
export const getErrorReportLog = (params) => {
  return service({
    url: '/optometry/errorReportLog',
    method: 'get',
    params
  })
}

// 删除验光仪错误报告日志
export const deleteErrorReportLog = (data) => {
  return service({
    url: '/optometry/errorReportLog',
    method: 'delete',
    data
  })
}

// 批量删除验光仪错误报告日志
export const deleteErrorReportLogByIds = (data) => {
  return service({
    url: '/optometry/errorReportLogBatch',
    method: 'delete',
    data
  })
}
