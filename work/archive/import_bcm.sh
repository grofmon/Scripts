#!/bin/sh
SOURCE=$1
DEST=$2
COMMENT=$3

echo "clearfsimport -recurse -nsetevent -rmname -c $COMMENT $SOURCE $DEST"