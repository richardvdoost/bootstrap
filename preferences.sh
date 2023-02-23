#!/bin/bash

# Set up preferences

# Prerequisites:
# $XDG_CONFIG_HOME set
# Dotfiles installed
# iTerm2 installed


# Keyboard remapping launch file
mkdir -p "$HOME/Library/LaunchAgents"
cp com.local.KeyRemapping.plist "$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"



# MAC PREFERENCES

# Disable the Character Accent Menu and Enable Key Repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false" 


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



# APP PREFERENCES

# Use plain text for TextEdit app
defaults write com.apple.TextEdit "RichText" -bool "false"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Make iTerm2 icon look clean (swag the Mac Terminal icon)
cp /Applications/iTerm.app/Contents/Resources/AppIcon.icns /Applications/iTerm.app/Contents/Resources/AppIcon.icns.orig
cp /System/Applications/Utilities/Terminal.app/Contents/Resources/Terminal.icns /Applications/iTerm.app/Contents/Resources/AppIcon.icns

