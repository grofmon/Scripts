#!/bin/bash
EXCL="--exclude-from /Users/lori/Library/Scripts/Shell/excludes.txt"
TYPE=${1}

GI="/Users/lori"
MI="/Volumes/monty"
IT="/Music/iTunes/iTunes Media/Music/"
PC="/Pictures/Pictures/"

usage()
{
    echo " Usage: ./miro-giacometti.sh <type> [option]"
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

if [ -d ${MI} ]; then
    
    if [ ${TYPE} == "music" ]; then
	SRC1=${MI}${IT}
	DST1=${GI}${IT}
        echo "## Clean up ${SRC1} .DS_Store files first" 
	echo ${SRC1}
	echo ${DST1}
        #cd "${SRC1}"
	#find . -iname ".DS_Store" -exec rm {} \;
	echo "## Update ${DST1} using rsync"
	time rsync ${DRY_RUN} -av --delete $EXCL "${SRC1}" "${DST1}"
    fi

    if [ ${TYPE} == "pictures" ]; then
	SRC2=${MI}${PC}
	DST2=${GI}${PC}
	#echo ${SRC2}
	#echo ${DST2}
	echo "## Clean up ${SRC2} .files first"
	cd "${SRC2}"
	find . -iname ".*" -exec rm {} \;
	echo "## Update ${DST2} using rsync"
	time rsync ${DRY_RUN} -va --delete $EXCL "${SRC2}" "${DST2}"
    fi

else
    echo "${MI} Not Mounted"
fi
