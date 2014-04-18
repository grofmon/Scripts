#!/bin/sh
if [ "$1" = "kill" ]; then
    echo " Stopping synergy server"
    killall synergys
else
    echo "Starting synergy server"
    killall synergys > /dev/null 2>&1
    /Applications/Synergy.app/Contents/MacOS/synergys --name Herbie -c /Users/monty/Library/Scripts/synergy.conf > /dev/null 2>&1
    ip_addr=`ifconfig  | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'`
    echo "IP Addr: $ip_addr"
fi