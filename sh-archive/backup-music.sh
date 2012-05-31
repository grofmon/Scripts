#!/bin/sh
DATE=`date "+ %Y-%m-%d"`
#rsync -amv --numeric-ids --delete-during --backup --backup-dir=_mng_archive/$DATE "/Users/monty/Music/" "/Volumes/2TB WD/Music/"
rsync -amv --numeric-ids --delete-during --backup --backup-dir=_mng_archive/$DATE "/Volumes/Parker-Spare/music-not-in-itunes/" "/Volumes/2TB WD/music-backup/music-not-in-itunes/"