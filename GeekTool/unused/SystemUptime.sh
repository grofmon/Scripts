#!/bin/sh
uptime | sed 's/,//g' | awk '{print "UPTIME: " $3 " " $4 ", " $5 " hours" }'
echo ""
top -l 1 | awk '/PhysMem/ {print "RAM: " $8 " " $9 " " $10 " " $11 }'
top -l 1 | awk '/CPU usage/ {print "CPU: " $3 " " $4 " " $5 " " $6 " " $7 " " $8 }'
