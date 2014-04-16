#!/bin/bash
# First copy "Work Backup" from the portable to the SecondHD
SRC1="/Volumes/PORTABLE/Work Backup/"
DST1="/Volumes/SecondHD/Work Backup/"

time rsync -va --delete "${SRC1}" "${DST1}"

# Then copy SecondHD to the PORTABLE 
SRC2="/Volumes/SecondHD/"
DST2="/Volumes/PORTABLE/"

time rsync -va --delete --exclude ".*" "${SRC2}" "${DST2}"
