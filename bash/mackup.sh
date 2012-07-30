#!/bin/sh

#BACKUP_DATE=`date "+%m_%d_%Y_%H_%M_%S"`
#touch /Volumes/Backup/${BACKUP_DATE}.txt
#echo "Last backup: `date`" > /Volumes/Backup/${BACKUP_DATE}.txt

TIMESTAMP_FILE=/tmp/backup_timestamp.txt

function cp_ts_file {
   cp ${TIMESTAMP_FILE} /Volumes/MacBookPro/Users/monty
}

echo "########################" > $TIMESTAMP_FILE
echo "## Starting backup" >> $TIMESTAMP_FILE
echo "## `date`" >> $TIMESTAMP_FILE
echo ""

if [ ! -d "/Volumes/MacBookPro" ] ; then
echo "## !!! Error : Something went wrong the last time" >> $TIMESTAMP_FILE
echo "## " >> $TIMESTAMP_FILE
echo "## `date`" >> $TIMESTAMP_FILE
echo "## Backup failed" >> $TIMESTAMP_FILE
echo "########################" >> $TIMESTAMP_FILE
echo "" >> $TIMESTAMP_FILE
cp_ts_file
exit 1
fi

if [ -d "/Volumes/MacBookProBackup" ] ; then >> $TIMESTAMP_FILE
echo "## Backing up to destination volume /Volumes/MacBookProBackup" >> $TIMESTAMP_FILE
else
echo "## !!! Error : Destination volume absent" >> $TIMESTAMP_FILE
echo "## " >> $TIMESTAMP_FILE
echo "## `date`" >> $TIMESTAMP_FILE
echo "## Backup failed" >> $TIMESTAMP_FILE
echo "#########################" >> $TIMESTAMP_FILE
echo "" >> $TIMESTAMP_FILE
cp_ts_file
exit 1
fi

/usr/sbin/asr -erase -noprompt -source /Volumes/MacBookPro -target /Volumes/MacBookProBackup

/usr/sbin/diskutil rename /Volumes/MacBookPro\ 1 MacBookProBackup

echo "## `date`" >> $TIMESTAMP_FILE
echo "## End of backup" >> $TIMESTAMP_FILE
echo "#########################" >> $TIMESTAMP_FILE
echo "" >> $TIMESTAMP_FILE
cp_ts_file
cp $TIMESTAMP_FILE /Volumes/MacBookProBackup
rm $TIMESTAMP_FILE