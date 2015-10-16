#!/bin/bash
# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee -a ~/Library/Logs/herbie-klee-update.log)
exec 2> >(tee -a ~/Library/Logs/herbie-klee-update.log >&2)

SRC="/Volumes/monty/Music/iTunes/Media/Music/"
DST="/Users/lori/Music/iTunes/Media/Music/"

usage()
{
    echo " Usage: ./herbie-klee.sh [option]"
    echo "  where:" 
    echo "         option = d (--dry-run)"
}

if [ ! -d $SRC ]; then
    open afp://Herbie.local/monty
    sleep 20
fi

if [ "${1}" = "d" ]; then
    DRY_RUN="--dry-run"
    echo "--- DRY RUN ---"
fi

if [ -d ${SRC} ]; then
    echo ${SRC}
    echo ${DST}
    echo "## Update ${DST} using rsync"
    time rsync ${DRY_RUN} -av --delete $EXCL "${SRC}" "${DST}"
else
    echo "${SRC} Not Mounted"
fi
