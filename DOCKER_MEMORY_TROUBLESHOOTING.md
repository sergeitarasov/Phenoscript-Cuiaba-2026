# Docker Memory Issues - Troubleshooting Guide

## Problem
The pipeline fails with "Killed" (error 137) during the materializer step, typically indicating memory exhaustion.

## Root Causes
1. **Insufficient Docker memory allocation**
2. **Ontology punning warnings** (conflicting entity declarations)
3. **Mac-specific Docker Desktop memory limits**

## Solutions Applied

### 1. Updated Main Script ([run_docker.command](./run_docker.command))
- Added memory limits: `--memory=12g --memory-swap=16g`
- This should work for most Macs with 16GB+ RAM

### 2. Updated Dockerfile ([main/Dockerfile](./main/Dockerfile))
- Increased Java heap: `-Xmx10G`
- Added G1GC for better memory management
- Added garbage collection tuning

### 3. Updated Makefile ([main/Makefile](./main/Makefile))
- Added memory diagnostics
- Better error handling for materializer
- Captures stderr in logs

### 4. Low-Memory Alternative ([run_docker_lowmem.command](./run_docker_lowmem.command))
- For Macs with 8-12GB RAM
- Uses 4GB Java heap with optimized GC
- More conservative memory allocation

## Usage Instructions

### Try in Order:
1. **First**: Use updated `run_docker.command` (should work on most modern Macs)
2. **If failed**: Try `run_docker_lowmem.command`
3. **If still failing**: Check Docker Desktop memory allocation

### Docker Desktop Settings
1. Open Docker Desktop → Settings → Resources
2. Set Memory to at least 8GB (preferably 12GB+)
3. Apply & Restart Docker

### Alternative Approaches
If memory issues persist:

```bash
# Check available memory
docker run --rm ubuntu:22.04 free -h

# Test with even lower memory
docker run --rm --memory=4g --memory-swap=6g ubuntu:22.04 free -h
```

## Ontology Punning Warnings

The warnings about `OBI_0000293` and `RO_0002233` are due to conflicting declarations:
- Both declared as AnnotationProperty AND ObjectProperty
- This doesn't cause failure but may affect reasoning quality

### Files involved:
- `source_ontologies/bco.owl` - declares as AnnotationProperty  
- `source_ontologies/iao.owl` - declares as ObjectProperty
- `source_ontologies/bspo.owl` - has conflicting declarations

These warnings are non-fatal but indicate ontology consistency issues.

## Monitoring

Check logs after failure:
```bash
# View materializer log
cat main/log/materializer.log

# Check Docker container resource usage
docker stats
```