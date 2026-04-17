import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/init',
    name: 'Init',
    component: () => import('@/view/init/index.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/view/login/index.vue')
  },
  {
    path: '/scanUpload',
    name: 'ScanUpload',
    meta: {
      title: '扫码上传',
      client: true
    },
    component: () => import('@/view/example/upload/scanUpload.vue')
  },
  {
    // 兼容历史直链：将不带 layout 前缀的门店路由重定向到真实路由
    path: '/store/:pathMatch(.*)*',
    redirect: (to) => {
      const subPath = Array.isArray(to.params.pathMatch)
        ? to.params.pathMatch.join('/')
        : (to.params.pathMatch || '')
      return {
        path: `/layout/store/${subPath}`,
        query: to.query
      }
    }
  },
  {
    // 兼容历史直链：将不带 layout 前缀的验光路由重定向到真实路由
    path: '/optometry/:pathMatch(.*)*',
    redirect: (to) => {
      const subPath = Array.isArray(to.params.pathMatch)
        ? to.params.pathMatch.join('/')
        : (to.params.pathMatch || '')
      return {
        path: `/layout/optometry/${subPath}`,
        query: to.query
      }
    }
  },
  {
    path: '/:catchAll(.*)',
    meta: {
      closeTab: true
    },
    component: () => import('@/view/error/index.vue')
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
