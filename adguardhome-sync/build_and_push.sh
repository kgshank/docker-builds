#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
#


VERSION=${VERSION:-`cat VERSION`}
VERSION=${VERSION:-latest}
echo "Building for $VERSION"

THIS_PATH="$(dirname "$(readlink -f "$0")")"
cd $THIS_PATH
cp -R $THIS_PATH/../certs . && docker buildx build  --platform linux/arm64/v8,linux/amd64 -t kgshank/adguard-sync:$VERSION --push . && rm -rf $THIS_PATH/certs


