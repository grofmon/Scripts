!/bin/bash
SRC="/Volumes/Second HD/iTunes/"
DST=/Volumes/ARTISTS\;VANGOGH/

## Method using rsync
time rsync -vv --stats --archive --update --delete --exclude ".*" --exclude "Podcast*" "${SRC}" "${DST}"

## Method using psync
#time psync -p -d "${SRC}" "${DST}"
