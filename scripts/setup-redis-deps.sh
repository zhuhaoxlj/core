#!/bin/bash

# Script to install dependencies for Redis Memory Server on Ubuntu
echo "Installing dependencies for Redis Memory Server..."

# Update package lists
sudo apt-get update

# Install required packages for Redis compilation
sudo apt-get install -y build-essential tcl libjemalloc-dev

# Set memory overcommit parameter required by Redis
echo "Setting vm.overcommit_memory=1..."
echo vm.overcommit_memory=1 | sudo tee -a /etc/sysctl.conf
sudo sysctl vm.overcommit_memory=1

echo "Dependencies installed successfully!"
echo "You can now run 'pnpm i' to install project dependencies." 