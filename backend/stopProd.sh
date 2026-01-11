#!/bin/bash

JAR_PATH="/var/www/chatapp/backend/chatappjn-0.0.1-SNAPSHOT.jar"

echo "Stopping existing backend (if running)..."

pkill -f "$JAR_PATH"
