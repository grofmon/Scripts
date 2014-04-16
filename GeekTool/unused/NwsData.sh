#!/bin/bash
# National Weather Service Weather
# Montgomery Groff - 2011
# Pulls data from a latitude/longitude use in geektool

dat_file="/tmp/geektool/nws.xml"
nws_file="/tmp/geektool/nws.txt"
gtw_file="/tmp/geektool/gtw.txt"

nws=(location observation_time_rfc822 weather temperature_string windchill_string dewpoint_string relative_humidity wind_string visibility_mi pressure_mb pressure_in)
nws_str=("Location" "Time" "Conditions" "Temperature" "Wind Chill" "Dew Point" "Humidity" "Wind" "Visibility" "Pressure (mb)" "Pressure (Hg)")
gtw=(sunrise sunset day1_l day1_h day1_day_cond day1_day_ppcp)
gtw_str=("Sunrise" "Sunset" "High" "Low" "Conditions" "Precipitation")

# Check for ethernet connection
ping -c 1 www.google.com >/dev/null 2>&1
ret="$?"

# Only continue if the internet is accessible
if [ "$ret" = "0" ]; then

    # Remove temporary file for script updates
    rm $dat_file $nws_file $gtw_file

    # Update the temporary file
    curl --silent "http://www.weather.gov/xml/current_obs/display.php?stid=KDEN" > $dat_file

    # Loop through the list of NWS items and print to temporary file
    for (( i = 0 ; i < ${#nws[@]} ; i++ ))
    do
        txt=`grep "<${nws[$i]}>" ${dat_file} | cut -d ">" -f2 | cut -d "<" -f1`
        echo "${nws_str[$i]}:;$txt" >> $nws_file
    done

    # Loop through the list of gtwthr.com items and print to temporary file
    for (( i = 0 ; i < ${#gtw[@]} ; i++ ))
    do
        txt=`curl --silent http://gtwthr.com/USCO0065/${gtw[$i]}`
        echo "${gtw_str[$i]}:;$txt" >> $gtw_file
    done

    # Check to see if any data was collected
    test=`grep Temperature $nws_file | cut -d ";" -f2`
    # Print the data
    if [ ! -z "$test" ]; then
        echo "------ Today's Weather ------"
        awk 'BEGIN{FS=";";}{ 
              printf "%14s %s\n",$1,$2,"\n";
             }' $nws_file
        echo ""
    fi

    # Check to see if any data was collected
    test=`grep Sunrise $gtw_file | cut -d ";" -f2`
    # Print the data
    if [ ! -z "$test" ]; then
        echo "---- Tomorrow's Forecast ----"
        awk 'BEGIN{FS=";";}{ 
              printf "%14s %s\n",$1,$2,"\n";
             }' $gtw_file

    fi
fi
