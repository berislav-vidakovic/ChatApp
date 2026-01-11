#!/bin/bash

JAR_PATH="/var/www/chatapp/backend/chatappjn-0.0.1-SNAPSHOT.jar"

./stopProd.sh # stop if running ....

echo "Loading environment variables..."
set -a
source /var/www/chatapp/backend/.env.dev
set +a

echo "Starting backend..."
nohup java -jar "$JAR_PATH" > backend.log 2>&1 &

echo "Backend started."
