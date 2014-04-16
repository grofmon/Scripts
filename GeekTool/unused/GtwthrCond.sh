#!/bin/sh

COND=`curl http://gtwthr.com/USCO0105/cond`

if [ ! -z "$COND" ]; then
    echo "$COND"
fi
