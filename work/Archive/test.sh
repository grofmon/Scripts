#!/bin/sh
daily_log='>> /home/monty/evtc_dev.log'
dev_null='> /dev/null 2>&1'

echo "This is a test" $daily_log
ls $dev_null

echo "done"