#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

# Update git submodule
git submodule update --remote

# Use latest node
nvm use node

# Update npm packages
npm update
