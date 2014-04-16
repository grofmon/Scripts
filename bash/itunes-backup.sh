#!/bin/sh
if [ -d "/Volumes/Max Roach/itunes-backup/" ]; then
    rsync -av /Volumes/Miles/miles-itunes/* /Volumes/Max\ Roach/itunes-backup/
else
    echo "Drive not mounted /Volumes/Max Roach/itunes-backup/"
fi