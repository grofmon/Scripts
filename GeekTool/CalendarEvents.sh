#!/bin/sh

CALFILE=/tmp/geektool/calendar-data

rm $CALFILE

/usr/local/bin/icalBuddy -eep notes -n eventsToday > $CALFILE 

count=`wc -l $CALFILE | sed 's/[^0-9]//g'`
if [ $count = 0 ]; then
    echo ""
    echo ""
    echo ""
    echo "   No Meetings to Attend"
elif [ $count = 6 ]; then
    echo ""
elif [ $count -lt 6 ]; then
    echo ""
    echo ""
fi

cat $CALFILE
