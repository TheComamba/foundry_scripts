#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

# detect real user/home (handles running under sudo)
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
else
    TARGET_USER="$(whoami)"
    TARGET_HOME="$HOME"
fi

# Make nvm available in the shell (use the target user's home)
export NVM_DIR="${NVM_DIR:-$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${TARGET_HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")}"

echo "Running as: $TARGET_USER (HOME=$TARGET_HOME)"
echo "Using NVM_DIR: $NVM_DIR"

# try to source nvm from common locations
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    . "/usr/local/opt/nvm/nvm.sh"
elif [ -s "$TARGET_HOME/.nvm/nvm.sh" ]; then
    . "$TARGET_HOME/.nvm/nvm.sh"
elif [ -s "$TARGET_HOME/.bashrc" ]; then
    # some installs source nvm from bashrc
    # shellcheck disable=SC1090
    . "$TARGET_HOME/.bashrc"
else
    echo "nvm not found. Ensure nvm is installed or run the script as your user (avoid sudo)." >&2
    exit 1
fi

# verify nvm loaded
if ! command -v nvm >/dev/null 2>&1; then
    echo "nvm loaded but not available in this shell." >&2
    exit 1
fi

# Use latest node (install if missing)
nvm use node || nvm install node

# Update npm packages
pnpm update

# Update git submodule (this is the last step, in order not to interfere with the script that is currently being executed.)
git submodule update --remote
