#!/bin/sh

SCRIPT="/Users/monty/Library/Scripts/AdiumProxy.scpt"

# Enable/disable Adium proxy server and start/stop SSH Tunnel Manager
# Pass argument 'clear' to clear/stop

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT" $@
else
    echo "$SCRIPT script not found"
fi
