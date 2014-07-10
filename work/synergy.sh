#!/bin/bash

server="$1" # the server
running=`ps ax | grep -v grep | grep synergyc`

if [ "$1" = "kill" ]; then
    echo "Stopping synergy client..."
    killall -9 synergyc
elif [ "${#running}" -gt 0 ]; then
    echo "Synergy already started, stopping..."
    killall -9 synergyc
fi

if [ "$1" != "kill" ]; then
    echo "Starting synergy client..."
    synergyc --restart -n Suse $server > /dev/null 2>&1
fi
