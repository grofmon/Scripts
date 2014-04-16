#!/bin/sh
air_file="/tmp/geektool/airport.txt"
system_profiler SPAirPortDataType > $air_file

if [ ! -d /tmp/geektool ]; then
    mkdir /tmp/geektool
fi

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

INTF0=en0
INTF1=en1

# get the current number of bytes in and bytes out
en01=(`/usr/sbin/netstat -ib -I en0 | awk "/$INTF0/"'{print $7" "$10; exit}'`)
en11=(`/usr/sbin/netstat -ib -I en1 | awk "/$INTF1/"'{print $7" "$10; exit}'`)

# wait one second
sleep 1

# get the number of bytes in and out one second later
en02=(`/usr/sbin/netstat -ib -I en0 | awk "/$INTF0/"'{print $7" "$10; exit}'`)
en12=(`/usr/sbin/netstat -ib -I en1 | awk "/$INTF1/"'{print $7" "$10; exit}'`)

# find the difference between bytes in and out during that one second
# and convert bytes to kilobytes
sample1=(`echo "2k ${en01[0]} ${en11[0]} + p ${en01[1]} ${en11[1]} + p" | dc`)
sample2=(`echo "2k ${en02[0]} ${en12[0]} + p ${en02[1]} ${en12[1]} + p" | dc`)

results=(`echo "2k ${sample2[0]} ${sample1[0]} - 1024 / p" \
      "${sample2[1]} ${sample1[1]} - 1024 / p" | dc`)


# Print the results
if [ "$WIRELESS" = "DISCONNECTED" ]; then
echo ""
echo ""
fi
#if [ "$WIRELESS" = "DISCONNECTED" -a "$WIRED" = "DISCONNECTED" ]; then
#echo ""
#fi


if [ "$WIRED" = "DISCONNECTED" ]; then
    echo ""
else
    printf "\033[1;37mWired: \033[32m%s\n" "$WIRED"
fi
if [ "$WIRELESS" = "DISCONNECTED" ]; then
echo "" 
else
    printf "\033[1;37mWireless: \033[32m%s\n\033[1;37m-SSID: \033[36m%s\n\033[1;37m-Security: \033[36m%s\n\033[1;37m-Channel: \033[36m%s\n" "$WIRELESS" "$SSID" "$SECURITY" "$CHANNEL"
fi
if [ "$WIRED" != "DISCONNECTED" -o "$WIRELESS" != "DISCONNECTED" ]; then
    printf "\033[1;37mData in: \033[35m%.2f \033[1;37mKb/sec\nData out: \033[35m%.2f \033[1;37mKb/sec\n" ${results[0]} ${results[1]}
else
echo "No Network Connection"
fi