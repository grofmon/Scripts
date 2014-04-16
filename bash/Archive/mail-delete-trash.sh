#!/bin/sh

#DELETE="/Users/monty/Library/Scripts/Mail/MailDeleteTrash.scpt"
#READ="/Users/monty/Library/Scripts/Mail/MailMarkTrashRead.scpt"

if [ -f "$READ" ]; then
    osascript "$READ"
else
    echo "$READ script not found"
fi
sleep 30
if [ -f "$DELETE" ]; then
    osascript "$DELETE"
else
    echo "$DELETE script not found"
fi
