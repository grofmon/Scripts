#!/bin/sh
ps -amcwwwxo "command %mem %cpu" | grep -v grep | head -15