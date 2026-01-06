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
  -e MONGO_URI="mongodb://barry75:abc123@barryonweb.com:27017/chatapp_test" \
  -e MONGO_DB="chatapp_test" \
  -e SPRING_PROFILES_ACTIVE="prod" \
  -e JAVA_OPTS="-Xms256m -Xmx512m" \
  -e SPRING_SERVER_PORT=8080 \
  --restart unless-stopped \
  chatapp-backend-test

echo "Container 'chatapp-backend-test' is running on Port 8085"
