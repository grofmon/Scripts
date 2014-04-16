#!/bin/bash
EXCL="--exclude-from /Users/lori/Library/Scripts/Shell/excludes.txt"
TYPE=${1}

GI="/Users/lori"
DK="/Volumes/lori"
IT="/Music/iTunes/iTunes Media/Music/"
PC="/Pictures/Pictures/"

usage()
{
    echo " Usage: ./giacometti-dekooning.sh <type>"
    echo "  where:" 
    echo "         type = music"
    echo "         type = pictures"
    echo "         option = d (--dry-run)"
}     

if [ -z ${TYPE} ]; then
    usage
    exit -1
fi

if [ "${2}" = "d" ]; then
    DRY_RUN="--dry-run"
fi

if [ -d ${DK} ]; then
    
    if [ ${TYPE} == "music" ]; then
	SRC1=${GI}${IT}
	DST1=${DK}${IT}
        echo "## Clean up ${SRC1} .DS_Store files first"
        cd "${SRC1}"
	find . -iname ".DS_Store" -exec rm {} \;
	echo "## Update ${DST1} using rsync"
	time rsync ${DRY_RUN} -av --delete $EXCL "${SRC1}" "${DST1}"
    fi

    if [ ${TYPE} == "pictures" ]; then
	SRC2=${GI}${PC}
	DST2=${DK}${PC}
	echo "## Clean up ${SRC2} .files first"
	cd "${SRC2}"
	find . -iname ".*" -exec rm {} \;
	echo "## Update ${DST2} using rsync"
	time rsync ${DRY_RUN} -va --delete $EXCL "${SRC2}" "${DST2}"
    fi

else
 echo "${DK} Not Mounted"
fi
