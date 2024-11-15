#!/usr/bin/env bash

# Manual update of all packages and Docker container
# Author: Christian Wichmann
# Date: 2024-11-03

# Check if user is root (https://stackoverflow.com/a/18216122/18073555)
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo
echo "*** Update all packages and Docker container manually... ***"
echo

apt update
apt full-upgrade -y

docker compose -f container/infrastructure/docker-compose.yml pull
docker compose -f container/infrastructure/docker-compose.yml up -d

docker compose -f container/etherpad/docker-compose.yml pull
docker compose -f container/etherpad/docker-compose.yml up -d

docker compose -f container/static/docker-compose.yml pull
docker compose -f container/static/docker-compose.yml up -d

#docker image prune -a -f
