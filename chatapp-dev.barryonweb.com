server {
  server_name chatapp-dev.barryonweb.com;

  # ------ BACKEND config ------------------------------------------
  # Proxy all API requests to Spring Boot backend (port 8081)
  location /api/ {
    proxy_pass http://127.0.0.1:8081;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  #  WebSocket support
  location /websocket {
    proxy_pass http://127.0.0.1:8081;

    # REQUIRED for WebSockets
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";

    # Pass client info headers
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # Websocket timeout (default is 60s)
    proxy_read_timeout 3600;
    proxy_send_timeout 3600;
    proxy_connect_timeout 3600;
  }

  # ------ FRONTEND config ------------------------------------------

  root /var/www/chatapp/frontend;
  index index.html;

  location / {
      try_files $uri /index.html;
  }
}
