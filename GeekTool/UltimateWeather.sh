#!/bin/sh

PYTHON=/usr/bin/python
ULTIMATEWEATHER=~/Library/Scripts/GeekTool/ultimateweather/ultimate_weather_parser.py
FORECAST=/tmp/geektool/usnws_forecast.txt
CURRENT=/tmp/geektool/usnws_current.txt
# Cleanup old images first
IMAGE_DIR=/tmp/geektool/images
# Check the directory first
if [ ! -d $IMAGE_DIR ]; then
    mkdir -p $IMAGE_DIR > /dev/null 2>&1
fi
rm $IMAGE_DIR/* > /dev/null 2>&1

#Yahoo! Weather Icon
#------------------------------
curl --silent "http://weather.yahoo.com/united-states/colorado/denver-12792950/" | grep "current-weather" | sed "s/.*background\:url(\'\(.*\)\') .*/\1/" | xargs curl --silent -o /tmp/geektool/images/yahoo_current_wx.png


#US National Weather Service
#------------------------------
#Automatic Location: Current Weather Detailed Display
#$PYTHON $ULTIMATEWEATHER -B -C "georgetown" -S "colorado" -O "united states" -Z 80444 -Q full -T usnws -i current -s detailed > $CURRENT
$PYTHON $ULTIMATEWEATHER -A -L ipinfodb -Q full -T usnws -i current -s detailed > $CURRENT

#Automatic Location: Multiday Forecast - Simple Display Vertically
$PYTHON $ULTIMATEWEATHER -A -L ipinfodb -Q full -T usnws -i multidaysimple > $FORECAST

CONDITION=`cat $CURRENT | grep Condition | cut -d: -f 2 | cut -b 3-`
TEMPERATURE=`cat $CURRENT | grep Temperature | cut -d: -f 2 | cut -b 3-`
WIND=`cat $CURRENT | grep Wind`

if [ ! -z "`cat $CURRENT | grep Gust | cut -d: -f 2 | cut -c 3-`" ]; then
GUST=`cat $CURRENT | grep Gust`
fi

echo "\033[37mCurrent Conditions:"
echo "\033[33m $TEMPERATURE : $CONDITION"
echo "\033[33m $WIND $GUST"

if [ "Tonight" = "`sed -n -e '1p' $FORECAST`" ]; then
DAY1=`sed -n -e '1p' -e '2p' -e '3p' $FORECAST`
DAY2=`sed -n -e '6p' -e '7p' -e '8p' -e '13p' $FORECAST`
DAY3=`sed -n -e '16p' -e '17p' -e '18p' -e '23p' $FORECAST`
DAY4=`sed -n -e '26p' -e '27p' -e '28p' -e '33p' $FORECAST`
else
DAY1=`sed -n -e '1p' -e '2p' -e '3p' -e '8p' $FORECAST`
DAY2=`sed -n -e '11p' -e '12p' -e '13p' -e '18p' $FORECAST`
DAY3=`sed -n -e '21p' -e '22p' -e '23p' -e '28p' $FORECAST`
DAY4=`sed -n -e '31p' -e '32p' -e '33p' -e '38p' $FORECAST`
fi

DAY1=`echo $DAY1`
DAY2=`echo $DAY2`
DAY3=`echo $DAY3`
DAY4=`echo $DAY4`


echo "\033[37mForecast:"
echo "\033[32m $DAY1"
echo "\033[32m $DAY2"
echo "\033[32m $DAY3"
echo "\033[32m $DAY4"
