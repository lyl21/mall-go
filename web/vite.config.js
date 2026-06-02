import { viteLogo } from './src/core/config'
import * as path from 'path'
import { loadEnv } from 'vite'
import vuePlugin from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'
import VueFilePathPlugin from './vitePlugin/componentName/index.js'
import { svgBuilder } from 'vite-auto-import-svg'
import vueRootValidator from 'vite-check-multiple-dom'
import UnoCSS from '@unocss/vite'

// @see https://cn.vitejs.dev/config/
export default ({ mode }) => {
  const env = loadEnv(mode, process.cwd())
  viteLogo(env)

  const optimizeDeps = {}

  const alias = {
    '@': path.resolve(__dirname, './src'),
    vue$: 'vue/dist/vue.runtime.esm-bundler.js'
  }

  const esbuild = {}

  const rollupOptions = {
    output: {
      entryFileNames: 'assets/[name].[hash].js',
      chunkFileNames: 'assets/[name].[hash].js',
      assetFileNames: 'assets/[name].[hash].[ext]'
    }
  }

  const base = '/'
  const root = './'
  const outDir = 'dist'

  const config = {
    base: base, // 编译后js导入的资源路径
    root: root, // index.html文件所在位置
    publicDir: 'public', // 静态资源文件夹
    resolve: {
      alias
    },
    css: {
      preprocessorOptions: {
        scss: {
          api: 'modern-compiler' // or "modern"
        }
      }
    },
    server: {
      // 如果使用docker-compose开发模式，设置为false
      open: true,
      port: Number(env.VITE_CLI_PORT),
      proxy: {
        // 把key的路径代理到target位置
        // detail: https://cli.vuejs.org/config/#devserver-proxy
        [env.VITE_BASE_API]: {
          // 需要代理的路径   例如 '/api'
          target: `${env.VITE_BASE_PATH}:${env.VITE_SERVER_PORT}/`, // 代理到 目标路径
          changeOrigin: true,
          rewrite: (path) =>
            path.replace(new RegExp('^' + env.VITE_BASE_API), '')
        },
        '/ws': {
          target: `${env.VITE_BASE_PATH}:${env.VITE_SERVER_PORT}`,
          ws: true,
          changeOrigin: true
        },
        '/equipment': {
          target: `${env.VITE_BASE_PATH}:${env.VITE_SERVER_PORT}`,
          ws: true,
          changeOrigin: true
        }
      }
    },
    build: {
      minify: 'esbuild', // esbuild 比 terser 快 20 倍以上
      manifest: false, // 是否产出manifest.json
      sourcemap: false, // 是否产出sourcemap.json
      outDir: outDir, // 产出目录
      // terserOptions 已移除，使用 esbuild 压缩无需额外配置
      rollupOptions
    },
    esbuild,
    optimizeDeps,
    plugins: [
      env.VITE_POSITION === 'open' &&
      vueDevTools({ launchEditor: env.VITE_EDITOR }),
      // legacyPlugin 已移除: 内部管理后台不需要旧浏览器兼容，legacy 会让构建时间翻倍
      vuePlugin(),
      svgBuilder(['./src/plugin/', './src/assets/icons/'], base, outDir, 'assets', mode),
      VueFilePathPlugin('./src/pathInfo.json'),
      UnoCSS(),
      vueRootValidator()
    ]
  }
  return config
}
