const app = getApp()

Page({
  data: {
    config: app.globalData.config,
    optometryRecordsId: '',
    loading: false,
    header: null,
    aiData: '',
    listById: [],
    // 原始表行用于近/远切换
    headT2: [],
    finalT3: [],
    headT2Far: [],
    headT2Near: [],
    finalT3Far: [],
    finalT3Near: [],
    sheetTwo: null,
    // 近/远用切换，默认远用
    useType: 'far',
    // 视力检查结果项（根据后台表单动态生成）
    visionResultItems: [],
    sheetUseType: 'far',
    visionResultFar: [],
    visionResultNear: [],
    visionResultNeutral: [],
    showSheetTwo: false,
    tryOptometryR: null,
    tryOptometryL: null,
    showTryHistory: false
  },
  toggleSheetTwo() {
    this.setData({ showSheetTwo: !this.data.showSheetTwo })
  },
  onLoad(options) {
    const id = options.optometryRecordsId
    if (!id) {
      wx.showToast({ title: '缺少记录ID', icon: 'none' })
      return
    }
    this.setData({ optometryRecordsId: id })
    this.fetchAll(id)
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
  formatOptometryRows(rows = []) {
    return (rows || []).map(item => {
      if (!item) {
        return item
      }
      const prop = item.prop
      const clone = { ...item }
      const keys = ['dataRt1', 'dataRt2', 'dataLt1', 'dataLt2', 'dataRf', 'dataRn', 'dataLf', 'dataLn']
      if (prop === 'sphericalMirror' || prop === 'cylindricalMirror') {
        keys.forEach(k => {
          if (clone[k] !== undefined) {
            clone[k] = this.formatSCValue(clone[k])
          }
        })
      } else if (prop === 'positionOfAxis') {
        keys.forEach(k => {
          if (clone[k] !== undefined) {
            clone[k] = this.formatAValue(clone[k])
          }
        })
      }
      return clone
    })
  },
  formatTryOptometryList(list = []) {
    return (list || []).map(item => {
      if (!item) {
        return item
      }
      const clone = { ...item }
      clone.sphericalMirror = this.formatSCValue(clone.sphericalMirror)
      clone.cylindricalMirror = this.formatSCValue(clone.cylindricalMirror)
      clone.positionOfAxis = this.formatAValue(clone.positionOfAxis)
      return clone
    })
  },
  fetchAll(id) {
    this.setData({ loading: true })
    const p1 = app.api.optometryDetail(id)
    const p2 = app.api.optometryDataListById(id)
    const p3 = app.api.optometryHeadByIdT2(id)
    const p4 = app.api.optometryFinalByIdT3(id)
    const p5 = app.api.optometryByOptometryRecordsId(id)
    Promise.all([p1, p2, p3, p4, p5])
      .then(([r1, r2, r3, r4, r5]) => {
        const listRowsRaw = (r2 && r2.rows) || []
        const headRowsRaw = (r3 && r3.rows) || []
        const finalRowsRaw = (r4 && r4.rows) || []
        const listRows = this.formatOptometryRows(listRowsRaw)
        const headRows = this.formatOptometryRows(headRowsRaw)
        const finalRows = this.formatOptometryRows(finalRowsRaw)
        const { far: headFar, near: headNear } = this.bucketNearFar(headRows)
        const { far: finalFar, near: finalNear } = this.bucketNearFar(finalRows)
        const sheetTwoRaw = (r5 && r5.data) || null
        const tryListRaw = (sheetTwoRaw && sheetTwoRaw.tryOptometryList) || []
        const tryOptometryList = this.formatTryOptometryList(tryListRaw)
        const vr = (sheetTwoRaw && sheetTwoRaw.visionTestResults) || {}
        const { items: visionResultItems, far: visionResultFar, near: visionResultNear, neutral: visionResultNeutral } = this.buildVisionResultItems(vr)
        const tlist = tryOptometryList
        const tryOptometryR = tlist.find(i => i && i.leftRightEyes === 1) || null
        const tryOptometryL = tlist.find(i => i && i.leftRightEyes !== 1) || null
        const detail = r1 && r1.data ? r1.data : null
        const aiData = detail && detail.aiData ? detail.aiData : ''
        this.setData({
          header: detail,
          aiData,
          listById: listRows,
          headT2: headRows,
          finalT3: finalRows,
          headT2Far: headFar,
          headT2Near: headNear,
          finalT3Far: finalFar,
          finalT3Near: finalNear,
          sheetTwo: sheetTwoRaw ? { ...sheetTwoRaw, tryOptometryList } : null,
          visionResultItems,
          visionResultFar,
          visionResultNear,
          visionResultNeutral,
          tryOptometryR,
          tryOptometryL
        })
      })
      .catch(err => {
        console.error('optometry fetch error', err)
        wx.showToast({ title: '数据加载失败', icon: 'none' })
      })
      .finally(() => this.setData({ loading: false }))
  }
  ,
  // 将接口返回的数据按远用/近用进行分组
  bucketNearFar(rows = []) {
    const far = []
    const near = []
    rows.forEach(item => {
      const flag = (item.useType || item.use || item.typeName || item.scene || '').toString()
      const isNear = /近|near/i.test(flag)
      const isFar = /远|far|distance/i.test(flag)
      if (isNear && !isFar) {
        near.push(item)
      } else if (isFar && !isNear) {
        far.push(item)
      } else {
        // 无法判断时默认归入远用，避免遗漏
        far.push(item)
      }
    })
    return { far, near }
  },
  // 根据后台表单构建视力检查结果展示项（分组：远/近/通用），并附加参考值
  buildVisionResultItems(vr = {}) {
    const items = []
    const far = []
    const near = []
    const neutral = []
    // 参考值映射（依据后端表单示例）
    const refMap = {
      ww4points: '4',
      stereoView: '上单下单',
      aca: '1△±1△ : X',
      nra: '1△±1△ : X',
      bcc: '1△±1△ : X',
      pra: '1△±1△ : X',
      // 隐斜
      vgfBi: '1△±1△ : X',
      vgfBu: 'X: 7±3 : 4±2',
      vgnBi: '1△±1△ : X',
      vgnBu: 'X: 7±3 : 4±2',
      // 正负融像 远用 BI/BU 1-3
      pnifBi1: '1△±1△ : X',
      pnifBi2: '1△±1△ : X',
      pnifBi3: '1△±1△ : X',
      pnifBu1: 'X: 7±3 : 4±2',
      pnifBu2: 'X: 7±3 : 4±2',
      pnifBu3: 'X: 7±3 : 4±2',
      // 正负融像 近用 BI/BU 1-3
      pninBi1: '1△±1△ : X',
      pninBi2: '1△±1△ : X',
      pninBi3: '1△±1△ : X',
      pninBu1: 'X: 7±3 : 4±2',
      pninBu2: 'X: 7±3 : 4±2',
      pninBu3: 'X: 7±3 : 4±2'
      // 视力与诊断类通常无统一参考值，保持为空
    }
    const pushIfHas = (key, label, group = 'neutral') => {
      const v = vr[key]
      if (v !== undefined && v !== null && v !== '') {
        const obj = { label, value: v, ref: refMap[key] || '' }
        items.push(obj)
        if (group === 'far') far.push(obj)
        else if (group === 'near') near.push(obj)
        else neutral.push(obj)
      }
    }
    // 基础项（不区分近远）
    pushIfHas('ww4points', '沃氏4点')
    pushIfHas('stereoView', '立体观')
    pushIfHas('aca', '梯度法')
    pushIfHas('nra', '负相对调节NRA')
    pushIfHas('bcc', '调节反应BCC')
    pushIfHas('pra', '正相对调节PRA')
    pushIfHas('reverseBeat', '反转拍')
    pushIfHas('visualChart', '视力表')
    // 隐斜（远/近，BI/BU）
    pushIfHas('vgfBi', '隐斜(远用 BI)', 'far')
    pushIfHas('vgfBu', '隐斜(远用 BU)', 'far')
    pushIfHas('vgnBi', '隐斜(近用 BI)', 'near')
    pushIfHas('vgnBu', '隐斜(近用 BU)', 'near')
    // 正负融像（远用 BI/BU 1-3）
    pushIfHas('pnifBi1', '正负融像(远用 BI-1)', 'far')
    pushIfHas('pnifBi2', '正负融像(远用 BI-2)', 'far')
    pushIfHas('pnifBi3', '正负融像(远用 BI-3)', 'far')
    pushIfHas('pnifBu1', '正负融像(远用 BU-1)', 'far')
    pushIfHas('pnifBu2', '正负融像(远用 BU-2)', 'far')
    pushIfHas('pnifBu3', '正负融像(远用 BU-3)', 'far')
    // 正负融像（近用 BI/BU 1-3）
    pushIfHas('pninBi1', '正负融像(近用 BI-1)', 'near')
    pushIfHas('pninBi2', '正负融像(近用 BI-2)', 'near')
    pushIfHas('pninBi3', '正负融像(近用 BI-3)', 'near')
    pushIfHas('pninBu1', '正负融像(近用 BU-1)', 'near')
    pushIfHas('pninBu2', '正负融像(近用 BU-2)', 'near')
    pushIfHas('pninBu3', '正负融像(近用 BU-3)', 'near')
    // 视力（不区分近远）
    pushIfHas('binoculus', '双眼')
    pushIfHas('leftEye', '左眼')
    pushIfHas('rightEye', '右眼')
    // 兼容另一套字段命名（用于视力值显示）
    pushIfHas('binocularVision', '双眼视力')
    pushIfHas('leftEyeVision', '左眼视力')
    pushIfHas('rightEyeVision', '右眼视力')
    // 诊断与备注（不区分近远）
    pushIfHas('diagnosisName', '诊断名称')
    pushIfHas('diagnosisAbnormal', '诊断异常名称')
    pushIfHas('rests', '其他')
    pushIfHas('sugggestions', '建议方案')
    return { items, far, near, neutral }
  },
  // 切换近/远用展示
  switchUseType(e) {
    const type = e.currentTarget.dataset.type
    if (type === 'far' || type === 'near') {
      this.setData({ useType: type })
    }
  },
  // 切换验光单二近/远用展示
  switchSheetUseType(e) {
    const type = e.currentTarget.dataset.type
    if (type === 'far' || type === 'near') {
      this.setData({ sheetUseType: type })
    }
  },
  // 展开/收起试戴验光历史记录
  toggleTryHistory() {
    this.setData({ showTryHistory: !this.data.showTryHistory })
  }
})
