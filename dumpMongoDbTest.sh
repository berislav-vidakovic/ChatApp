#!/bin/bash  
# SCRIPT: dumpMongoDbTest.sh
set -e

MONGO_DUMP_DIR=/var/www/chatapp/data/mongo-dump  # host path to mongodump
MONGO_DUMP_DB=chatapp_test  # Database to dump

# Load Mongo credentials
if [ -f data/.env.mongo ]; then
  set -a          # automatically export variables
  source data/.env.mongo
  set +a
else
  echo ".env.mongo file not found"
  exit 1
fi

echo "Dumping database $MONGO_DUMP_DB...."
sudo rm -rf $MONGO_DUMP_DIR/$MONGO_DUMP_DB
sudo -E mongodump --uri="mongodb://${MONGO_USER}:${MONGO_PWD}@barryonweb.com:27017/$MONGO_DUMP_DB" --out="$MONGO_DUMP_DIR"

