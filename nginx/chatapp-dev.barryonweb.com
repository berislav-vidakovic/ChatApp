map $http_upgrade $connection_upgrade {
  websocket upgrade;
  default   keep-alive;
}

server {
  server_name chatapp-dev.barryonweb.com;
  listen 443 ssl;

  # Common proxy headers (inherited by all locations)
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header Host $host;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_set_header X-Forwarded-Port $server_port;
  proxy_set_header X-Forwarded-Host $host;

  # Security headers
  add_header X-Content-Type-Options nosniff;
  add_header X-Frame-Options SAMEORIGIN;
  add_header X-XSS-Protection "1; mode=block";
  add_header Referrer-Policy no-referrer-when-downgrade;
  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;


  # ------ BACKEND config ------------------------------------------
  # Proxy all API requests to Spring Boot backend (port 8081)
  location /api/ {
    proxy_pass http://127.0.0.1:8081;
  }

  #  WebSocket proxy
  location /websocket {
    proxy_pass http://127.0.0.1:8081/websocket;

    # Websocket timeout (default is 60s)
    proxy_read_timeout 3600;
    proxy_send_timeout 3600;
    proxy_connect_timeout 3600;
  }

  # ------ FRONTEND config ------------------------------------------
  root /var/www/chatapp/frontend;
  index index.html;

  location / { try_files $uri /index.html; }

  # -------------SSL  -----------------------------------------------
  ssl_certificate /etc/letsencrypt/live/chatapp-dev.barryonweb.com/fullchain.pem; 
  ssl_certificate_key /etc/letsencrypt/live/chatapp-dev.barryonweb.com/privkey.pem; 
  include /etc/letsencrypt/options-ssl-nginx.conf; 
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; 
}

# ------- Redirect all HTTP traffic to HTTPS ------------------------
server {
    listen 80;
    server_name chatapp-dev.barryonweb.com;
    return 301 https://$host$request_uri;
}
