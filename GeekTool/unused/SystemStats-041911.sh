#!/bin/sh
air_file="/tmp/geektool/airport.txt"
system_profiler SPAirPortDataType > $air_file

if [ ! -d /tmp/geektool ]; then
    mkdir /tmp/geektool
fi

# Get the battery state
BAT=`ioreg -l | grep -i capacity | tr '\n' ' | ' | awk '{printf("%.2f%%", $10/$5 * 100)}'`

# Get the wired ethernet ip address
WIRED=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

# Get the wireless ethernet ip address
WIRELESS=`ifconfig en1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
# Get the wireless access point ssid
SSID=`cat $air_file | grep -A 2 -e "Current Network Information:" | tr '\n' ' ' | tr ':' ' ' | awk '{print $4}'`
# Get the wireless access point channel
CHANNEL=`cat $air_file | grep -e "Channel: " | awk '{print $2}'`
# Get the wireless access point security type
SECURITY=`cat $air_file | grep -e "Security: " | awk '{print $2 " " $3 " " $4}'`

if [ -z "$WIRED" ]; then
    WIRED="DISCONNECTED"
fi

if [ -z "$WIRELESS" ]; then
    WIRELESS="DISCONNECTED"
fi

# get the current number of bytes in and bytes out
myvar1=`netstat -ib | grep -e "en1" -m 1 | awk '{print $7}'` #  bytes in
myvar3=`netstat -ib | grep -e "en1" -m 1 | awk '{print $10}'` # bytes out

#wait one second
sleep 1

# get the number of bytes in and out one second later
myvar2=`netstat -ib | grep -e "en1" -m 1 | awk '{print $7}'` # bytes in again
myvar4=`netstat -ib | grep -e "en1" -m 1 | awk '{print $10}'` # bytes out again

# find the difference between bytes in and out during that one second
subin=$(($myvar2 - $myvar1))
subout=$(($myvar4 - $myvar3))

# convert bytes to kilobytes
KBIN=`echo "scale=2; $subin/1024;" | bc`
KBOUT=`echo "scale=2; $subout/1024;" | bc`

# Get the current uptime
UPTIME=`uptime | sed 's/,//g' | awk '{print "UPTIME: " $3 " " $4 ", " $5 " hours" }'`
# Get the current RAM usage
RAM=`top -l 1 | awk '/PhysMem/ {print "RAM: " $8 " " $9 " " $10 " " $11 }'`
# Get the current CPU usage
CPU=`top -l 1 | awk '/CPU usage/ {print "CPU: " $3 " " $4 " " $5 " " $6 " " $7 " " $8 }'`

# Print the results
echo "Battery   : $BAT"
echo "Wired     : $WIRED"
echo "Wireless  : $WIRELESS" 
if [ "$WIRELESS" != "DISCONNECTED" ]; then
echo " SSID     : $SSID"
echo " Security : $SECURITY"
echo " Channel  : $CHANNEL"
fi
echo "Data recv: $KBIN Kb/sec"
echo "Data sent: $KBOUT Kb/sec"
echo $UPTIME
echo $RAM
echo $CPU