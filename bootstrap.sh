#!/bin/sh
set -ex

VAR_AUTH_ENABLED=${MONGODB_AUTH_ENABLED:-false}
VAR_MONGODB_USERNAME="${MONGODB_USER}"
VAR_MONGODB_PASSWORD="${MONGODB_PASSWORD}"

create_admin(){
mongo <<EOF
use admin
db.createUser({user: "${VAR_MONGODB_USERNAME}", pwd: "${VAR_MONGODB_PASSWORD}", roles:[{role: "root", db: "admin"}]})
EOF
touch /bekkerstacks/.init
}

boot_server_initial(){
  echo "$(date) - initial boot of mongodb server to prepare for auth"
  mkdir -p /data/db
  mongod --syslog --storageEngine wiredTiger --smallfiles --dbpath /data/db --bind_ip_all --port 27017 &
}

boot_server_with_auth(){
  echo "$(date) - booting server with auth"
  touch /bekkerstacks/.init
  mongod --syslog --storageEngine wiredTiger --smallfiles --dbpath /data/db --bind_ip_all --port 27017 --auth
  touch /bekkerstacks/.init
}

boot_server_without_auth(){
  echo "$(date) - bootings server without auth"
  touch /bekkerstacks/.init
  mongod --syslog --storageEngine wiredTiger --smallfiles --dbpath /data/db --bind_ip_all --port 27017
}

if [ ${VAR_AUTH_ENABLED} = "true" ] &&  [ -f /bekkerstacks/.init ]

  then
    # auth is enabled and init file exists, booting with auth
    boot_server_with_auth

  elif [ ${VAR_AUTH_ENABLED} = "true" ] && [ ! -f /bekkerstacks/.init ]
    then
    # auth is enabled, but init file does not exist
      count=0
      boot_server_initial

      while [ $count -le 5 ]
        do
          sleep 1
          count=$((count + 1))
        done

      echo "creating admin user"
      create_admin

      sleep 2
      echo "tear down initial server to boot with auth enabled"
      kill $!
      sleep 2

      echo "starting server with auth enabled"
      boot_server_with_auth

  elif [ ${VAR_AUTH_ENABLED} = "false" ]
    then
    # auth is disabled, booting without auth
    boot_server_without_auth

  else
    echo "please make sure MONGODB_AUTH_ENABLED is set to true/false"
    exit 1

fi
