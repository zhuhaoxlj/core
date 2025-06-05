# Redis Memory Server Installation Fix

When deploying on Ubuntu, you may encounter errors with Redis Memory Server during `pnpm i`. This is because Redis Memory Server attempts to compile Redis from source, and it requires specific dependencies.

## Solution 1: Disable Postinstall Scripts (Recommended)

The simplest solution is to disable the problematic postinstall scripts:

1. Run the alternative fix script:
   ```bash
   sudo ./scripts/alternative-fix.sh
   ```

2. Then install dependencies without running scripts:
   ```bash
   pnpm i --no-optional
   ```

This approach completely skips the Redis Memory Server and MongoDB Memory Server postinstall scripts that are causing the issues.

## Solution 2: Create Empty Library Files

If you need to keep the postinstall scripts running but want to fix the specific linking errors:

1. Run the fix script:
   ```bash
   sudo ./scripts/fix-redis-server.sh
   ```

   This script will:
   - Install required dependencies
   - Configure memory overcommit settings
   - Create empty library files to satisfy the linker

2. After running the script, try `pnpm i` again.

## Solution 3: Skip Binary Downloads

Another approach is to skip the binary downloads for Redis Memory Server and MongoDB Memory Server:

1. Add the following lines to `.npmrc`:
   ```
   redis-memory-server_binary_skip_download=true
   mongodb-memory-server_binary_skip_download=true
   ```

2. Run `pnpm i` again.

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

3. Create empty library files:
   ```bash
   cd node_modules/.pnpm/redis-memory-server@0.12.1/node_modules/redis-memory-server/redis-build
   mkdir -p deps/jemalloc/lib
   mkdir -p deps/fast_float
   touch deps/jemalloc/lib/libjemalloc.a
   touch deps/fast_float/libfast_float.a
   ```

4. Run `pnpm i` again.

## Why This Error Occurs

The error happens because:
1. Redis Memory Server attempts to compile Redis from source
2. The compilation fails because it can't find jemalloc and fast_float libraries
3. Redis requires memory overcommit to be enabled for proper operation

By using one of the solutions above, you should be able to resolve this issue. 