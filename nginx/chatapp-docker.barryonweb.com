server {
    server_name chatapp-docker.barryonweb.com;
    listen 443 ssl; 

    # -------------- Common proxy headers --------
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_set_header X-Forwarded-Host $host;

    # ------------------Security headers ---------
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy no-referrer-when-downgrade;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # ------ BACKEND API ---------------------------------------------
    location /api/ {
      proxy_pass http://127.0.0.1:8090/api/;  # Host port mapped to backend container
    }

    # ------ BACKEND WebSocket ---------------------------------------
    location /websocket {
      proxy_pass http://127.0.0.1:8090/websocket;
      proxy_read_timeout 3600;
      proxy_send_timeout 3600;
      proxy_connect_timeout 3600;
    }
    # ------ FRONTEND Container --------------------------------------
    location / { 
      proxy_pass http://127.0.0.1:3000;   
    }

    # ------ SSL -----------------------------------------------------
    ssl_certificate /etc/letsencrypt/live/chatapp-docker.barryonweb.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chatapp-docker.barryonweb.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

# ------- Redirect all HTTP traffic to HTTPS ------------------------
server {
    listen 80;
    server_name chatapp-docker.barryonweb.com;
    return 301 https://$host$request_uri;
}
