import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  server: { 
    port: 5177, // frontend 
    proxy: { // backend
      '/websocket': {
        target: 'ws://localhost:8081',
        ws: true,
      },
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true,
      },
    },
  },
  plugins: [react()]
});

