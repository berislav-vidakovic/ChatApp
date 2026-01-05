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

