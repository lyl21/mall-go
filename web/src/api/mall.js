import service from '@/utils/request'

// ========== 商品分类 ==========
export const getGoodsCategoryList = (data) => {
  return service({
    // url: '/mall/getGoodsCategoryList', method: 'post', data
    url: '/mall/goodsCategoryList',
    method: 'get',
    params: data
  })
}
export const getGoodsCategory = (data) => {
  return service({
    // url: '/mall/getGoodsCategory', method: 'get', params: data
    url: '/mall/goodsCategory',
    method: 'get',
    params: data
  })
}
export const createGoodsCategory = (data) => {
  return service({
    // url: '/mall/createGoodsCategory', method: 'post', data
    url: '/mall/goodsCategory',
    method: 'post',
    data
  })
}
export const updateGoodsCategory = (data) => {
  return service({
    // url: '/mall/updateGoodsCategory', method: 'put', data
    url: '/mall/goodsCategory',
    method: 'put',
    data
  })
}
export const deleteGoodsCategory = (data) => {
  return service({
    // url: '/mall/deleteGoodsCategory', method: 'delete', data
    url: '/mall/goodsCategory',
    method: 'delete',
    data
  })
}

// ========== 商品SPU ==========
export const getGoodsSpuList = (data) => {
  return service({
    // url: '/mall/getGoodsSpuList', method: 'post', data
    url: '/mall/goodsSpuList',
    method: 'get',
    params: data
  })
}
export const getGoodsSpu = (data) => {
  return service({
    // url: '/mall/getGoodsSpu', method: 'get', params: data
    url: '/mall/goodsSpu',
    method: 'get',
    params: data
  })
}
export const createGoodsSpu = (data) => {
  return service({
    // url: '/mall/createGoodsSpu', method: 'post', data
    url: '/mall/goodsSpu',
    method: 'post',
    data
  })
}
export const updateGoodsSpu = (data) => {
  return service({
    // url: '/mall/updateGoodsSpu', method: 'put', data
    url: '/mall/goodsSpu',
    method: 'put',
    data
  })
}
export const deleteGoodsSpu = (data) => {
  return service({
    // url: '/mall/deleteGoodsSpu', method: 'delete', data
    url: '/mall/goodsSpu',
    method: 'delete',
    data
  })
}

// ========== 商品轮播图 ==========
export const getGoodsSpuBannerList = (data) => {
  return service({
    // url: '/mall/getGoodsSpuBannerList', method: 'post', data
    url: '/mall/goodsSpuBannerList',
    method: 'get',
    params: data
  })
}
export const createGoodsSpuBanner = (data) => {
  return service({
    // url: '/mall/createGoodsSpuBanner', method: 'post', data
    url: '/mall/goodsSpuBanner',
    method: 'post',
    data
  })
}
export const updateGoodsSpuBanner = (data) => {
  return service({
    url: '/mall/goodsSpuBanner',
    method: 'put',
    data
  })
}
export const deleteGoodsSpuBanner = (data) => {
  return service({
    // url: '/mall/deleteGoodsSpuBanner', method: 'delete', data
    url: '/mall/goodsSpuBanner',
    method: 'delete',
    data
  })
}

// ========== SPU试戴图片 ==========
export const getSpuTryOnImgList = (data) => {
  return service({
    // url: '/mall/getSpuTryOnImgList', method: 'post', data
    url: '/mall/spuTryOnImgUrlList',
    method: 'get',
    params: data
  })
}
export const createSpuTryOnImg = (data) => {
  return service({
    // url: '/mall/createSpuTryOnImg', method: 'post', data
    url: '/mall/spuTryOnImgUrl',
    method: 'post',
    data
  })
}
export const updateSpuTryOnImg = (data) => {
  return service({
    url: '/mall/spuTryOnImgUrl',
    method: 'put',
    data
  })
}
export const deleteSpuTryOnImg = (data) => {
  return service({
    // url: '/mall/deleteSpuTryOnImg', method: 'delete', data
    url: '/mall/spuTryOnImgUrl',
    method: 'delete',
    data
  })
}

// ========== 试戴眼镜图片 ==========
export const getTryOnGlassImgList = (data) => {
  return service({
    // url: '/mall/getTryOnGlassImgList', method: 'post', data
    url: '/mall/tryOnGlassImgUrlList',
    method: 'get',
    params: data
  })
}
export const createTryOnGlassImg = (data) => {
  return service({
    url: '/mall/tryOnGlassImgUrl',
    method: 'post',
    data
  })
}
export const updateTryOnGlassImg = (data) => {
  return service({
    url: '/mall/tryOnGlassImgUrl',
    method: 'put',
    data
  })
}
export const deleteTryOnGlassImg = (data) => {
  return service({
    // url: '/mall/deleteTryOnGlassImg', method: 'delete', data
    url: '/mall/tryOnGlassImgUrl',
    method: 'delete',
    data
  })
}

// ========== 订单 ==========
export const getOrderInfoList = (data) => {
  return service({
    // url: '/mall/getOrderInfoList', method: 'post', data
    url: '/mall/orderInfoList',
    method: 'get',
    params: data
  })
}
export const getOrderInfo = (data) => {
  return service({
    // url: '/mall/getOrderInfo', method: 'get', params: data
    url: '/mall/orderInfo',
    method: 'get',
    params: data
  })
}
export const createOrderInfo = (data) => {
  return service({
    url: '/mall/orderInfo',
    method: 'post',
    data
  })
}
export const updateOrderInfo = (data) => {
  return service({
    // url: '/mall/updateOrderInfo', method: 'put', data
    url: '/mall/orderInfo',
    method: 'put',
    data
  })
}
export const deleteOrderInfo = (data) => {
  return service({
    url: '/mall/orderInfo',
    method: 'delete',
    data
  })
}
export const updateOrderStatus = (data) => {
  return service({
    url: '/mall/orderStatus',
    method: 'put',
    data
  })
}
export const cancelOrder = (data) => {
  return service({
    url: '/mall/cancelOrder',
    method: 'put',
    data
  })
}
export const shipOrder = (data) => {
  return service({
    url: '/mall/shipOrder',
    method: 'post',
    data
  })
}
export const getOrderItemList = (data) => {
  return service({
    // url: '/mall/getOrderItemList', method: 'post', data
    url: '/mall/orderItemList',
    method: 'get',
    params: data
  })
}
export const getOrderLogisticsList = (data) => {
  return service({
    // url: '/mall/getOrderLogisticsList', method: 'post', data
    url: '/mall/orderLogisticsList',
    method: 'get',
    params: data
  })
}

// ========== 门锁 ==========
export const getDoorLockList = (data) => {
  return service({
    // url: '/mall/getDoorLockList', method: 'post', data
    url: '/mall/doorLockList',
    method: 'get',
    params: data
  })
}
export const getDoorLock = (data) => {
  return service({
    // url: '/mall/getDoorLock', method: 'get', params: data
    url: '/mall/doorLock',
    method: 'get',
    params: data
  })
}
export const createDoorLock = (data) => {
  return service({
    // url: '/mall/createDoorLock', method: 'post', data
    url: '/mall/doorLock',
    method: 'post',
    data
  })
}
export const updateDoorLock = (data) => {
  return service({
    // url: '/mall/updateDoorLock', method: 'put', data
    url: '/mall/doorLock',
    method: 'put',
    data
  })
}
export const deleteDoorLock = (data) => {
  return service({
    // url: '/mall/deleteDoorLock', method: 'delete', data
    url: '/mall/doorLock',
    method: 'delete',
    data
  })
}
export const openDoor = (data) => {
  return service({
    url: '/mall/doorLock/open',
    method: 'post',
    data
  })
}
export const getDoorLockHistoryList = (data) => {
  return service({
    // url: '/mall/getDoorLockHistoryList', method: 'post', data
    url: '/mall/doorLockHistoryList',
    method: 'get',
    params: data
  })
}
