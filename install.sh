#!/bin/bash

# This script can run from a curl one-liner, will clone the rest of
# the repo into a proper location

# Settings
HOSTNAME="mp-pro"
GITHUB_USERNAME="richardvdoost"
BOOTSTRAP_REPO_NAME="bootstrap"

SSH_DIR="$HOME/.ssh"
GIT_DIR="$HOME/git"

set -eu

# Utils
GREEN='\033[0;32m'
NC='\033[0m' # No Color
green_echo()(echo; echo -e "==> ${GREEN}$1${NC}")

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail when not using bash
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

green_echo "STARTING MAC SETUP"; echo
echo "This script will set up command line tools, ssh, git,"
echo "install all homebrew packages from the Brewfile,"
echo "set up the Mac preferences, and App preferences."
echo "And finally restart."

# Ask password upfront and keep alive
# https://github.com/joshukraine/mac-bootstrap/blob/master/bootstrap#L88
sudo -v
while :; do
    sudo -n true
    caffeinate -id sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

green_echo "INSTALL ALL AVAILABLE UPDATES"
sudo softwareupdate -ia --verbose

# Install Xcode command line tools
if ! $(xcode-select -p &>/dev/null); then
    xcode-select --install &>/dev/null
    # Wait until the Xcode command line tools are installed
    until $(xcode-select -p &>/dev/null); do
        sleep 5
    done

    # Enable command line tools
    sudo xcode-select --switch /Library/Developer/CommandLineTools
fi

# Set the computer hostname
sudo scutil --set HostName $HOSTNAME

# Ensure we have SSH keys
mkdir -p "$SSH_DIR"
ID_RSA_FILE="$SSH_DIR/id_rsa"
if [ ! -f "$ID_RSA_FILE" ]; then
	green_echo "CREATING NEW SSH KEYS"
	ssh-keygen -b 4096 -t rsa -f "$ID_RSA_FILE" -q -N ""
fi

green_echo "CHECKING GITHUB SSH ACCESS"
if ! ssh -T git@github.com 2>&1 | grep 'success' &> /dev/null; then
	GITHUB_SSH=false
	echo "No access, SSH key needs to be set up at github.com"
	pbcopy < "$ID_RSA_FILE.pub"
	open "https://github.com/settings/ssh/new"
	say "Log into Github and paste the public SSH key please"
else
	GITHUB_SSH=true
	echo "All good"
fi

green_echo "CHECK HOMEBREW STATUS"
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Brew to the path
	if ! command -v brew &> /dev/null; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
else
	echo "All good"
fi

# Install Homebrew Bundle
green_echo "INSTALL HOMEBREW BUNDLE"
brew tap Homebrew/bundle
brew update
brew upgrade

# Wait until Github SSH is working
if ! $GITHUB_SSH; then
	green_echo "VERIFYING GITHUB SSH ACCESS"
	while :; do
		ssh -T git@github.com 2>&1 | grep 'success' &> /dev/null && break
		echo -n .
		sleep 10
	done
	echo
fi

green_echo "ENSURE BOOTSTRAP REPOSITORY IS PULLED AND UPDATED"
mkdir -p "$GIT_DIR"
BOOTSTRAP_DIR="$GIT_DIR/$BOOTSTRAP_REPO_NAME"
if [ -d "$BOOTSTRAP_DIR" ]
then
	echo "Refreshing the Bootstrap repository"
	cd "$BOOTSTRAP_DIR"
	git pull
	cd "$HOME"
else
	echo "Cloning the entire Bootstrap repository"
	cd "$GIT_DIR"
	git clone "git@github.com:$GITHUB_USERNAME/$BOOTSTRAP_REPO_NAME"
	cd $HOME
fi

green_echo "INSTALLING ALL HOMEBREW PACKAGES"
brew bundle --no-upgrade --file "$BOOTSTRAP_DIR/Brewfile"
brew cleanup

green_echo "SET PREFERENCES"
"$BOOTSTRAP_DIR/preferences.sh"

green_echo "SETUP THE DOCK"
cd "$BOOTSTRAP_DIR"
./dock-setup.sh
cd "$HOME"

green_echo "DOWNLOADING AND INSTALLING DOTFILE CONFIGS"
if [ -d "$GIT_DIR/home" ]
then
	echo "Refreshing the Home repository"
	cd "$GIT_DIR/home"
	git pull
	cd "$HOME"
else
	echo "Cloning the entire Home repository"
	cd "$GIT_DIR"
	git clone git@github.com:richardvdoost/home
	cd $HOME
fi
cd "$GIT_DIR/home"
./install.sh
cd "$HOME"

# TODO Set up cron jobs

green_echo "ALL DONE - REBOOTING"
sudo reboot
