# Redis Memory Server Installation Fix

When deploying on Ubuntu, you may encounter errors with Redis Memory Server during `pnpm i`. This is because Redis Memory Server attempts to compile Redis from source, and it requires specific dependencies.

## Solution 1: Skip Binary Downloads (Recommended)

The simplest solution is to skip the binary downloads for Redis Memory Server and MongoDB Memory Server:

1. We've already added the following lines to `.npmrc`:
   ```
   redis-memory-server_binary_skip_download=true
   mongodb-memory-server_binary_skip_download=true
   ```

2. Run `pnpm i` again. This should skip the Redis binary compilation.

## Solution 2: Install Dependencies

If you need Redis Memory Server to work properly with binaries, you'll need to install the required dependencies:

1. Run the provided setup script:
   ```bash
   ./scripts/setup-redis-deps.sh
   ```

   This script will:
   - Install build-essential, tcl, and libjemalloc-dev
   - Configure memory overcommit settings required by Redis

2. After running the script, try `pnpm i` again.

## Manual Fix

If you prefer to manually fix the issue:

1. Install required packages:
   ```bash
   sudo apt-get update
   sudo apt-get install -y build-essential tcl libjemalloc-dev
   ```

2. Enable memory overcommit:
   ```bash
   echo vm.overcommit_memory=1 | sudo tee -a /etc/sysctl.conf
   sudo sysctl vm.overcommit_memory=1
   ```

3. Run `pnpm i` again.

## Why This Error Occurs

The error happens because:
1. Redis Memory Server attempts to compile Redis from source
2. The compilation fails because it can't find jemalloc libraries
3. Redis requires memory overcommit to be enabled for proper operation

By either skipping the binary download or installing the proper dependencies, you can resolve this issue. 