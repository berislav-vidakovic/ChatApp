server {
    server_name chatapp-docker.barryonweb.com;

    # Frontend React app
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend REST API
    location /api/ {
        proxy_pass http://localhost:8090/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # WebSocket endpoint
    location /websocket {
        proxy_pass http://localhost:8090/websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;

        # Optional: WebSocket ping timeout
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }

    listen 443 ssl; 
    ssl_certificate /etc/letsencrypt/live/chatapp-docker.barryonweb.com/fullchain.pem; 
    ssl_certificate_key /etc/letsencrypt/live/chatapp-docker.barryonweb.com/privkey.pem; 
    include /etc/letsencrypt/options-ssl-nginx.conf; 
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; 
}

server {
    if ($host = chatapp-docker.barryonweb.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

  server_name chatapp-docker.barryonweb.com;
    listen 80;
    return 404; # managed by Certbot
}
