#!/bin/sh
INPUT=$1
XLD="/Users/monty/Library/Scripts/xld"
AP="/Users/monty/Library/Scripts/ap"
ITUNES="/Users/monty/Music/iTunes/Media/Automatically Add to iTunes/"

if [ -z "$INPUT" ]; then
    echo "Please specify the INPUT directory"
    exit 1;
fi

# Create a temprary directory
BASE=`basename $0`
TMPDIR=`mktemp -d /tmp/${BASE}.XXXX` || exit 1

# Convert the files from FLAC to AAC
find "$INPUT" -iname "*mp3" -execdir $XLD -f aac {} -o "$TMPDIR" \;

# Remove encoding atoms and move to ITUNES 
find "$TMPDIR" -iname "*m4a" -execdir $AP {} --encodingTool "" --encodedBy "" --overWrite \; -execdir mv {} "$ITUNES" \;

# Remove the temporary directory
rm -rf "$TMPDIR"