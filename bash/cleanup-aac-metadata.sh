#!/bin/sh
INPUT=$1
AP="/Users/monty/Library/Mobile Documents/com~apple~ScriptEditor2/Documents/bin/ap"

if [ -z "$INPUT" ]; then
    echo "Please specify the INPUT directory"
    exit 1;
fi

# Remove encoding atoms and move to ITUNES 
find "$INPUT" -iname "*m4a" -execdir $AP {} --encodingTool "" --encodedBy "" --overWrite \;
echo
echo done!