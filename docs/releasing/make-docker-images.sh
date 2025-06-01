#!/usr/bin/env bash

# Builds and pushes docker image for each demo microservice to Docker Hub.

set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT=$SCRIPT_DIR/../..

log() { echo "$1" >&2; }

TAG="${TAG:?TAG env variable must be specified}"
REPO_PREFIX="${REPO_PREFIX:?REPO_PREFIX env variable must be specified, e.g. dockerhub-username}"
# Optional: export DOCKERHUB_PASSWORD and DOCKERHUB_USERNAME for login automation

# Docker Hub login (optional — remove if already logged in)
if [ -n "${DOCKERHUB_USERNAME:-}" ] && [ -n "${DOCKERHUB_PASSWORD:-}" ]; then
  echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
fi

while IFS= read -d $'\0' -r dir; do
    svcname="$(basename "${dir}")"
    builddir="${dir}"
    #PR 516 moved cartservice build artifacts one level down to src
    if [ $svcname == "cartservice" ]
    then
        builddir="${dir}/src"
    fi
    image="${REPO_PREFIX}/$svcname:$TAG"
    image_with_sample_public_image_tag="${REPO_PREFIX}/$svcname:sample-public-image-$TAG"
    (
        cd "${builddir}"
        log "Building Docker image: ${image}"
        docker build -t "${image}" . --build-arg BUILDPLATFORM=linux/amd64

        log "Tagging image: ${image_with_sample_public_image_tag}"
        docker tag "${image}" "${image_with_sample_public_image_tag}"

        log "Pushing image: ${image}"
        docker push "${image}"
    )
done < <(find "${REPO_ROOT}/src" -mindepth 1 -maxdepth 1 -type d -print0)

log "✅ Successfully built and pushed all images to Docker Hub."