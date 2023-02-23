#!/bin/bash

# This script will run on its own from a curl one liner, will clone the rest of
# the repo into a proper location

set -euxo pipefail

GIT_DIR="$HOME/git"
BOOTSTRAP_DIR="$GIT_DIR/bootstrap"

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# TODO: Use caffeinate to keep it awake

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
    caffeinate -id sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

: Install all available updates
sudo softwareupdate -ia --verbose

: Install Xcode Command Line Tools
if ! $(xcode-select -p &>/dev/null); then
    xcode-select --install &>/dev/null

    : Wait until the Xcode Command Line Tools are installed
    until $(xcode-select -p &>/dev/null); do
        sleep 10
    done
fi

sudo xcode-select --switch /Library/Developer/CommandLineTools # Enable command line tools

: Accept the Xcode/iOS license agreement
if ! $(sudo xcodebuild -license status); then
  sudo xcodebuild -license accept
fi

: Clone this repo
mkdir -p "$GIT_DIR"
cd "$GIT_DIR"
git clone https://github.com/richardvdoost/bootstrap

: Install Brew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

: Install Homebrew Bundle
brew tap Homebrew/bundle
brew update
brew upgrade

: Install all Homebrew software
brew bundle --file "$BOOTSTRAP_DIR/Brewfile"

: Remove outdated versions from the cellar including casks
brew cleanup
brew prune

: Set all preferences and setup the Dock
cd "$BOOTSTRAP_DIR"
./preferences.sh
./dock-setup.sh
cd "$HOME"

# Download all dotfiles and link them?

# Download more git repos

# Set up cron jobs
