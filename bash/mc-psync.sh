#!/bin/bash
SRC=/
DST=/Volumes/Backup/
CMD='time sudo psync -a -p -d'

# # Check to see if the drive is mounted
if [ -e "/Volumes/Backup/" ]; then 
   echo "Starting Backup using:";
   echo " ${CMD} ${SRC} ${DST}"; 
   # Just the home directory using psync
   ${CMD} ${SRC} ${DST}
else 
   echo "Backup drive is not mounted.";
   echo "Please mount and try again"; 
fi
