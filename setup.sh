#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

# Create symbolic links for .npmrc and pnpm-workspace.yaml
ln -sf foundry_scripts/.npmrc .npmrc
ln -sf foundry_scripts/pnpm-workspace.yaml pnpm-workspace.yaml

if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y curl
fi

if ! command -v nvm &> /dev/null; then
    echo "nvm is not installed. Installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install and activate node first (needed for npm)
nvm install node
nvm use node

if ! command -v pnpm &> /dev/null; then
    echo "pnpm is not installed. Installing..."
    npm install -g pnpm@latest-10
fi

echo "Ensuring dependencies..."
pnpm install

echo Setup finished. You probably need to call
echo . ~/.bashrc
echo to refresh your current terminal.
