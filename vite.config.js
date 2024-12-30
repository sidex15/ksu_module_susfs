// vite.config.js
import { defineConfig } from 'vite'
export default defineConfig({
    build: {
        target: 'esnext', //browsers can handle the latest ES features
        supported: {
            'top-level-await': true
        }, //browsers can handle top-level-await features
        rollupOptions: {
            input: {
                main: './index.html',
                credits: './credits.html',
                custom: './custom.html',
                //whitelist: './whitelist.html',
                //blacklist: './blacklist.html',
                fade: './fade.js'
            }
        }
    },
    esbuild: {
      supported: {
        'top-level-await': true //browsers can handle top-level-await features
      },
    },
    assetsInclude: ['**/*.ttf', '**/*.otf', '**/*.woff', '**/*.woff2']
})