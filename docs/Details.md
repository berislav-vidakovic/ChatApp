<a href="../Readme.md">Home</a>

## Parameterize DB connection to MongodB
  ```yaml
  data:
    mongodb:
      uri: ${MONGO_URI:mongodb://barry75:StrongPwd!@barryonweb.com:27017/chatappdb}
      database: ${MONGO_DB:chatappdb}
  ```

## Backup and restore MongoDB database (copy to existing db with user created)
  ```bash
  mongodump --uri="mongodb://barry75:StrongPwd!@localhost:27017/chatappdb" --out=./chatappdb.bak
  db.dropUser("barry75");
  mongorestore --uri="mongodb://barry75:StrongPwd!@localhost:27017/chatapp_test" ./chatappdb.bak/chatappdb
  ```

## Setup Test environment in Docker container

### 1. Containerize backend 

- Add Docker file to backend
  - copy build output file to app.jar
  - internal Port 8080
- Create bash script to build Docker image and run docker container
  ```bash
  #!/bin/bash
  set -e

  # Stop and remove any existing container
  docker rm -f chatapp-backend-test >/dev/null 2>&1 || true

  # Build Docker image from Dockerfile
  docker build -t chatapp-backend-test .

  # Run container
  docker run -d \
    --name chatapp-backend-test \
    -p 8085:8080 \
    -e MONGO_URI="mongodb://barry75:StrongPwd!@barryonweb.com:27017/chatapp_test" \
    -e MONGO_DB="chatapp_test" \
    -e SPRING_PROFILES_ACTIVE="prod" \
    -e JAVA_OPTS="-Xms256m -Xmx512m" \
    -e SPRING_SERVER_PORT=8080 \
    --restart unless-stopped \
    chatapp-backend-test \
    java -jar app.jar --server.port=8080

  echo "Container 'chatapp-backend-test' is running on Port 8085"
  ```

- Check environment variable within Docker container
  ```bash
  docker exec -it chatapp-backend-test env | grep MONGO
  ```

### 2. Backend routing setup - Nginx config for http

- reuse dev config file and modify
  - remove SSL section
  - update server name 
  - update Port to 8085
- Enable Nginx config site
- Test
  ```bash
  curl http://chatapp-test.barryonweb.com/api/ping
  curl http://chatapp-test.barryonweb.com/api/pingdb
  ```

- Enable HTTPS
  ```bash
  sudo certbot --nginx -d chatapp-test.barryonweb.com
  ```

- Test
  ```bash
  curl https://chatapp-test.barryonweb.com/api/ping
  curl https://chatapp-test.barryonweb.com/api/pingdb
  ```

### 3. Containerize frontend

- Add Dockerfile

- Update Nginx config file 
  - Old setup (common  frontend section for dev and test):
    ```
    Nginx → filesystem (/var/www/chatapp/frontend)
    ```
    ```nginx
    root /var/www/chatapp/frontend;
      index index.html;
      location / {
          try_files $uri /index.html;
      }
    ```
  - New setup:
    ```
    Nginx → frontend-test Docker container
    ```
    ```nginx
    location / {
      proxy_pass http://127.0.0.1:8086;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
    ```



