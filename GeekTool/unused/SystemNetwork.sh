#!/bin/sh
air_file="/tmp/geektool/airport.txt"
system_profiler SPAirPortDataType > $air_file

SSID=`cat $air_file | grep -A 2 -e "Current Network Information:" | tr '\n' ' ' | tr ':' ' ' | awk '{print $4}'`
CHANNEL=`cat $air_file | grep -e "Channel: " | awk '{print $2}'`
SECURITY=`cat $air_file | grep -e "Security: " | awk '{print $2 " " $3 " " $4}'`
WIRED=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
WIRELESS=`ifconfig en1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

if [ -z "$WIRED" ]; then
    echo "Wired     : INACTIVE"
else
    echo "Wired     : $WIRED"
fi

if [ -z "$WIRELESS" ]; then
    echo "Airport   : INACTIVE"
else
    echo "Wireless  : $WIRELESS" 
    echo " SSID     : $SSID"
    echo " Security : $SECURITY"
    echo " Channel  : $CHANNEL"
fi