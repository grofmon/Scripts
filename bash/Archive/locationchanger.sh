#!/bin/sh

# redirect all IO to a logfile
exec &>/Users/monty/Library/Logs/locationchanger.log
# redirect all IO to /dev/null (comment this in if you don#t want to write to logfile)
#exec 1>/dev/null 2>/dev/null

# get a little breather before we get data for things to settle down
sleep 5

#get SSID
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`

echo `date` "New SSID found: $SSID"

#clear the location
LOCATION=

# LOCATIONS 
# =============================================
Location_Automatic="Automatic"
Location_Work="Work"

#Default location
LOCATION="$Location_Automatic"

# SSIDS
# =====
SSID_Work=engacc
#SSID_Home=Michelangelo

# SSID -> LOCATION mapping
case $SSID in
    $SSID_Work ) LOCATION="$Location_Work";;
#    $SSID_Home ) LOCATION="$Location_Automatic";;
#    $SSID_OOB  ) LOCATION="$Location_Automatic";;
    # ... add more here
esac
REASON="SSID changed to $SSID"

## still didn't get a location -> use Location_Automatic
#if [ -z "$LOCATION" ]; then
#    LOCATION="$Location_Automatic"
#    REASON="Automatic Fallback"
#fi

# change network location
#scselect "$LOCATION"

case $LOCATION in
    $Location_Automatic )
    # do stuff here you would do in Location_Automatic
#    /usr/bin/osascript -e 'tell application "System Events" to set require password to wake of security preferences to false'
    killall -9 Synergy synergys
    ;;

    $Location_Work )
    # nothing special here
#    open /Applications/Synergy.app
    /usr/bin/osascript -e 'tell application "System Events" to set require password to wake of security preferences to true'
    ;;
esac

echo "--> Location Changer: $LOCATION - $REASON"

exit 0