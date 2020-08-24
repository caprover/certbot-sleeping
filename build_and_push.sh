#!/bin/bash

# Exit early if any command fails
set -e

# Print all commands
# set -x 

rm -f DockerfileProcessed.*
echo "Cleaning up..."
sleep 1s

CERTBOT_IMAGE_NAME="caprover/certbot-sleeping"
CERTBOT_VERSION="v1.6.0"



export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx ls
docker buildx create --name mybuilder || echo "Already created!"
docker buildx use mybuilder

declare -a ARCH_CERTBOT_TAGS=("amd64" "arm64v8" "arm32v6")
declare -a CERTBOT_ARCHS=("amd64" "arm64" "arm")

echo ""
echo "Building..."
for i in {0..2}
do
    ORIGINAL_TAG="${ARCH_CERTBOT_TAGS[$i]}"
    CERTBOT_ARCH="${CERTBOT_ARCHS[$i]}"
    echo "$CERTBOT_ARCH maps to cerbot:$ORIGINAL_TAG"
    eval "echo \"$(cat Dockerfile)\"" > DockerfileProcessed.$CERTBOT_ARCH
    docker buildx build --platform linux/$CERTBOT_ARCH -t $CERTBOT_IMAGE_NAME:$CERTBOT_ARCH-$CERTBOT_VERSION --push -f DockerfileProcessed.$CERTBOT_ARCH .
done

docker manifest create $CERTBOT_IMAGE_NAME:$CERTBOT_VERSION \
                       $CERTBOT_IMAGE_NAME:amd64-$CERTBOT_VERSION \
                       $CERTBOT_IMAGE_NAME:arm64-$CERTBOT_VERSION \
                       $CERTBOT_IMAGE_NAME:arm-$CERTBOT_VERSION

docker manifest create $CERTBOT_IMAGE_NAME:latest \
                       $CERTBOT_IMAGE_NAME:amd64-$CERTBOT_VERSION \
                       $CERTBOT_IMAGE_NAME:arm64-$CERTBOT_VERSION \
                       $CERTBOT_IMAGE_NAME:arm-$CERTBOT_VERSION


docker manifest push $CERTBOT_IMAGE_NAME:$CERTBOT_VERSION
docker manifest push $CERTBOT_IMAGE_NAME:latest