#!/bin/sh
air_file="/tmp/geektool/airport.txt"
system_profiler SPAirPortDataType > $air_file

if [ ! -d /tmp/geektool ]; then
    mkdir /tmp/geektool
fi

BAT=`ioreg -l | grep -i capacity | tr '\n' ' | ' | awk '{printf("%.2f%%", $10/$5 * 100)}'`

echo "\033[33mBattery   : \033[36m$BAT\033[0m"
echo ""

SSID=`cat $air_file | grep -A 2 -e "Current Network Information:" | tr '\n' ' ' | tr ':' ' ' | awk '{print $4}'`
CHANNEL=`cat $air_file | grep -e "Channel: " | awk '{print $2}'`
SECURITY=`cat $air_file | grep -e "Security: " | awk '{print $2 " " $3 " " $4}'`
WIRED=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
WIRELESS=`ifconfig en1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

if [ -z "$WIRED" ]; then
    echo "Wired     : DISCONNECTED"
else
    echo "\033[33mWired     : \033[36m$WIRED\033[0m"
fi

if [ -z "$WIRELESS" ]; then
    echo "Wireless  : DISCONNECTED"
else
    echo "\033[33mWireless  : \033[36m$WIRELESS\033[0m" 
    echo " \033[33mSSID     : \033[35m$SSID\033[0m"
    echo " \033[33mSecurity : \033[35m$SECURITY\033[0m"
    echo " \033[33mChannel  : \033[35m$CHANNEL\033[0m"
fi
echo ""

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
kbin=`echo "scale=2; $subin/1024;" | bc`
kbout=`echo "scale=2; $subout/1024;" | bc`

# print the results
echo "\033[33mData recv: \033[36m$kbin \033[0mKb/sec"
echo "\033[33mData sent: \033[36m$kbout \033[0mKb/sec"
echo ""
uptime | sed 's/,//g' | awk '{print "\033[33mUPTIME: \033[36m" $3 " \033[0m" $4 ", \033[36m" $5 "\033[0m hours" }'
echo ""
top -l 1 | awk '/PhysMem/ {print "\033[33mRAM: \033[36m" $8 " \033[0m" $9 " \033[36m" $10 " \033[0m" $11 "\033[0m"}'
top -l 1 | awk '/CPU usage/ {print "\033[33mCPU: \033[36m" $3 " \033[0m" $4 " \033[36m" $5 " \033[0m" $6 " \033[36m" $7 " \033[0m" $8 "\033[0m"}'
