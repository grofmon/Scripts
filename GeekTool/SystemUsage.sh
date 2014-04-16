#!/bin/sh
# Get the battery state
BAT=`ioreg -l | grep -i capacity | tr '\n' ' | ' | awk '{printf("%.2f", $10/$5 * 100)}'`

# Get the current uptime
#UPTIME=`uptime | sed 's/,//g' | awk '{print "UPTIME: " $3 " " $4 ", " $5 " hours" }'`
UPTIME=`uptime | cut -d "p" -f 2 | sed 's/[0-9]\ user.*//g' | sed 's/,//g'`

# Get the current RAM usage
#RAM=`top -l 1 | awk '/PhysMem/ {print "RAM: " $8 " " $9 " " $10 " " $11 }'`
# Get the current CPU usage
#CPU=`top -l 1 | awk '/CPU usage/ {print "CPU: " $3 " " $4 " " $5 " " $6 " " $7 " " $8 }'`

LOW=20.00
FULL=90.00
CHARGE=`echo "$BAT $LOW $FULL" | awk '{if($1 < $2) print "RED"; else if($1 > $3) print "GREEN"; else print "YELLOW"}'`

# Print the results
if [ "$CHARGE" = "GREEN" ]; then
# Green
    printf "\033[1;37mBattery: \033[32m%s%%\n" "$BAT"
elif [ "$CHARGE" = "RED" ]; then
    printf "\033[1;37mBattery: \033[31m%s%%\n" "$BAT"
else
    printf "\033[1;37mBattery: \033[33m%s%%\n" "$BAT"
fi
printf "\033[1;37mUptime:\033[35m%s\n" "$UPTIME"
#echo ""
#echo $RAM
#echo $CPU