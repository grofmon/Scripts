#!/bin/sh

# Remove encoding atoms and move to iTunes 
find . -iname "*m4a" -execdir /usr/local/bin/ap {} --encodingTool "" --encodedBy "" --output ~/Music/iTunes/Media/Automatically\ Add\ to\ iTunes/{} \; -execdir mv {} ~/.Trash \;

