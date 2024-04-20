#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
#


VERSION=`cat VERSION`
cp -R ../certs . && docker buildx build  --platform linux/arm64/v8,linux/amd64 -t kgshank/adguard-sync:$VERSION --push . && rm -rf certs


