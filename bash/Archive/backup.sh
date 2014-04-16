#!/bin/sh

PROG=$0
RSYNC="/usr/bin/rsync"
SRC="/"
DST="/Volumes/MacBook Pro Backup/"
EXCLUDE="$HOME/Library/Scripts/rsync_excludes.txt"

# -v increase verbosity
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -S handles spare files efficiently
# -H preserves hard-links
# --extended-attributes preserves ACLs and Resource Forks
# --delete deletes any files that have been deleted locally
# --delete-excluded deletes any files that are part of the list of excluded files
# --exclude-from reference a list of files to exclude

if [ ! -r "$SRC" ]; then
  /usr/bin/logger -t $PROG "Source $SRC not readable - Cannot start the sync process"
  exit;
fi

if [ ! -w "$DST" ]; then
  /usr/bin/logger -t $PROG "Destination $DST not writeable - Cannot start the sync process"
  exit;
fi

/usr/bin/logger -t $PROG "Start rsync"

sudo $RSYNC --dry-run -vax -S -H --extended-attributes --delete --exclude-from=$EXCLUDE --delete-excluded "$SRC" "$DST"

/usr/bin/logger -t $PROG "End rsync"

# make the backup bootable
#sudo bless -folder "$DST"/System/Library/CoreServices

exit 0