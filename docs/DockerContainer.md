<a href="../Readme.md">Home</a>

# ChatApp - Containerization with Docker

## Environment variables

- Backend URL
  - Local Dev
    - vite.config.ts:
      ```js
      export default defineConfig({
        server: { 
          port: 5177, // frontend 
          proxy: { // backend
            '/websocket': {
              target: 'ws://localhost:8081',
              ws: true,
            },
      ```
    - Frontend calls on 5177, not aware of backend port, The proxy is a dev-only transport mechanism
      ```
      Browser → http://localhost:5177/api/users/all
          ↓
      Vite proxy forwards to
                ↓
      Backend → http://localhost:8081/api/users/all
      ```
  - Production 
    - Add public/env.js file. With window.__ENV__, config is synchronous, window.__ENV__ is available before React mounts
      ```js
      window.__ENV__ = {
        BACKEND_HTTP_URL: "",
        BACKEND_WS_URL: ""
      };
      ```
    - This line in utils.ts is evaluated once at module import time and is already final
      ```js
      export const URL_BACKEND_HTTP = 
        window.__ENV__?.BACKEND_HTTP_URL || getDefaultHttpUrl();
      ```



## Backend

Backend Docker image should:

- Build Spring Boot app
- Run it as a container
- Accept config via environment variables
- NOT rely on systemd
- NOT rely on host-installed Java

So Docker replaces:
- Java install
- systemd service
- manual JAR handling



