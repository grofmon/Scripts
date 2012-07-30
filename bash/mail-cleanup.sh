#!/bin/sh
# Cleanup mailboxes

SCRIPT="/Users/monty/Library/Scripts/MailCleanup.scpt"

# Cleanup Gmail by deleting messages older than 15 days
# 1. newsletters
# 2. support-org
# 3. political
# 4. denver-trail-runners


if [ -f "$SCRIPT" ]; then
    osascript "$SCRIPT"
else
    echo "$SCRIPT script not found"
fi
