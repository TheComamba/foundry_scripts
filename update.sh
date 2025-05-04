#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

# Update npm packages
npm update

# Update git ssubmodule
git submodule update --remote
