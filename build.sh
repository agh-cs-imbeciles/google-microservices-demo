#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <image-tag>"
  exit 1
fi
export BUILDPLATFORM="linux/amd64"
export TAG=$1
export REPO_PREFIX=suselkowy

SCRIPT_PATH="./docs/releasing/make-docker-images.sh"
$SCRIPT_PATH
