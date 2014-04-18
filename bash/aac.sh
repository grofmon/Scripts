#!/bin/sh
INPUT=$1
XLD="/Users/monty/Dropbox/Scripts/xld"
AP="/Users/monty/Dropbox/Scripts/ap"
OUTDIR="/Users/monty/Downloads/"

if [ ! -z "$2" ]; then
    mkdir -p $OUTDIR"$2"
    OUTDIR=$OUTDIR"$2"
    echo "$OUTDIR"
fi

if [ -z "$INPUT" ]; then
    echo "Please specify the INPUT directory"
    exit 1;
fi

# Create a temprary directory
BASE=`basename $0`
TMPDIR=`mktemp -d /tmp/${BASE}.XXXX` || exit 1

# Convert the files from FLAC to AAC
find "$INPUT" -type f \( -iname "*.flac" -o -iname "*.mp3" \) -execdir $XLD -f aac {} -o "$TMPDIR" \;

# Remove encoding atoms and move to ITUNES 
find "$TMPDIR" -iname "*m4a" -exec $AP {} --encodingTool "" --encodedBy "" --overWrite \;

chown monty:staff $TMPDIR/*.m4a
mv $TMPDIR/*.m4a "$OUTDIR"

# Remove the temporary directory
rm -rf "$TMPDIR"