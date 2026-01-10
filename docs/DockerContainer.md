<a href="../Readme.md">Home</a>

# ChatApp - Containerization with Docker

## Environment variables - frontend

- Backend URL
  - Local Dev
    - vite.config.ts:
      ```js
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

## Environment variables - backend

- update application.yaml - enable env. vars injection
- Create .env for local run and script to run app locally
- Create .env on VPS
- Add script to run independently on systemd
  ```bash
  #!/bin/bash
  set -a
  source /var/www/chatapp/backend/.env
  set +a
  java -jar /var/www/chatapp/backend/chatappjn-0.0.1-SNAPSHOT.jar
  ```
- Create .env.template  (include in  git commmit)
- Create service.env to be used by systemd service
- Update service file to use secrets from service.env
  ```bash
  [Service]
  EnvironmentFile=/var/www/chatapp/backend/service.env
  ```


##  Docker networking

- All containers are on one Docker network, e.g., chatapp
- Nginx talks to backend at backend:8081
- Backend talks to Mongo at mongo:27017
- No container exposes sensitive ports to the internet except Nginx (80/443).

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

## Nginx container responsibilities

- Serve frontend static files (React build)
- Reverse proxy API calls (/api) to backend container
- Reverse proxy WebSocket connections (/websocket) to backend container
- Terminate HTTPS for chatapp-docker.barryonweb.com



