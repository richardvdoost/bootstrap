#!/bin/bash

# This script will run on its own from a curl one liner, will clone the rest of
# the repo into a proper location

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

echo "Bootstrapping this Mac on autopilot"

# Ask password upfront and keep alive
# https://github.com/joshukraine/mac-bootstrap/blob/master/bootstrap#L88
echo "Please authenticate"
sudo -v
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Install Command Line Tools (CLT) for Xcode if needed
if ! xcode-select -v &> /dev/null; then
    echo "Installing XCode Commad Line Tools..."
    xcode-select --install
    sudo xcodebuild -license accept
else
    echo "XCode Commad Line Tools were already installed"
fi

# Install Brew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew was already installed - Updating..."
    brew update
fi

# Clone some important repositories

# Download all dotfiles and link them?

# Install all Brewfile items

# Set all settings with defaults

