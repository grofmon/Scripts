#!/bin/sh
LABEL_FILE=$1
COMPLETE_FILE=$2
TMP_FILE=`mktemp`

cat $1 | cat - $2 > TMP_FILE && mv TMP_FILE $2 