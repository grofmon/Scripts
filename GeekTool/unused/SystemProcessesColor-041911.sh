#!/bin/sh
HEAD=`ps -amcwwwxo "command %mem %cpu" | grep -v grep | head -1`
echo "\033[33m$HEAD\033[0m"
ps -amcwwwxo "command %mem %cpu" | grep -v grep | head -15 | tail -n 14