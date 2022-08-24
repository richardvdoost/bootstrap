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

echo "test"

# Install Command Line Tools (CLT) for Xcode
# xcode-select --install

# Install Brew

# Download all dotfiles and link them?

# Install all Brewfile items

# Set all settings with defaults

