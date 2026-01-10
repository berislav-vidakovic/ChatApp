#!/bin/bash
set -a
source /var/www/chatapp/backend/.env
set +a

java -jar /var/www/chatapp/backend/chatappjn-0.0.1-SNAPSHOT.jar
