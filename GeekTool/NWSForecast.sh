#!/bin/sh

PYTHON=/usr/bin/python
ULTIMATEWEATHER=~/Library/Scripts/GeekTool/ultimateweather/ultimate_weather_parser.py
FORECAST=/tmp/geektool/usnws_forecast.txt
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
#Automatic Location: Multiday Forecast - Simple Display Vertically
$PYTHON $ULTIMATEWEATHER -A -L ipinfodb -Q full -T usnws -i multidaysimple > $FORECAST

if [ "Tonight" = "`sed -n -e '1p' $FORECAST`" ]; then
DAY1NAME=`sed -n -e '1p' $FORECAST`
DAY2NAME=`sed -n -e '6p' $FORECAST`
DAY3NAME=`sed -n -e '16p' $FORECAST`
DAY4NAME=`sed -n -e '26p' $FORECAST`
DAY5NAME=`sed -n -e '36p' $FORECAST`
DAY1=`sed -n -e '2p' -e '3p' $FORECAST`
DAY2=`sed -n -e '7p' -e '8p' -e '13p' $FORECAST`
DAY3=`sed -n -e '17p' -e '18p' -e '23p' $FORECAST`
DAY4=`sed -n -e '27p' -e '28p' -e '33p' $FORECAST`
DAY5=`sed -n -e '37p' -e '38p' -e '43p' $FORECAST`
else
DAY1NAME=`sed -n -e '1p' $FORECAST`
DAY2NAME=`sed -n -e '11p' $FORECAST`
DAY3NAME=`sed -n -e '21p' $FORECAST`
DAY4NAME=`sed -n -e '31p' $FORECAST`
DAY5NAME=`sed -n -e '41p' $FORECAST`
DAY1=`sed -n -e '2p' -e '3p' -e '8p' $FORECAST`
DAY2=`sed -n -e '12p' -e '13p' -e '18p' $FORECAST`
DAY3=`sed -n -e '22p' -e '23p' -e '28p' $FORECAST`
DAY4=`sed -n -e '32p' -e '33p' -e '38p' $FORECAST`
DAY5=`sed -n -e '42p' -e '43p' -e '48p' $FORECAST`
fi

DAY1=`echo $DAY1`
DAY2=`echo $DAY2`
DAY3=`echo $DAY3`
DAY4=`echo $DAY4`
DAY5=`echo $DAY5`

echo "\033[32m $DAY1NAME \033[37m$DAY1"
echo "\033[33m $DAY2NAME \033[37m$DAY2"
echo "\033[33m $DAY3NAME \033[37m$DAY3"
echo "\033[33m $DAY4NAME \033[37m$DAY4"
echo "\033[33m $DAY5NAME \033[37m$DAY5"
