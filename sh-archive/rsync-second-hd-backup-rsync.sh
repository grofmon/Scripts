#!/bin/bash
 SRC="/Volumes/SecondHD/"
 DST="/Volumes/SecBackup/"

 # Second HD using rsync
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC}" "${DST}"

# # Just the home directory using psync
# time psync -p -d "${SRC}" "${DST}"

## To use Apple's rsync switch commented lines below
#  # To use rsyncx:
#  RSYNC="/usr/local/bin/rsync --eahfs --showtogo" 
#  # To use built-in rsync (OS X 10.4 and later):
#  # RSYNC=/usr/bin/rsync -E
#  
#  # sudo runs the backup as root
#  # --eahfs enables HFS+ mode
#  # -a turns on archive mode (recursive copy + retain attributes)
#  # -x don't cross device boundaries (ignore mounted volumes)
#  # -S handle sparse files efficiently
#  # --showtogo shows the number of files left to process
#  # --delete deletes any files that have been deleted locally
#  # $* expands to any extra command line options you may give
#
#  sudo $RSYNC -n -a -x -S --delete \
#    --exclude-from excludes.txt $* / /Volumes/Backup/
#
#  # make the backup bootable - comment this out if needed
#
#  sudo bless -folder /Volumes/Backup/System/Library/CoreServices


