#!/bin/sh

SCRIPT="/Users/monty/Library/Scripts/FitnessApps.scpt"

# Load/unload work/home apps
# Pass argument 'clear' to unload

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT" $@
else
    echo "$SCRIPT script not found"
fi
