#!/bin/bash

# Set up preferences

# Prerequisites:
# $XDG_CONFIG_HOME set
# Dotfiles installed
# iTerm2 installed

GIT_DIR="$HOME/git"
BOOTSTRAP_REPO_NAME="bootstrap"

# MAC PREFERENCES

# Keyboard remapping
mkdir -p "$HOME/Library/LaunchAgents"
cp "$GIT_DIR/$BOOTSTRAP_REPO_NAME/com.local.KeyRemapping.plist" \
    "$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"

# Disable the Character Accent Menu and Enable Key Repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false 


# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain KeyRepeat -int 1

# Full Keyboard Access
# In windows and dialogs, press Tab to move keyboard focus between:
# 1 : Text boxes and lists only
# 3 : All controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Don't use smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable tap to click for the trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad haptic feedback
# 0: Light
# 1: Medium
# 2: Firm
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Increase trackpad speed (0.0 - 3.0 is normal range)
defaults write -globalDomain com.apple.trackpad.scaling -float 5.0

# Move spaces when opening an App
defaults write -g AppleSpacesSwitchOnActivate -bool true

# Set 'home' as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"

# Remove items from the trash after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Save screenshots to Downloads
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show battery remaining time?
defaults write com.apple.menuextra.battery ShowTime -string "YES"

# APP PREFERENCES

# Use plain text for TextEdit app
defaults write com.apple.TextEdit RichText -bool false

# Enable the Develop menu and the Web Inspector in Safari (doesn't work anymore?)
defaults write com.apple.safari IncludeDevelopMenu -bool true
defaults write com.apple.safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.safari com.apple.safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
