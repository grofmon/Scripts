#!/bin/sh
EVENTS=`/usr/local/bin/icalBuddy -n eventsToday`

TODO=`/usr/local/bin/icalBuddy uncompletedTasks`

# Print the event list
if [ ! -z "$EVENTS" ]; then
    echo "Today's Meetings"
    echo "- - - - - - - - - - - - -"
    /usr/local/bin/icalBuddy eventsToday 
    echo ""
fi

# Print the ToDo list
if [ ! -z "$TODO" ]; then
    echo "ToDo List"
    echo "- - - - - - - - - - - - -"
    /usr/local/bin/icalBuddy uncompletedTasks
    #Add the following to filter out the medium and low priority tasks
     #| grep -v "36mpriority.*medium" | grep -v "36mpriority.*low"
fi