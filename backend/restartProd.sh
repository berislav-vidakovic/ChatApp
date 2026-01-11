#!/bin/bash

JAR_PATH="/var/www/chatapp/backend/chatappjn-0.0.1-SNAPSHOT.jar"

echo "Stopping existing backend (if running)..."

PID=$(pgrep -f "$JAR_PATH")

if [ -n "$PID" ]; then
  echo "Found running backend with PID $PID. Stopping..."
  kill "$PID"
  sleep 3
else
  echo "No running backend found."
fi

echo "Loading environment variables..."
set -a
source /var/www/chatapp/backend/.env.dev
set +a

echo "Starting backend..."
nohup java -jar "$JAR_PATH" > backend.log 2>&1 &

echo "Backend started."
