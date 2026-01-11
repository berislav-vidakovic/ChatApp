#!/bin/bash
set -e

# --- Config ---
FRONTEND_CONTAINER=chatapp-frontend
BACKEND_CONTAINER=chatapp-backend
MONGO_CONTAINER=chatapp-mongo
MONGO_DUMP_DIR=/var/www/chatapp/data/mongo-dump  # host path to mongodump
MONGO_DUMP_DB=chatapp_dev  # Database to dump
MONGO_CONTAINER_DUMP_PATH=/chatapp_dump      # path inside container

# Load Mongo credentials
if [ -f data/.env.mongo ]; then
  set -a          # automatically export variables
  source data/.env.mongo
  set +a
else
  echo ".env.mongo file not found"
  exit 1
fi

echo "Rebuilding full stack containers..."

# --- Stop containers if running ---
docker compose down

# --- Build containers ---
docker compose build

# --- Start containers ---
docker compose up -d

echo "Waiting for Mongo to initialize..."
# wait for Mongo to be ready (simple sleep, can be improved with a healthcheck)
sleep 10

# --- Dump MongoDB database
echo "Dumping database...."
sudo rm -rf /var/www/chatapp/data/mongo-dump/$MONGO_DUMP_DB
sudo mongodump --uri="mongodb://${MONGO_USER}:${MONGO_PWD}@barryonweb.com:27017/$MONGO_DUMP_DB" --out=$MONGO_DUMP_DIR


# --- Restore production DB into containerized Mongo ---
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


# --- Done ---
echo "Full stack App containers rebuilt and running!"
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:8090"


