#!/bin/bash
set -e

echo "==> Tagging backup image..."
docker tag custom-erpnext:latest custom-erpnext:backup-$(date +%Y%m%d)

echo "==> Rebuilding image..."
bash build.sh

echo "==> Redeploying app containers..."
docker compose -f pwd.yml up -d --no-deps --force-recreate backend frontend websocket queue-long queue-short scheduler

echo "==> Waiting for backend to be ready..."
sleep 15

echo "==> Running migrations on all sites..."
docker compose -f pwd.yml exec backend bench --site all migrate

echo "==> Clearing caches on all sites..."
docker compose -f pwd.yml exec backend bench --site all clear-cache
docker compose -f pwd.yml exec backend bench --site all clear-website-cache

echo "==> Done! All sites updated successfully."
