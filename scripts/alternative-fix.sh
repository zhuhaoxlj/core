#!/bin/bash

# Alternative fix: Disable Redis Memory Server and MongoDB Memory Server postinstall scripts
echo "Applying alternative fix for Redis and MongoDB Memory Server issues..."

# Create a .npmrc file in the project root with the correct settings
cat > .npmrc << EOL
public-hoist-pattern[]=*fastify*
public-hoist-pattern[]=mongodb
public-hoist-pattern[]=*eslint*
public-hoist-pattern[]=*webpack*

registry=https://registry.npmjs.org

strict-peer-dependencies=false

# Skip binary downloads
redis-memory-server_binary_skip_download=true
mongodb-memory-server_binary_skip_download=true

# Disable postinstall scripts
ignore-scripts=true
EOL

echo "Created .npmrc with ignore-scripts=true to skip problematic postinstall scripts"
echo "Now run 'pnpm i --no-optional' to install dependencies without running postinstall scripts" 