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
      // esbuild target: 降级ES2020+语法(如???.),避免旧浏览器白屏
      // 比legacyPlugin(Babel)快20倍以上,319s→~15s
      // es2017包含解构/async等,但不包含??和?.,esbuild可正确降级
      target: 'es2017',
      minify: 'esbuild',
      manifest: false,
      sourcemap: false,
      outDir: outDir,
      rollupOptions
    },
    // esbuild配置: 移除debugger(保留console用于排查白屏问题)
    esbuild: {
      drop: ['debugger']
    },
    optimizeDeps,
    plugins: [
      env.VITE_POSITION === 'open' &&
      vueDevTools({ launchEditor: env.VITE_EDITOR }),
      vuePlugin(),
      svgBuilder(['./src/plugin/', './src/assets/icons/'], base, outDir, 'assets', mode),
      VueFilePathPlugin('./src/pathInfo.json'),
      UnoCSS(),
      vueRootValidator()
    ]
  }
  return config
}
