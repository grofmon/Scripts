#!/bin/sh
EVNOTE="/tmp/geektool/evernote.txt"
rm $EVNOTE
osascript ~/Library/Scripts/GeekTool/Evernote.scpt
cat $EVNOTE
