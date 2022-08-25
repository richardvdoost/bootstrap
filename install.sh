#!/bin/bash

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

exit 0

# Install Command Line Tools (CLT) for Xcode
xcode-select --install

# Automatically agree to the Xcode licence

# Install Brew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone some important repositories

# Download all dotfiles and link them?

# Install all Brewfile items

# Set all settings with defaults

