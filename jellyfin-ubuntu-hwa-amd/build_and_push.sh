#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
cd "$(dirname "$(readlink -f "$0")")"
VERSION=${VERSION:-`cat VERSION`}
VERSION=${VERSION:-latest}
echo "Building for $VERSION"
docker buildx build --build-arg VERSION=$VERSION --platform linux/amd64 -t kgshank/jellyfin-ubuntu-hwa-amd:$VERSION --push .

