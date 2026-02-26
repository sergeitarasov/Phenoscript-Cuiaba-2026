#!/usr/bin/env bash
# run_docker.sh — pull the phenoscript pipeline image and run it.
# All output is written directly to your local main/ directory via a volume mount.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_DIR="$SCRIPT_DIR/main"
IMAGE="ghcr.io/sergeitarasov/phenoscript-cuiaba-2026:latest"

# --------------------------------------------------------------------------
echo "=== Pulling Docker image ==="
docker pull "$IMAGE"

# --------------------------------------------------------------------------
echo ""
echo "=== Running pipeline (output will appear in main/output and main/log) ==="
docker run --rm \
    -v "$MAIN_DIR:/main" \
    "$IMAGE"

# --------------------------------------------------------------------------
echo ""
echo "=== Pipeline complete ==="
echo "Output  : $MAIN_DIR/output"
echo "Logs    : $MAIN_DIR/log"
