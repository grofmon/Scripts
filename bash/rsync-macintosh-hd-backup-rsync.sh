#!/bin/bash
 SRC1="/Users/lori/Applications/"
 SRC2="/Users/lori/Desktop/"
 SRC3="/Users/lori/Documents/"
 SRC4="/Users/lori/Library/"
 SRC5="/Users/lori/Movies/"
 SRC6="/Users/lori/Music/"
 SRC7="/Users/lori/Pictures/"
 SRC8="/Users/lori/Public/"
 SRC9="/Users/lori/Sites/"
 SRC10="/Users/monty/"
 SRC11="/Users/Shared/"
 DST1="/Volumes/MacBackup/Users/lori/Applications/"
 DST2="/Volumes/MacBackup/Users/lori/Desktop/"
 DST3="/Volumes/MacBackup/Users/lori/Documents/"
 DST4="/Volumes/MacBackup/Users/lori/Library/"
 DST5="/Volumes/MacBackup/Users/lori/Movies/"
 DST6="/Volumes/MacBackup/Users/lori/Music/"
 DST7="/Volumes/MacBackup/Users/lori/Pictures/"
 DST8="/Volumes/MacBackup/Users/lori/Public/"
 DST9="/Volumes/MacBackup/Users/lori/Sites/"
 DST10="/Volumes/MacBackup/Users/monty/"
 DST11="/Volumes/MacBackup/Users/Shared/"

 # Just the home directory using rsync
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC1}" "${DST1}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC2}" "${DST2}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC3}" "${DST3}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC4}" "${DST4}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC5}" "${DST5}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC6}" "${DST6}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC7}" "${DST7}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC8}" "${DST8}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC9}" "${DST9}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC10}" "${DST10}"
 sudo rsync -vv --stats --archive --update --sparse --delete \
            --temp-dir=/tmp --exclude-from excludes.txt \
            $* "${SRC11}" "${DST11}"

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


