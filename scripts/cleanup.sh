#!/usr/bin/env bash
set -euo pipefail
echo "Cleaning up unused Docker resources..."
docker image prune -f
docker system prune -f
echo "Cleanup complete."
