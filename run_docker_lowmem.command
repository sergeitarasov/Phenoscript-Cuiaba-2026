#!/usr/bin/env bash
# Low-memory version for Macs with limited RAM
# Uses smaller memory allocation and alternative reasoning approach

set -euo pipefail
cd "$(dirname "$0")"

IMAGE_NAME="phenoscript-pipeline-lowmem"
MAIN_DIR="$(pwd)/main"

echo "=== Building Docker image (low-memory): $IMAGE_NAME ==="
# Create a temporary Dockerfile with reduced memory settings
cat > "$MAIN_DIR/Dockerfile.lowmem" << 'EOF'
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_OPTS="-Xmx4G -XX:+UseG1GC -XX:MaxGCPauseMillis=400 -XX:+UseStringDeduplication"
ENV JVM_ARGS="-Xmx4G -XX:+UseG1GC -XX:MaxGCPauseMillis=400 -XX:+UseStringDeduplication"

# System deps
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    curl \
    make \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# phenospy
RUN pip3 install phenospy

# ROBOT v1.9.6
RUN mkdir -p /opt/robot \
    && wget -q -O /opt/robot/robot.jar \
       https://github.com/ontodev/robot/releases/download/v1.9.6/robot.jar \
    && printf '#!/bin/sh\nexec java $JAVA_OPTS -jar /opt/robot/robot.jar "$@"\n' \
       > /opt/robot/robot \
    && chmod +x /opt/robot/robot
ENV PATH="/opt/robot:${PATH}"

# Apache Jena 5.1.0 (riot, shacl, update, arq)
ENV JENA_VERSION=5.3.0
RUN wget -q https://archive.apache.org/dist/jena/binaries/apache-jena-${JENA_VERSION}.tar.gz \
    && tar -xzf apache-jena-${JENA_VERSION}.tar.gz \
    && mv apache-jena-${JENA_VERSION} /opt/jena \
    && rm apache-jena-${JENA_VERSION}.tar.gz
ENV PATH="/opt/jena/bin:${PATH}"

# Materializer v0.2.7
ENV MATERIALIZER_VERSION=0.2.7
RUN wget -q https://github.com/balhoff/materializer/releases/download/v${MATERIALIZER_VERSION}/materializer-${MATERIALIZER_VERSION}.tgz \
    && tar -xzf materializer-${MATERIALIZER_VERSION}.tgz \
    && mv materializer-${MATERIALIZER_VERSION} /opt/materializer \
    && rm materializer-${MATERIALIZER_VERSION}.tgz
ENV PATH="/opt/materializer/bin:${PATH}"

WORKDIR /main

# Copy project files
COPY . .

# Default command
CMD ["make", "all"]
EOF

if ! docker build -f "$MAIN_DIR/Dockerfile.lowmem" -t "$IMAGE_NAME" "$MAIN_DIR"; then
    echo ""
    echo "ERROR: Docker build failed. Is Docker Desktop running?"
    read -rp "Press Enter to close..."
    exit 1
fi

echo ""
echo "=== Running pipeline (low-memory mode) ==="
if ! docker run --rm --memory=6g --memory-swap=8g --oom-kill-disable=false -v "$MAIN_DIR:/main" "$IMAGE_NAME"; then
    echo ""
    echo "ERROR: Pipeline failed. See output above for details."
    echo "Try increasing Docker Desktop memory allocation or use run_docker_minimal.command"
    read -rp "Press Enter to close..."
    exit 1
fi

# Cleanup
rm -f "$MAIN_DIR/Dockerfile.lowmem"

echo ""
echo "=== Pipeline complete ==="
echo "Output : $MAIN_DIR/output"
echo "Logs   : $MAIN_DIR/log"
echo ""
read -rp "Press Enter to close..."