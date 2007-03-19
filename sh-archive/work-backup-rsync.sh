#!/bin/bash
SRC="/Volumes/Work/"
DST="/Volumes/PORTABLE/Work/"

if [ ! -d $DST ]; then
    echo "Destination ($DST) not mounted"
    exit 1
elif [ ! -d $SRC ]; then
    echo "Source ($SRC) not mounted"
    exit 1
else
    time rsync -va --delete --exclude ".DS_Store" --exclude ".Trashes" "${SRC}" "${DST}"
fi
