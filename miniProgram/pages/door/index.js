const app = getApp()

Page({
  data: {
    config: app.globalData.config,
    doorId: 1,
    getPhoneNumberSuccess: false
  },
  onLoad(options) {
    app.initPage()
      .then(res => {
        // 获取url参数id 
        if (options.id) {
          this.setData({ doorId: options.id });
        }
        this.loadData();
      })
  },
  onShow(){

  },
  loadData(){

  },
  onShareAppMessage: function () {
    let title = ''
    let path = 'pages/door/index'
    return {
      title: title,
      path: path,
      success: function (res) {
        if (res.errMsg == 'shareAppMessage:ok') {
          console.log(res.errMsg)
        }
      },
      fail: function (res) {
        // 转发失败
      }
    }
  },
  handleOpenDoor() {
    const that = this;
    if (!app.globalData.wxUser || !app.globalData.wxUser.openId) {
      wx.showLoading({ title: '正在登录...' });
      app.doLogin()
        .then(res => {
          wx.hideLoading();
          this._checkPhoneAndOpenDoor();
        })
        .catch(err => {
          wx.hideLoading();
          wx.showToast({ title: '登录失败，无法开门', icon: 'none' });
        });
    } else {
      this._checkPhoneAndOpenDoor();
    }
  },

  _checkPhoneAndOpenDoor() {
    if(this.data.getPhoneNumberSuccess==false){
      wx.showToast({
        title: '请先点击下方按钮授权手机号',
        icon: 'none',
        duration: 2000
      });
      return
    }
    this._doOpenDoor();
  },


  // 获取手机号回调
  getPhoneNumber(e) {
    const that = this;
    if (e.detail.errMsg === 'getPhoneNumber:ok') {
      // 获取到code，调用后台接口
      const code = e.detail.code;
      wx.showLoading({ title: '验证手机号...' });
      const openId = app.globalData.wxUser && app.globalData.wxUser.openId;
      app.api.phoneInfoGet({ openid: openId, code: code })
        .then(res => {
          wx.hideLoading();
          wx.showToast({ title: '手机号验证成功', icon: 'success' });
          that.setData({
            getPhoneNumberSuccess: true
          })
          that._doOpenDoor()
        })
        .catch(err => {
          wx.hideLoading();
          wx.showToast({ title: '手机号验证失败', icon: 'none' });
        });
    } else {
      wx.showToast({ title: '获取手机号失败', icon: 'none' });
    }
  },

  _doOpenDoor() {
    const openId = app.globalData.wxUser && app.globalData.wxUser.openId;
    const id = this.data.doorId;
    if (!openId) {
      wx.showToast({ title: '未获取到openId', icon: 'none' });
      return;
    }
    app.api.openDoor( id,openId)
      .then(res => {
        wx.showToast({ title: '开门成功', icon: 'success' });
        setTimeout(() => {
          wx.switchTab({
            url: '/pages/goods/goods-category/index'
          });
        }, 3000);
      })
      .catch(err => {
        wx.showToast({ title: '开门失败', icon: 'none' });
      });
  },
})

