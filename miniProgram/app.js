import api from './utils/api'
import __config from './config/env'

App({
  api,
  globalData: {
    thirdSession: null,
    wxUser: null,
    config: __config,
    shoppingCartCount: 0
  },

  onLaunch(options) {
    // 1047 是扫“小程序码”进入
    if (options.scene === 1047) {
      const query = encodeQuery(options.query)
      wx.redirectTo({ url: `/pages/door/index${query ? '?' + query : ''}` })
    }

    // 其余初始化
    this.updateManager()
    wx.getSystemInfo({
      success: e => {
        this.globalData.StatusBar = e.statusBarHeight
        const custom = wx.getMenuButtonBoundingClientRect()
        this.globalData.Custom = custom
        this.globalData.CustomBar = custom.bottom + custom.top - e.statusBarHeight
      }
    })
  },

  updateManager() {
    const updateManager = wx.getUpdateManager()
    updateManager.onUpdateReady(() => {
      wx.showModal({
        title: '更新提示',
        content: '新版本已经准备好，是否重启应用？',
        success(res) {
          if (res.confirm) updateManager.applyUpdate()
        }
      })
    })
  },

  // 获取购物车数量
  shoppingCartCount() {
    return this.api.shoppingCartCount().then(res => {
      const count = res.data
      this.globalData.shoppingCartCount = String(count)
      wx.setTabBarBadge({ index: 1, text: String(count) })
    })
  },

  // 初始化页面
  initPage() {
    return new Promise((resolve, reject) => {
      if (this.globalData.thirdSession) {
        wx.checkSession({
          success: () => resolve('success'),
          fail: () => this.doLogin().then(() => resolve('success'))
        })
      } else {
        this.doLogin().then(() => resolve('success'))
      }
    })
  },

  // 登录
  doLogin() {
    wx.showLoading({ title: '登录中' })
    return new Promise((resolve, reject) => {
      wx.login({
        success: res => {
          if (res.code) {
            this.api.login({ code: res.code }).then(res => {
              wx.hideLoading()
              const wxUser = res.data.wxUser || res.data
              this.globalData.thirdSession = res.data.token
              this.globalData.wxUser = wxUser
              resolve('success')
              this.shoppingCartCount()
            })
          }
        }
      })
    })
  }
})

// --------- 工具：把对象转成 queryString ---------
function encodeQuery(obj) {
  if (!obj || !Object.keys(obj).length) return ''
  return Object.keys(obj)
    .map(k => `${k}=${encodeURIComponent(obj[k])}`)
    .join('&')
}