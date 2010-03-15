#!/bin/sh

# Sync all data from Documents dir (except Virtual Machines) to MobileMe iDisk

LOG=/Volumes/Joan/Users/lori/Downloads/idisk.log
EXCLUDE=/Volumes/Joan/Users/lori/bin/iDisk-Backup-excludes.txt

SRC=/Volumes/Joan/Users/Lori/Documents/
DST=/Volumes/iDisk/Documents/

echo `date` > $LOG
echo "Starting copy of Documents to iDisk..." >> $LOG

rsync -auv4E --exclude-from=$EXCLUDE --stats --progress $SRC $DST >> $LOG

echo "Backup of Documents to iDisk complete..." >> $LOG
echo "" >> $LOG
echo `date` >> $LOG

exit 0