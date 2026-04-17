import service from '@/utils/request'

// ========== 微信用户 ==========
export const getWxUserList = (data) => {
  return service({ url: '/wechat/getWxUserList', method: 'post', data })
}
export const getWxUser = (data) => {
  return service({ url: '/wechat/getWxUser', method: 'get', params: data })
}
export const updateWxUser = (data) => {
  return service({ url: '/wechat/updateWxUser', method: 'put', data })
}
export const deleteWxUser = (data) => {
  return service({ url: '/wechat/deleteWxUser', method: 'delete', data })
}

// ========== 微信消息 ==========
export const getWxMsgList = (data) => {
  return service({ url: '/wechat/getWxMsgList', method: 'post', data })
}
export const getWxMsg = (data) => {
  return service({ url: '/wechat/getWxMsg', method: 'get', params: data })
}
export const deleteWxMsg = (data) => {
  return service({ url: '/wechat/deleteWxMsg', method: 'delete', data })
}

// ========== 微信菜单 ==========
export const getWxMenuList = (data) => {
  return service({ url: '/wechat/getWxMenuList', method: 'post', data })
}
export const getWxMenu = (data) => {
  return service({ url: '/wechat/getWxMenu', method: 'get', params: data })
}
export const createWxMenu = (data) => {
  return service({ url: '/wechat/createWxMenu', method: 'post', data })
}
export const updateWxMenu = (data) => {
  return service({ url: '/wechat/updateWxMenu', method: 'put', data })
}
export const deleteWxMenu = (data) => {
  return service({ url: '/wechat/deleteWxMenu', method: 'delete', data })
}

// ========== 自动回复 ==========
export const getWxAutoReplyList = (data) => {
  return service({ url: '/wechat/getWxAutoReplyList', method: 'post', data })
}
export const getWxAutoReply = (data) => {
  return service({ url: '/wechat/getWxAutoReply', method: 'get', params: data })
}
export const createWxAutoReply = (data) => {
  return service({ url: '/wechat/createWxAutoReply', method: 'post', data })
}
export const updateWxAutoReply = (data) => {
  return service({ url: '/wechat/updateWxAutoReply', method: 'put', data })
}
export const deleteWxAutoReply = (data) => {
  return service({ url: '/wechat/deleteWxAutoReply', method: 'delete', data })
}
