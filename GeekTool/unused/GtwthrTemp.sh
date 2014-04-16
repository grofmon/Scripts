#!/bin/sh

TEMP=`curl http://gtwthr.com/USCO0105/temp`

if [ ! -z $TEMP ]; then
    echo "$TEMP °F"
fi
