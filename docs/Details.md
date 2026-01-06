<a href="../Readme.md">Home</a>

## Parameterize DB connection to MongodB
  ```yaml
  data:
    mongodb:
      uri: ${MONGO_URI:mongodb://barry75:abc123@barryonweb.com:27017/chatappdb}
      database: ${MONGO_DB:chatappdb}
  ```

## Backup and restore MongoDB database (copy to existing db with user created)
  ```bash
  mongodump --uri="mongodb://barry75:abc123@localhost:27017/chatappdb" --out=./chatappdb.bak
  db.dropUser("barry75");
  mongorestore --uri="mongodb://barry75:abc123@localhost:27017/chatapp_test" ./chatappdb.bak/chatappdb
  ```

## Setup Test environment in Docker container

### 1. Containerize backend 

- Add Docker file to backend
  - copy build output file to app.jar
  - internal Port 8080
- Add docker-compose.yml to backend 
  - map Port 8085:8080 and specify DB details
  - Override Port from application.yml with  --server.port=8080
  - Build & run container on server
      ```yaml
      services:
        games-backend-test:
          build: .
          container_name: games-backend-test
          ports:
            - "8084:8080"
          environment:
            SPRING_DATASOURCE_URL: jdbc:mysql://barryonweb.com:3306/games_test
            SPRING_DATASOURCE_USERNAME: barry75
            SPRING_DATASOURCE_PASSWORD: abc123
            SPRING_PROFILES_ACTIVE: prod
            JAVA_OPTS: "-Xms256m -Xmx512m"
            SPRING_SERVER_PORT: 8080
          command: ["java", "-jar", "app.jar", "--server.port=8080"]
          restart: unless-stopped
      ```
  - Run
    ```bash
    docker compose -f docker-compose.test.yml up -d
    ```
  - Restart container
    ```bash
    docker compose -f docker-compose.test.yml down
    docker compose -f docker-compose.test.yml build --no-cache
    docker compose -f docker-compose.test.yml up -d
    ```
  - Test
    ```bash
    curl http://localhost:8085/api/ping
    curl http://localhost:8085/api/pingdb
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


### 3. Deployment environment control

- Create bash script to build Doker image and run docker container
  - Build image
    ```bash
    docker build -t chatapp-backend-test .
    ```
  - Restart container
    ```bash
    docker compose -f docker-compose.test.yml down
    docker compose -f docker-compose.test.yml build --no-cache
    docker compose -f docker-compose.test.yml -p chatapp-test up -d
    ```

