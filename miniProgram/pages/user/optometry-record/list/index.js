const app = getApp()

Page({
  data: {
    config: app.globalData.config,
    list: [],
    loading: false,
    openid: '',
    tab: 'list',
    trendLoading: false,
    trendReady: false,
    activeIndex: -1,
    activeLabel: '',
    scaLabels: [],
    scaSRight: [],
    scaSLeft: [],
    scaCRight: [],
    scaCLeft: [],
    scaARight: [],
    scaALeft: [],
    scaSRightText: [],
    scaSLeftText: [],
    scaCRightText: [],
    scaCLeftText: [],
    scaARightText: [],
    scaALeftText: []
  },
  onLoad(options) {
    const openidFromOptions = options.openid || ''
    const wxUser = app.globalData.wxUser || {}
    const openidFromUser = wxUser.openId || wxUser.openid || ''
    const openid = openidFromOptions || openidFromUser
    this.setData({ openid })
    if (!openid) {
      wx.showToast({ title: '缺少 openid', icon: 'none' })
      return
    }
    this.fetchList(openid)
  },
  fetchList(openid) {
    this.setData({ loading: true })
    app.api.optometryListByOpenid(openid)
      .then(res => {
        const rows = res.rows || []
        this.setData({
          list: rows,
          trendReady: false
        })
        if (this.data.tab === 'trend') {
          this.prepareTrend()
        }
      })
      .finally(() => this.setData({ loading: false }))
  },
  switchTab(e) {
    const tab = e.currentTarget.dataset.tab
    if (!tab || tab === this.data.tab) {
      return
    }
    this.setData({ tab })
    if (tab === 'trend') {
      this.prepareTrend()
    }
  },
  formatSCValue(v) {
    if (v === null || v === undefined || v === '') {
      return ''
    }
    const n = Number(v)
    if (Number.isNaN(n)) {
      return ''
    }
    return n.toFixed(2)
  },
  formatAValue(v) {
    if (v === null || v === undefined || v === '') {
      return ''
    }
    const n = Number(v)
    if (Number.isNaN(n)) {
      return ''
    }
    return String(Math.round(n))
  },
  formatValueByType(type, v) {
    if (v === null || v === undefined || v === '') {
      return ''
    }
    if (type === 'a') {
      return this.formatAValue(v)
    }
    return this.formatSCValue(v)
  },
  prepareTrend() {
    const list = this.data.list || []
    if (!list.length) {
      return
    }
    if (this.data.trendReady) {
      this.drawAllCharts(this.data.activeIndex)
      return
    }
    this.loadTrendData()
  },
  loadTrendData() {
    const list = this.data.list || []
    if (!list.length) {
      return
    }
    this.setData({ trendLoading: true })
    const tasks = list.map(item => {
      const id = item && (item.optometryRecordsId || item.id)
      if (!id) {
        return Promise.resolve(null)
      }
      return app.api.optometryHeadByIdT2(id).catch(() => null)
    })
    Promise.all(tasks)
      .then(results => {
        const labels = []
        const sRight = []
        const sLeft = []
        const cRight = []
        const cLeft = []
        const aRight = []
        const aLeft = []
        const sRightText = []
        const sLeftText = []
        const cRightText = []
        const cLeftText = []
        const aRightText = []
        const aLeftText = []
        const getNumber = v => {
          if (v === null || v === undefined || v === '') {
            return null
          }
          const n = Number(v)
          return Number.isNaN(n) ? null : n
        }
        const getVal = (rows, prop) => {
          if (!rows || !rows.length) {
            return { r: null, l: null }
          }
          const row = rows.find(r => r && r.prop === prop)
          if (!row) {
            return { r: null, l: null }
          }
          const rFar = getNumber(row.dataRf)
          const rNear = getNumber(row.dataRn)
          const lFar = getNumber(row.dataLf)
          const lNear = getNumber(row.dataLn)
          return {
            r: rFar !== null ? rFar : rNear,
            l: lFar !== null ? lFar : lNear
          }
        }
        list.forEach((item, idx) => {
          const t = item && item.createTime ? this.formatDateShort(item.createTime) : ''
          labels.push(t)
          const res = results[idx]
          const rows = res && res.rows ? res.rows : []
          const s = getVal(rows, 'sphericalMirror')
          const c = getVal(rows, 'cylindricalMirror')
          const a = getVal(rows, 'positionOfAxis')
          sRight.push(s.r)
          sLeft.push(s.l)
          cRight.push(c.r)
          cLeft.push(c.l)
          aRight.push(a.r)
          aLeft.push(a.l)
          sRightText.push(this.formatSCValue(s.r))
          sLeftText.push(this.formatSCValue(s.l))
          cRightText.push(this.formatSCValue(c.r))
          cLeftText.push(this.formatSCValue(c.l))
          aRightText.push(this.formatAValue(a.r))
          aLeftText.push(this.formatAValue(a.l))
        })
        this.setData({
          scaLabels: labels,
          scaSRight: sRight,
          scaSLeft: sLeft,
          scaCRight: cRight,
          scaCLeft: cLeft,
          scaARight: aRight,
          scaALeft: aLeft,
          scaSRightText: sRightText,
          scaSLeftText: sLeftText,
          scaCRightText: cRightText,
          scaCLeftText: cLeftText,
          scaARightText: aRightText,
          scaALeftText: aLeftText,
          trendReady: true
        })
        this.drawAllCharts(this.data.activeIndex)
      })
      .finally(() => {
        this.setData({ trendLoading: false })
      })
  },
  formatDateShort(str) {
    if (!str || typeof str !== 'string') {
      return ''
    }
    const y = str.slice(2, 4)
    const m = str.slice(5, 7)
    const d = str.slice(8, 10)
    return `${y}/${m}/${d}`
  },
  drawAllCharts(activeIndex) {
    const labels = this.data.scaLabels || []
    if (!labels.length) {
      return
    }
    this.drawLineChart('sChart', labels, this.data.scaSRight, this.data.scaSLeft, activeIndex, 'sc', 'S')
    this.drawLineChart('cChart', labels, this.data.scaCRight, this.data.scaCLeft, activeIndex, 'sc', 'C')
    this.drawLineChart('aChart', labels, this.data.scaARight, this.data.scaALeft, activeIndex, 'a', 'A')
  },
  drawLineChart(canvasId, labels, rightData, leftData, activeIndex, valueType, axisType) {
    const ctx = wx.createCanvasContext(canvasId, this)
    const width = 320
    const height = 180
    const padLeft = 36
    const padRight = 12
    const padTop = 16
    const padBottom = 34
    const values = []
    ;[rightData || [], leftData || []].forEach(arr => {
      arr.forEach(v => {
        if (typeof v === 'number' && !Number.isNaN(v)) {
          values.push(v)
        }
      })
    })
    ctx.clearRect(0, 0, width, height)
    if (!values.length) {
      ctx.setFillStyle('#999')
      ctx.setFontSize(12)
      ctx.fillText('暂无数据', padLeft, height / 2)
      ctx.draw()
      return
    }
    let min
    let max
    let axisMode = 'asc'
    let sHasPos = false
    let sHasNeg = false
    if (axisType === 'S') {
      const minVal = Math.min.apply(null, values)
      const maxVal = Math.max.apply(null, values)
      sHasPos = maxVal > 0
      sHasNeg = minVal < 0
      if (!sHasPos && sHasNeg) {
        min = minVal
        max = 0
        axisMode = 'desc'
      } else if (sHasPos && !sHasNeg) {
        min = 0
        max = maxVal
        axisMode = 'asc'
      } else if (sHasPos && sHasNeg) {
        min = minVal
        max = maxVal
        axisMode = 'desc'
      } else {
        min = 0
        max = 1
        axisMode = 'asc'
      }
    } else if (axisType === 'C') {
      const minVal = Math.min.apply(null, values)
      if (minVal === 0) {
        min = -1
        max = 0
      } else {
        min = minVal
        max = 0
      }
      axisMode = 'desc'
    } else if (axisType === 'A') {
      min = 0
      max = 180
    } else {
      min = Math.min.apply(null, values)
      max = Math.max.apply(null, values)
      if (max === min) {
        max += 1
        min -= 1
      }
    }
    if (max === min) {
      max += 1
      min -= 1
    }
    const plotWidth = width - padLeft - padRight
    const plotHeight = height - padTop - padBottom
    const count = labels.length
    const stepX = count > 1 ? plotWidth / (count - 1) : 0
    ctx.setStrokeStyle('#e5e5e5')
    ctx.setLineWidth(1)
    ctx.beginPath()
    ctx.moveTo(padLeft, height - padBottom)
    ctx.lineTo(width - padRight, height - padBottom)
    ctx.stroke()
    ctx.beginPath()
    ctx.moveTo(padLeft, padTop)
    ctx.lineTo(padLeft, height - padBottom)
    ctx.stroke()
    const gridLines = 3
    for (let i = 1; i <= gridLines; i += 1) {
      const y = padTop + (plotHeight * i) / (gridLines + 1)
      ctx.setStrokeStyle('#f0f0f0')
      ctx.setLineWidth(1)
      ctx.beginPath()
      ctx.moveTo(padLeft, y)
      ctx.lineTo(width - padRight, y)
      ctx.stroke()
    }
    if (axisType === 'S' && sHasPos && sHasNeg && max !== min) {
      const y0 = (v => {
        let vv = v
        if (vv < min) vv = min
        if (vv > max) vv = max
        let ratio
        if (axisMode === 'desc') {
          ratio = (max - vv) / (max - min)
        } else {
          ratio = (vv - min) / (max - min)
        }
        return height - padBottom - ratio * plotHeight
      })(0)
      ctx.setStrokeStyle('#ff4d4f')
      ctx.setLineWidth(1)
      ctx.beginPath()
      ctx.moveTo(padLeft, y0)
      ctx.lineTo(width - padRight, y0)
      ctx.stroke()
    }
    ctx.setFillStyle('#999')
    ctx.setFontSize(10)
    if (axisMode === 'desc') {
      ctx.fillText(String(min), 2, padTop + 4)
      ctx.fillText(String(max), 2, height - padBottom)
    } else {
      ctx.fillText(String(max), 2, padTop + 4)
      ctx.fillText(String(min), 2, height - padBottom)
    }
    if (count >= 1) {
      ctx.fillText(labels[0] || '', padLeft, height - 10)
      if (count > 1) {
        const lastX = padLeft + stepX * (count - 1)
        ctx.fillText(labels[count - 1] || '', lastX - 24, height - 10)
      }
    }
    const valToY = v => {
      let vv = v
      if (vv < min) vv = min
      if (vv > max) vv = max
      let ratio
      if (axisMode === 'desc') {
        ratio = (max - vv) / (max - min)
      } else {
        ratio = (vv - min) / (max - min)
      }
      return height - padBottom - ratio * plotHeight
    }
    const valToX = i => padLeft + stepX * i
    const drawPoints = (data, color) => {
      const arr = data || []
      ctx.setFillStyle(color)
      arr.forEach((v, i) => {
        if (typeof v !== 'number' || Number.isNaN(v)) {
          return
        }
        const x = valToX(i)
        const y = valToY(v)
        ctx.beginPath()
        ctx.arc(x, y, 2, 0, 2 * Math.PI)
        ctx.fill()
      })
    }
    drawPoints(rightData, '#1989fa')
    drawPoints(leftData, '#ff9900')
    const hi = typeof activeIndex === 'number' ? activeIndex : -1
    if (hi >= 0 && hi < labels.length) {
      ctx.setStrokeStyle('#dddddd')
      ctx.setLineWidth(1)
      const x = valToX(hi)
      ctx.beginPath()
      ctx.moveTo(x, padTop)
      ctx.lineTo(x, height - padBottom)
      ctx.stroke()
      const rv = typeof rightData[hi] === 'number' && !Number.isNaN(rightData[hi]) ? rightData[hi] : null
      const lv = typeof leftData[hi] === 'number' && !Number.isNaN(leftData[hi]) ? leftData[hi] : null
      ctx.setFontSize(10)
      if (rv !== null) {
        const ry = valToY(rv)
        ctx.setFillStyle('#1989fa')
        ctx.fillText(this.formatValueByType(valueType, rv), x + 4, ry - 4)
      }
      if (lv !== null) {
        const ly = valToY(lv)
        ctx.setFillStyle('#ff9900')
        ctx.fillText(this.formatValueByType(valueType, lv), x + 4, ly + 10)
      }
    }
    ctx.draw()
  },
  updateChartActiveIndexByTouch(e) {
    const labels = this.data.scaLabels || []
    const count = labels.length
    if (!count) {
      return
    }
    const t = e.touches && e.touches[0]
    if (!t) {
      return
    }
    const width = 320
    const padLeft = 36
    const padRight = 12
    const plotWidth = width - padLeft - padRight
    const stepX = count > 1 ? plotWidth / (count - 1) : 0
    if (!stepX) {
      return
    }
    const x = t.x
    let idx = Math.round((x - padLeft) / stepX)
    if (idx < 0) idx = 0
    if (idx > count - 1) idx = count - 1
    if (idx === this.data.activeIndex) {
      return
    }
    this.setData({
      activeIndex: idx,
      activeLabel: labels[idx] || ''
    })
    this.drawAllCharts(idx)
  },
  onChartTouchStart(e) {
    this._chartTouching = true
    this.updateChartActiveIndexByTouch(e)
  },
  onChartTouchMove(e) {
    if (!this._chartTouching) {
      return
    }
    this.updateChartActiveIndexByTouch(e)
  },
  onChartTouchEnd() {
    this._chartTouching = false
  },
  toDetail(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/user/optometry-record/detail/index?optometryRecordsId=${id}`
    })
  }
})
