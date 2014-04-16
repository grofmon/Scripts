#!/bin/sh

SCRIPT="/Users/monty/Library/Scripts/NetworkSettings.scpt"

# Enable/disable EchoStar network settings
# Pass argument 'clear' to remove settings

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT" $@
else
    echo "$SCRIPT script not found"
fi
