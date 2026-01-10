#!/bin/bash
set -e

# --- Step 0: Config ---
FRONTEND_CONTAINER=chatapp-frontend
BACKEND_CONTAINER=chatapp-backend
MONGO_CONTAINER=chatapp-mongo
MONGO_DUMP_DIR=/var/www/chatapp/mongo-dump  # host path to mongodump
MONGO_CONTAINER_DUMP_PATH=/chatapp_dump      # path inside container

echo "Rebuilding full stack containers..."

# --- Step 1: Stop containers if running ---
docker compose down

# --- Step 2: Build containers ---
docker compose build

# --- Step 3: Start containers ---
docker compose up -d

echo "Waiting for Mongo to initialize..."
# wait for Mongo to be ready (simple sleep, can be improved with a healthcheck)
sleep 10

# --- Step 4: Restore production DB into containerized Mongo ---
if [ -d "$MONGO_DUMP_DIR/chatapp_dev" ]; then
    echo "Restoring production DB into containerized Mongo..."
    docker exec -i $MONGO_CONTAINER mongorestore \
      --username dockeruser \
      --password dockerpass \
      --authenticationDatabase admin \
      --drop \
      --db chatapp_dev \
      $MONGO_CONTAINER_DUMP_PATH/chatapp_dev
    echo "DB restored successfully."
else
    echo "Dump not found at $MONGO_DUMP_DIR/chatapp_dev. Skipping DB restore."
fi


# --- Step 5: Done ---
echo "🎉 Full stack App containers rebuilt and running!"
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:8090"


