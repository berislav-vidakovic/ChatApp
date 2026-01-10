server {
    listen 80;
    server_name chatapp-docker.barryonweb.com;

    root /usr/share/nginx/html;
    index index.html;

    # Serve React frontend
    location / {
        try_files $uri /index.html;
    }

    # Proxy API requests to backend
    location /api/ {
        proxy_pass http://backend:8081/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }

    # Proxy WebSocket connections
    location /websocket/ {
        proxy_pass http://backend:8081/websocket/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }
}
