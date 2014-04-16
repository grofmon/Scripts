#!/bin/sh

TODOFILE=/tmp/geektool/todo-data

rm $TODOFILE

/usr/local/bin/icalBuddy uncompletedTasks > $TODOFILE

count=`wc -l $TODOFILE | sed 's/[^0-9]//g'`
if [ $count = 0 ]; then
    echo ""
    echo ""
    echo ""
    echo "    Nothing ToDo Today"
elif [ $count = 6 ]; then
    echo ""
elif [ $count -lt 6 ]; then
    echo ""
    echo ""
fi

cat $TODOFILE

