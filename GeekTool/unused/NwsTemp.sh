#!/bin/sh
TEMP=`grep Temperature /tmp/geektool/nws.txt | awk 'BEGIN{FS=";";}{printf "%s\n",$2,"\n";}'`
if [ ! -z "$COND" ]; then
    echo "$TEMP"
fi