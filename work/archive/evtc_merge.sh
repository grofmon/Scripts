#!/bin/sh
DATE=`date +%Y%m%d`
SEP="\n#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#\n"
RESULT=1
#if [ "$1" = "test" ]; then
    echo "Testing daily build, please wait..."
    mailto="montgomery.groff@echostar.com"
    daily_dir=/home/monty/daily_build
#else
#    mailto="engineering.evtc@echostar.com"
#    daily_dir=/ccshare/linux/c_files/evtc/daily_build
#fi

mailfr="evtc-build@echostar.com"
mailcc="montgomery.groff@echostar.com"
#BDAILY=false

export PATH=$PATH:/ccshare/linux/cc_tools/perl_scripts:/ccshare/linux/c_scripts:/ccshare/linux/cc_tools:/ccshare/linux/cc_tools/build_scripts

daily_archive=$daily_dir/archive
daily_archerr=$daily_dir/errors
daily_bin=$daily_dir/evtc_dev_$DATE.bin
daily_mot=$daily_dir/evtc_dev_$DATE.mot
daily_log=$daily_dir/evtc_dev_$DATE.log
daily_err=$daily_dir/evtc_dev_$DATE.err
daily_cfg=$daily_dir/evtc_dev_$DATE.cfg
daily_tip=/home/monty/bin/evtc_tipcheck.sh
BIN_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.bin
MOT_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.mot

ccswid=`date +%m%d`
ccmkview='cleartool mkview -tag'
ccsetcs="cleartool setcs -tag"
ccsetview="cleartool setview -exec"
ccendview="cleartool endview -ser"
ccrmview="cleartool rmview -tag"
ccview=monty_daily
ccconfig_spec="/ccshare/linux/c_spec/evtc_cs.txt"
ccbuild="nice make -j2 -C /vobs/src_tree xip813DevRelease SWID=$ccswid"
#cccopy="cp $BIN_FILE $daily_bin;cp $BIN_FILE_64MB $daily_bin_64mb;cp $MOT_FILE $daily_mot"
cccopy="cp $BIN_FILE $daily_bin;cp $MOT_FILE $daily_mot"
cccfg="$daily_tip"
daily_chmod="find $daily_dir -type f -not -iname *$DATE*.log -exec chmod -w {} \; >> $daily_log"
daily_cln="find $daily_archive -mtime +7 -print -delete"

#Used to echo to the file only
CSV="$ccsetcs $ccview $ccconfig_spec"
BLD="$ccsetview \"$ccbuild\" $ccview"
CPY="$ccsetview \"$cccopy\" $ccview"
MKV="$ccmkview $ccview ~/views/$ccview.vws"
RMV="$ccrmview $ccview"
ERR="cp $daily_log $daily_err"
CFG="$cccfg evtc_cs.txt"

if [ "$BDAILY" != "false" ]; then

    # Cleanup yesterday's files
    cd $daily_dir > /dev/null 2>&1
    mv *.bin *.mot *.log *.cfg $daily_archive > /dev/null 2>&1
    mv *.err $daily_archerr > /dev/null 2>&1
    sleep 10

    echo "Starting Daily build for EVTC at `date`" > $daily_log
    echo -e $SEP >> $daily_log

    # Make a new view
    echo "Executing :: $MKV" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccmkview $ccview ~/views/$ccview.vws >> $daily_log 2>&1
    echo -e $SEP >> $daily_log

    # Set the config spec
    echo "Executing :: $CSV" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccsetcs $ccview $ccconfig_spec >> $daily_log 2>&1
    echo -e $SEP >> $daily_log

    # Log the config spec
    echo "Executing :: $CFG" >> $daily_log
    echo -e $SEP >> $daily_log
    $cccfg evtc_cs.txt >> $daily_log 2>&1
    $cccfg "evtc_cs.txt" > $daily_cfg
    echo -e $SEP >> $daily_log

    # Build the code
    echo "Executing :: $BLD" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccsetview "$ccbuild" $ccview >> $daily_log 2>&1
    STAT=$?
    if [ $STAT != 0 ]; then
        $ERR
        echo -e "BUILD ERROR: see $daily_err\n" | mail -s "ERROR: EVTC Daily Build FAILED !! : $DATE" $mailto -c "$mailcc" -- -f $mailfr
    else
        RESULT=0
    fi
    echo -e $SEP >> $daily_log

    # Copy the .bin file
    echo "Executing :: $CPY" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccsetview "$cccopy" $ccview >> $daily_log 2>&1
    echo -e $SEP >> $daily_log

    # Cleanup the archived files. Delete files older than 7 days
    echo "Executing :: $daily_cln" >> $daily_log
    echo -e $SEP >> $daily_log
    cd $daily_archive
    find $daily_archive -mtime +7 -print -delete  >> $daily_log

    # Remove the view to ensure a clean build
    echo "Executing :: $RMV" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccrmview $ccview >> $daily_log 2>&1
    echo -e $SEP >> $daily_log
    echo -e $SEP >> $daily_log
    
    # Make the files read-only
    echo "Executing :: $daily_chmod" >> $daily_log
    echo -e $SEP >> $daily_log
    cd $daily_dir
    find $daily_dir -type f -not -iname *$DATE*.log -exec chmod -w {} \; >> $daily_log

    echo "Finished at `date`" >> $daily_log

    if [ $RESULT == 0 ]; then
        echo -e "The EVTC daily build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_bin\n\nMotorola hex file (untested):\n$daily_mot\n\nBuild log file:\n$daily_log\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n" | mail -s "EVTC Daily Build Success : $DATE" $mailto -c "$mailcc" -- -f $mailfr
    else
        rm $daily_log
    fi
else
    echo -e "Daily Build on hold indefinately" | mail -s "EVTC No Daily Build Today" $mailfr -c "$mailcc" -- -f $mailfr
fi