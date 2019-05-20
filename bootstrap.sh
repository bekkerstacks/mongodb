#!/bin/sh
set -ex

MONGODB_USERNAME="dbadmin"
MONGODB_PASSWORD="dbpasswd"

count=0
echo "booting mongodb server"
mkdir -p /data/db
mongod --syslog --storageEngine wiredTiger --smallfiles --dbpath /data/db --bind_ip_all --port 27017 &
while [ $count -le 10 ]
  do
    sleep 1
    count=$((count + 1))
  done

echo "creating admin user"
mongo <<EOF
use admin
db.createUser({user: "${MONGODB_USERNAME}", pwd: "${MONGODB_PASSWORD}", roles:[{role: "root", db: "admin"}]})
EOF

sleep 2
echo "tear down"
kill $!

echo "starting server with auth"
mongod --syslog --storageEngine wiredTiger --smallfiles --dbpath /data/db --bind_ip_all --port 27017 --auth
