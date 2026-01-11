#!/bin/bash
set -e

# --- Backend container -------------------------------------------

# Stop and remove any existing container
docker rm -f chatapp-backend-test >/dev/null 2>&1 || true

# Build Docker image from Dockerfile
docker build -t chatapp-backend-test ./backend/

# Run container
docker run -d \
  --name chatapp-backend-test \
  -p 8085:8080 \
  --env-file backend/.env.test \
  -e JAVA_OPTS="-Xms256m -Xmx512m" \
  --restart unless-stopped \
  chatapp-backend-test

echo "Backend Test Container 'chatapp-backend-test' is running on Port 8085"

# --- Frontend container -------------------------------------------
IMAGE_NAME=chatapp-frontend-test
CONTAINER_NAME=chatapp-frontend-test
HOST_PORT=8086
CONTAINER_PORT=80

echo "Stopping and removing existing frontend test container (if any)..."
docker rm -f $CONTAINER_NAME >/dev/null 2>&1 || true

echo "Building frontend test Docker image..."
docker build -t $IMAGE_NAME ./frontend/

echo "Running frontend test container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p $HOST_PORT:$CONTAINER_PORT \
  --restart unless-stopped \
  $IMAGE_NAME

echo "Frontend Test container is running on port $HOST_PORT"




