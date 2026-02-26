#!/usr/bin/env bash
# Double-clickable run script for macOS (Finder -> open with Terminal).
# First time: right-click -> Open (to bypass Gatekeeper), then double-click normally.

set -euo pipefail
cd "$(dirname "$0")"

IMAGE_NAME="phenoscript-pipeline"
MAIN_DIR="$(pwd)/main"

echo "=== Building Docker image: $IMAGE_NAME ==="
if ! docker build -t "$IMAGE_NAME" "$MAIN_DIR"; then
    echo ""
    echo "ERROR: Docker build failed. Is Docker Desktop running?"
    read -rp "Press Enter to close..."
    exit 1
fi

echo ""
echo "=== Running pipeline ==="
if ! docker run --rm -v "$MAIN_DIR:/main" "$IMAGE_NAME"; then
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
