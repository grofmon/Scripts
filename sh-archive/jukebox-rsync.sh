#!/bin/bash
SRC="/Users/lori/Music/Archos/"
DST="/Volumes/Jukebox/Music/"

time rsync -va --delete --exclude ".*" "${SRC}" "${DST}"
