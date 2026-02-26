#!/usr/bin/env bash
# Double-clickable run script for macOS (Finder -> open with Terminal).
# First time: right-click -> Open (to bypass Gatekeeper), then double-click normally.

set -euo pipefail
cd "$(dirname "$0")"

IMAGE="ghcr.io/sergeitarasov/phenoscript-cuiaba-2026:latest"
MAIN_DIR="$(pwd)/main"

echo "=== Pulling Docker image ==="
if ! docker pull "$IMAGE"; then
    echo ""
    echo "ERROR: Could not pull image. Is Docker Desktop running and do you have internet access?"
    read -rp "Press Enter to close..."
    exit 1
fi

echo ""
echo "=== Running pipeline ==="
if ! docker run --rm -v "$MAIN_DIR:/main" "$IMAGE"; then
    echo ""
    echo "ERROR: Pipeline failed. See output above for details."
    read -rp "Press Enter to close..."
    exit 1
fi

echo ""
echo "=== Pipeline complete ==="
echo "Output : $MAIN_DIR/output"
echo "Logs   : $MAIN_DIR/log"
echo ""
read -rp "Press Enter to close..."
