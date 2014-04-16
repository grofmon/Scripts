#!/bin/sh

if [ "$1" = "on" ]; then
echo "Turning on iPhone backups"
defaults write com.apple.iTunes DeviceBackupsDisabled -bool false
else
echo "Turning off iPhone backups"
defaults write com.apple.iTunes DeviceBackupsDisabled -bool true
fi