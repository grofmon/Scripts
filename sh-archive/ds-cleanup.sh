#!/bin/sh
# Remove all .DS_Store files

LOG=/Users/monty/Library/Logs/ds-cleanup.log

echo `date` > $LOG
echo "Remove .DS_Store files" >> $LOG
echo "" >> $LOG
find -x / -name .DS_Store -print -delete 2>&1 >> $LOG
echo ".DS_Store cleanup complete..." >> $LOG
echo "" >> $LOG
echo `date` >> $LOG


#cat $LOG | mail -s "ds-cleanup run success" montgomery.groff@echostar.com -c monty@Ray.local
