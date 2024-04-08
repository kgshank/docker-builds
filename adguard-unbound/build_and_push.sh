#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
VERSION=`cat VERSION`
docker buildx build --build-arg VERSION=$VERSION --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t kgshank/adguard-unbound:$VERSION --push .

