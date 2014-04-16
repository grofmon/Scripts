#!/bin/sh

SCRIPT="/Users/monty/Library/Scripts/MailFetchInterval.scpt"

# Set Mail fetch interval to 1/15 minutes
# Pass argument 'clear' to set to 15 minutes

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT" $@
else
    echo "$SCRIPT script not found"
fi
