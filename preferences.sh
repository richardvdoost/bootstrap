#!/bin/bash

# Set up preferences

# Prerequisites:
# $XDG_CONFIG_HOME set
# Dotfiles installed
# iTerm2 installed


# MAC PREFERENCES

# Disable the Character Accent Menu and Enable Key Repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Increase trackpad speed (0.0 - 3.0 is normal range)
defaults write -globalDomain com.apple.trackpad.scaling -float 5.0

# Keyboard remappings (Caps to Ctrl, Ctrl to Esc)
product_id=$(ioreg -c AppleEmbeddedKeyboard -r | sed -nE 's/^.*"ProductID" = ([0-9]+).*$/\1/p')
vendor_id=$(ioreg -c AppleEmbeddedKeyboard -r | sed -nE 's/^.*"VendorID" = ([0-9]+).*$/\1/p')
vendor_id_source=$(ioreg -c AppleEmbeddedKeyboard -r | sed -nE 's/^.*"VendorIDSource" = ([0-9]+).*$/\1/p')
defaults -currentHost write -globalDomain com.apple.keyboard.modifiermapping.${vendor_id}-${product_id}-${vendor_id_source} '(
        {
        HIDKeyboardModifierMappingDst = 30064771300;
        HIDKeyboardModifierMappingSrc = 30064771129;
    },
        {
        HIDKeyboardModifierMappingDst = 30064771113;
        HIDKeyboardModifierMappingSrc = 30064771300;
    },
        {
        HIDKeyboardModifierMappingDst = 30064771113;
        HIDKeyboardModifierMappingSrc = 30064771296;
    }
)'




# APP PREFERENCES

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

