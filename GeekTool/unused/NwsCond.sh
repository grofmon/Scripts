#!/bin/sh
COND=`grep Conditions /tmp/geektool/nws.txt | awk 'BEGIN{FS=";";}{printf "%s\n",$2,"\n";}'`
if [ ! -z "$COND" ]; then
    echo "$COND"
fi