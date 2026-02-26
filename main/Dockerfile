FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_OPTS="-Xmx8G"
ENV JVM_ARGS="-Xmx8G"

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
ENV JENA_VERSION=5.1.0
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

# Copy project files (source_ontologies excluded via .dockerignore to keep image lean;
# if source_ontologies are present on the host they will be available via the volume mount)
COPY . .

CMD ["make"]
