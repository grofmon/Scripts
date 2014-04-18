#!/bin/sh
INPUT=$1
AP="/Users/monty/Library/Scripts/ap"
ITUNES="/Users/monty/Music/iTunes/Media/Automatically Add to iTunes/"

if [ -z "$INPUT" ]; then
    echo "Please specify the INPUT directory"
    exit 1;
fi

# Remove encoding atoms and move to ITUNES 
find "$INPUT" -iname "*m4a" -execdir $AP {} --encodingTool "" --encodedBy "" --overWrite \; -execdir mv {} "$ITUNES" \;
