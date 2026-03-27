#!/bin/bash
set -e

IMAGE_NAME=${IMAGE_NAME:-custom-erpnext}
IMAGE_TAG=${IMAGE_TAG:-latest}

echo ">>> Building ${IMAGE_NAME}:${IMAGE_TAG} ..."

# base64 encode apps.json (no line wrapping)
APPS_JSON_BASE64=$(base64 -w 0 apps.json)

docker build --no-cache \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-16 \
  --build-arg=PYTHON_VERSION=3.14.2 \
  --build-arg=NODE_VERSION=24.11.0 \
  --build-arg=APPS_JSON_BASE64="${APPS_JSON_BASE64}" \
  --tag="${IMAGE_NAME}:${IMAGE_TAG}" \
  --file=images/custom/Containerfile \
  https://github.com/rskshirsagar/erp-docker.git   # uses customized Dockerfile from frappe_docker

echo ">>> Build done: ${IMAGE_NAME}:${IMAGE_TAG}"
