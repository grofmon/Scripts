#!/bin/bash
SRC="/Users/lori/Music/Archos/"
DST="/Volumes/POCKETDISH/Music/"

time rsync -vau --delete --exclude ".*" "${SRC}" "${DST}"
