
// 使用 CommonJS 引入方式，兼容小程序原生环境
const __config = require('../config/env')

const request = (url, method, data, showLoading) => {
  let _url = __config.basePath + url
  return new Promise((resolve, reject) => {
    if (showLoading){
      wx.showLoading({
        title: '加载中',
      })
    }
    wx.request({
      url: _url,
      method: method,
      data: data,
      header: {
        'app-id': wx.getAccountInfoSync().miniProgram.appId,
        'Authorization': getApp().globalData.thirdSession ? 'Bearer ' + getApp().globalData.thirdSession : '',
        'Content-Type': 'application/json'
      },
      success(res) {
        if (res.statusCode == 200) {
          if (res.data.code != 0) {
            console.log(res.data)
            wx.showModal({
              title: '提示',
              content: res.data.msg ? res.data.msg : '没有数据' + '',
              success() {
                
              },
              complete(){
                if(res.data.code == 401){
                  //session过期，则清除过期session，并重新加载当前页
                  getApp().globalData.thirdSession = null
                  wx.reLaunch({
                    url: getApp().getCurrentPageUrlWithArgs()
                  })
                }
              }
            })
            reject(res.data.msg)
          }
          resolve(res.data)
        } else if (res.statusCode == 404) {
          wx.showModal({
            title: '提示',
            content: '接口请求出错，请检查手机网络',
            success(res) {

            }
          })
          reject()
        } else {
          console.log(res)
          wx.showModal({
            title: '提示',
            content: res.errMsg + ':' + res.data.message + ':' + res.data.msg,
            success(res) {

            }
          })
          reject()
        }
      },
      fail(error) {
        console.log(error)
        wx.showModal({
          title: '提示',
          content: '接口请求出错：' + error.errMsg,
          success(res) {

          }
        })
        reject(error)
      },
      complete(res) {
        wx.hideLoading()
      }
    })
  })
}

module.exports = {
  request,
  login: (data) => {//小程序登录接口
    return request('/mini/login', 'post', data, false)
  },
  wxUserGet: (data) => {//微信用户查询
    return request('/mini/wxuser', 'get', null, false)
  },
  wxUserSave: (data) => {//微信用户新增
    return request('/mini/wxuser', 'post', data, true)
  },
  goodsCategoryGet: (data) => {//商品分类查询
    return request('/mini/goodscategory/tree' , 'get', data, true)
  },
  goodsPage: (data) => {//商品列表
    return request('/mini/goodsspu/page', 'get', data, false)
  },
  goodsGet: (id) => {//商品查询
    return request('/mini/goodsspu/id?id=' + id+'&whereType=0', 'get', null, false)
  },
  shoppingCartPage: (data) => {//购物车列表
    return request('/mini/shoppingcart/page', 'get', data, false)
  },
  shoppingCartAdd: (data) => {//购物车新增
    return request('/mini/shoppingcart', 'post', data, true)
  },
  shoppingCartEdit: (data) => {//购物车修改
    return request('/mini/shoppingcart', 'put', data, true)
  },
  shoppingCartDel: (data) => {//购物车删除
    return request('/mini/shoppingcart/del', 'post', data, false)
  },
  shoppingCartCount: (data) => {//购物车数量
    return request('/mini/shoppingcart/count', 'get', data, false)
  },
  orderSub: (data) => {//订单提交
    return request('/mini/orderinfo', 'post', data, true)
  },
  orderPage: (data) => {//订单列表
    return request('/mini/orderinfo/page', 'get', data, false)
  },
  orderGet: (id) => {//订单详情查询
    return request('/mini/orderinfo/' + id, 'get', null, false)
  },
  orderCancel: (id) => {//订单确认取消
    return request('/mini/orderinfo/cancel/' + id, 'put', null, true)
  },
  orderRefunds: (data) => {//订单申请退款
    return request('/mini/orderinfo/refunds', 'post', data, true)
  },
  orderReceive: (id) => {//订单确认收货
    return request('/mini/orderinfo/receive/' + id, 'put', null, true)
  },
  orderDel: (id) => {//订单删除
    return request('/mini/orderinfo/' + id, 'delete', null, false)
  },
  orderCountAll: (data) => {//订单计数
    return request('/mini/orderinfo/countAll', 'get', data, false)
  },
  unifiedOrder: (data) => {//下单接口
    return request('/mini/orderinfo/unifiedOrder', 'post', data, true)
  },
  userAddressPage: (data) => {//用户收货地址列表
    return request('/mini/useraddress/page', 'get', data, false)
  },
  userAddressSave: (data) => {//用户收货地址新增
    return request('/mini/useraddress', 'post', data, true)
  },
  userAddressDel: (id) => {//用户收货地址删除
    return request('/mini/useraddress/' + id, 'delete', null, false)
  },
  openDoor: (id,openId) => {
    return request('/mini/remote/door/open', 'post', { doorId: id, openId: openId }, true)
  },
  // 远程控制接口
  remoteControl: (data) => {//远程控制设备
    return request('/mini/remote/control', 'post', data, true)
  },
  getOnlineUsers: () => {//获取在线用户
    return request('/mini/remote/online-users', 'get', null, false)
  },
  // 远程验光接口
  getRemoteToken: (data) => {//获取远程验光token
    return request('/mini/remote/token', 'post', data, true)
  },
  getRemoteWsUrl: () => {//获取远程验光WebSocket地址
    return request('/mini/remote/ws-url', 'get', null, false)
  },
  getSessionInfo: () => {//获取会话信息
    return request('/mini/remote/session-info', 'get', null, false)
  },
  getRemoteHealth: () => {//获取远程验光健康状态
    return request('/mini/remote/health', 'get', null, false)
  },
  getRemoteStats: () => {//获取远程验光统计
    return request('/mini/remote/stats', 'get', null, false)
  },
  // 音视频接口
  getAgoraToken: (data) => {//获取声网Token
    return request('/mini/agora/token', 'post', data, true)
  },
  agoraJoin: (data) => {//加入房间
    return request('/mini/agora/join', 'post', data, true)
  },
  agoraLeave: (data) => {//离开房间
    return request('/mini/agora/leave', 'post', data, true)
  },
  getAgoraRoom: () => {//获取房间信息
    return request('/mini/agora/room', 'get', null, false)
  },
  getAgoraRooms: () => {//获取房间列表
    return request('/mini/agora/rooms', 'get', null, false)
  },
  phoneInfoGet: (data) => {//手机号获取接口
    return request('/mini/phone', 'get', data, true)
  },
  // 验光模块接口
  optometryListByOpenid: (openid) => {
    return request('/mini/optometry/list', 'get', { openid }, false)
  },
  optometryDetail: (optometryRecordsId) => {
    return request(`/mini/optometry/${optometryRecordsId}`, 'get', null, false)
  },
  optometryDataListById: (optometryRecordsId) => {
    return request('/mini/optometry/data/list', 'get', { optometryRecordsId }, false)
  },
  optometryHeadByIdT2: (optometryRecordsId) => {
    return request('/mini/optometry/data/t2', 'get', { optometryRecordsId }, false)
  },
  optometryFinalByIdT3: (optometryRecordsId) => {
    return request('/mini/optometry/data/t3', 'get', { optometryRecordsId }, false)
  },
  optometryByOptometryRecordsId: (optometryRecordsId) => {
    return request('/mini/optometry/vision', 'get', { optometryRecordsId }, false)
  }
}