import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  server: { 
    port: 5177, // frontend 
    proxy: { // backend
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true,
      },
      '/websocket': {
        target: 'ws://localhost:8081',
        ws: true,
      },      
    },
  },
  plugins: [react()]
});

