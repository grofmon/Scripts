#!/bin/sh

PYTHON=/usr/bin/python
ULTIMATEWEATHER=~/Documents/Scripts/GeekTool/ultimateweather/ultimate_weather_parser.py
CURRENT=/tmp/geektool/usnws_current.txt

#US National Weather Service
#------------------------------
#Automatic Location: Current Weather Detailed Display
#$PYTHON $ULTIMATEWEATHER -B -C "georgetown" -S "colorado" -O "united states" -Z 80444 -Q full -T usnws -i current -s detailed > $CURRENT
$PYTHON $ULTIMATEWEATHER -A -L ipinfodb -Q full -T usnws -i current -s detailed > $CURRENT

CONDITION=`cat $CURRENT | grep Condition | cut -d: -f 2| sed -e 's/^[ \t]*//'`
TEMPERATURE=`cat $CURRENT | grep Temperature | cut -d: -f 2| sed -e 's/^[ \t]*//'`
DEWPOINT=`cat $CURRENT | grep "Dew Point" | cut -d: -f 2| sed -e 's/^[ \t]*//'`
HUMIDITY=`cat $CURRENT | grep Humidity | cut -d: -f 2| sed -e 's/^[ \t]*//'`
PRESSURE=`cat $CURRENT | grep Pressure | cut -d: -f 2| sed -e 's/^[ \t]*//'`
WIND=`cat $CURRENT | grep Wind | cut -d: -f 2| sed -e 's/^[ \t]*//'`
GUST=`cat $CURRENT | grep Gust | cut -d: -f 2| sed -e 's/^[ \t]*//'`
VISIBILITY=`cat $CURRENT | grep Visibility | cut -d: -f 2| sed -e 's/^[ \t]*//'`

echo "\033[32m    Condition : \033[37m$CONDITION"
echo "\033[32m Termperature : \033[37m$TEMPERATURE"
echo "\033[32m    Dew Point : \033[37m$DEWPOINT"
echo "\033[32m     Humidity : \033[37m$HUMIDITY"
echo "\033[32m     Pressure : \033[37m$PRESSURE"
echo "\033[32m         Wind : \033[37m$WIND"
if [ ! -z "`cat $CURRENT | grep Gust | cut -d: -f 2 | cut -c 3-`" ]; then
echo "\033[32m         Gust : \033[37m$GUST"
fi
echo "\033[32m   Visibility : \033[37m$VISIBILITY"
