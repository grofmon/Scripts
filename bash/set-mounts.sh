#!/bin/sh

SCRIPT="/Users/monty/Library/Scripts/MountEchostar.scpt"

# Mount/unmount EchoStar networked drives
# Pass argument 'clear' to unmount

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT" $@
else
    echo "$SCRIPT script not found"
fi
