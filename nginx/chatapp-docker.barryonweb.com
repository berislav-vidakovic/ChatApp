server {
    server_name chatapp-docker.barryonweb.com;

    # ------ BACKEND API ---------------------------------------------
    location /api/ {
        proxy_pass http://127.0.0.1:8090;  # Host port mapped to backend container
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Authorization $http_authorization; # critical
    }

    # ------ BACKEND WebSocket ---------------------------------------
    location /websocket {
        proxy_pass http://127.0.0.1:8090;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
        proxy_connect_timeout 3600;
    }

    # ------ FRONTEND Container --------------------------------------
    location / {
        proxy_pass http://127.0.0.1:3000;  # Host port mapped to frontend container
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # ------ SSL -----------------------------------------------------
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/chatapp-docker.barryonweb.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chatapp-docker.barryonweb.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
    if ($host = chatapp-docker.barryonweb.com) {
        return 301 https://$host$request_uri;
    }
    server_name chatapp-docker.barryonweb.com;
    listen 80;
    return 404;
}
