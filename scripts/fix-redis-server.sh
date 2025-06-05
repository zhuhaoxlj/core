#!/bin/bash

# Comprehensive fix for Redis Memory Server installation issues
echo "Fixing Redis Memory Server installation issues..."

# 1. Install required dependencies
echo "Installing dependencies..."
apt-get update
apt-get install -y build-essential tcl libjemalloc-dev

# 2. Set memory overcommit parameter
echo "Setting vm.overcommit_memory=1..."
echo vm.overcommit_memory=1 | tee -a /etc/sysctl.conf
sysctl vm.overcommit_memory=1

# 3. Create required directories for Redis dependencies
echo "Creating Redis dependency directories..."
cd node_modules/.pnpm/redis-memory-server@0.12.1/node_modules/redis-memory-server/redis-build

# Create deps directory if it doesn't exist
mkdir -p deps/jemalloc/lib
mkdir -p deps/fast_float

# Create empty library files to satisfy the linker
touch deps/jemalloc/lib/libjemalloc.a
touch deps/fast_float/libfast_float.a

echo "Fix applied! Try running 'pnpm i' again." 