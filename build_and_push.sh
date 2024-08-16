#!/bin/bash

# Exit early if any command fails
set -e

# Print all commands
set -x

pwd

export CERTBOT_IMAGE_NAME="caprover/certbot-sleeping"
export CERTBOT_VERSION="v2.11.0"
PROCESSED_DOCKERFILE="DockerfileProcessed.release"
envsubst <Dockerfile >$PROCESSED_DOCKERFILE

# ensure you're not running it on local machine
if [ -z "$CI" ] || [ -z "$GITHUB_REF" ]; then
    echo "Running on a local machine! Exiting!"
    exit 127
else
    echo "Running on CI"
fi

# BRANCH=$(git rev-parse --abbrev-ref HEAD)
# On Github the line above does not work, instead:
BRANCH=${GITHUB_REF##*/}
echo "on branch $BRANCH"
if [[ "$BRANCH" != "master" ]]; then
    echo 'Not on master branch! Aborting script!'
    exit 1
fi

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx ls
docker buildx create --name mybuilder
docker buildx use mybuilder

docker buildx build --platform linux/amd64,linux/arm64,linux/arm -t $CERTBOT_IMAGE_NAME:$CERTBOT_VERSION -t $CERTBOT_IMAGE_NAME:latest -f $PROCESSED_DOCKERFILE --push .
