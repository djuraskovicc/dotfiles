#!/bin/sh
set -e

CONTAINER_NAME="searxng"

if docker ps -a --format "{{.Names}}" | grep "${CONTAINER_NAME}"; then
  echo "Container '${CONTAINER_NAME}' is running. Stopping and removing"
  docker container stop ${CONTAINER_NAME}
  docker container rm ${CONTAINER_NAME}
  exit
fi

docker run --name $CONTAINER_NAME -d \
    -p 127.0.0.1:8888:8080 \
    -v "$HOME/.config/$CONTAINER_NAME/config/:/etc/$CONTAINER_NAME/" \
    -v "$HOME/.config/$CONTAINER_NAME/data/:/var/cache/$CONTAINER_NAME/" \
    docker.io/$CONTAINER_NAME/$CONTAINER_NAME:latest
