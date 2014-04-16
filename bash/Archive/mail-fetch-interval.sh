#!/bin/sh

#SCRIPT="/Users/monty/Library/Scripts/Mail/MailFetchInterval.scpt"

if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT"
else
    echo "$SCRIPT script not found"
fi
