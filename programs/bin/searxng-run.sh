#!/bin/sh
set -e

docker run --name searxng -d \
    -p 127.0.0.1:8888:8080 \
    -v "$HOME/.config/searxng/config/:/etc/searxng/" \
    -v "$HOME/.config/searxng/data/:/var/cache/searxng/" \
    docker.io/searxng/searxng:latest
