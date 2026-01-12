#!/bin/bash 
# SCRIPT: rebuildAppContainer.sh
set -e

# --- Config ---
FRONTEND_CONTAINER=chatapp-frontend
BACKEND_CONTAINER=chatapp-backend
MONGO_CONTAINER=chatapp-mongo
MONGO_DUMP_DIR=/var/www/chatapp/data/mongo-dump  # host path to mongodump
MONGO_DUMP_DB=chatapp_test  # Database to dump
MONGO_CONTAINER_DUMP_PATH=/chatapp_dump      # path inside container

echo "Rebuilding full stack containers..."

# --- Stop containers if running ---
docker compose down -v # -v flag for clean state - Mongo data survives container 
# rebuilds - docker compose down does NOT delete DBs. 

# --- Build containers ---
docker compose build

# --- Start containers ---
docker compose up -d

echo "Waiting for Mongo..."
until docker exec $MONGO_CONTAINER mongosh \
  -u dockeruser -p dockerpass \
  --authenticationDatabase admin \
  --eval "db.adminCommand({ ping: 1 })" \
  --quiet >/dev/null 2>&1; do
  echo "...Mongo not ready yet"
  sleep 3
done
echo "MongoDB is ready!"

# --- Dump MongoDB database
./dumpMongoDbTest.sh

# --- Restore production DB into containerized Mongo ---
if [ -d "$MONGO_DUMP_DIR/$MONGO_DUMP_DB" ]; then
    echo "Restoring production DB into containerized Mongo..."
    docker exec -i $MONGO_CONTAINER mongorestore \
      --username dockeruser \
      --password dockerpass \
      --authenticationDatabase admin \
      --drop \
      --db $MONGO_DUMP_DB \
      $MONGO_CONTAINER_DUMP_PATH/$MONGO_DUMP_DB
    echo "DB restored successfully."
else
    echo "Dump not found at $MONGO_DUMP_DIR/$MONGO_DUMP_DB. Skipping DB restore."
fi


# --- Done ---
echo "Full stack App containers rebuilt and running!"
echo "Frontend: http://localhost:3000"
echo "Backend:  http://localhost:8090"


