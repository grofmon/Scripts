#!/bin/sh
if [ -d "/Volumes/Max Roach/itunes-backup/" ]; then
    rsync -av --exclude="Album Artwork" /Volumes/2TB\ WD/iTunes\ \(Backup\)/* /Volumes/Max\ Roach/itunes-backup/
else
    echo "Drive not mounted /Volumes/Max Roach/itunes-backup/"
fi
