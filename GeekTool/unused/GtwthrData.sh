#!/bin/sh
sunrise=`curl http://gtwthr.com/USCO0065/sunrise`
sunset=`curl http://gtwthr.com/USCO0065/sunset`
wind_s=`curl http://gtwthr.com/USCO0065/wind_s`
wind_d=`curl http://gtwthr.com/USCO0065/wind_d`
obst=`curl http://gtwthr.com/USCO0065/obst`
time=`curl http://gtwthr.com/USCO0065/time`
cond=`curl http://gtwthr.com/USCO0065/cond`
temp=`curl http://gtwthr.com/USCO0065/temp`
flike=`curl http://gtwthr.com/USCO0065/flike`
day1_l=`curl http://gtwthr.com/USCO0065/day1_l`
day1_h=`curl http://gtwthr.com/USCO0065/day1_h`
day1_day_cond=`curl http://gtwthr.com/USCO0065/day1_day_cond`
day1_day_ppcp=`curl http://gtwthr.com/USCO0065/day1_day_ppcp`

if [ ! -z $temp ]; then
    echo "Conditions from $obst at $time"
    echo "$temp deg, Feels like $flike deg"
    echo "$cond"
    echo "Wind from the $wind_d at $wind_s MPH"
    echo "Sunrise : $sunrise"
    echo "Sunset  : $sunset"
    echo ""
    echo "Tomorrows Forecast:"
    echo "Low $day1_l; High $day1_h"
    echo "$day1_day_cond"
    echo "Precip: $day1_day_ppcp"
fi
