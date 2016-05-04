#!/bin/sh
cmd=${0##/*/}
exe=do_build

DATE=`date +%Y%m%d`
SEP="\n#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#\n"
RESULT=1

csname=`ls /home/monty/daily_build/ | grep XiP813`
build_id=`echo $csname | sed s/\.cs//g | sed s/XiP813_//g | sed s/_64MB//g`
new_cs=/home/monty/daily_build/$csname
build_cmd=`grep make $new_cs | sed 's/#//' | sed 's/\-j2/\-j6 \-C \/vobs\/src_tree/' | sed 's/^[ \t]*//' | sed 's/$/ EVTC=true/'`
machine=`echo $HOSTNAME | sed 's/[^0-9]*//g'`

do_build()
{
#    echo "Testing XiP813 daily build, please wait..."
#    echo "Config spec: $new_cs"
#    echo -e "Build command:\n\t "$build_cmd""
    mailto="montgomery.groff@echostar.com"
    mailfr="EVTC-Updated-Build"
    daily_dir=/home/monty/daily_build

    export PATH=$PATH:/ccshare/linux/cc_tools/perl_scripts:/ccshare/linux/c_scripts:/ccshare/linux/cc_tools:/ccshare/linux/cc_tools/build_scripts

    export PKG_CONFIG_PATH=/usr/lib/pkgconfig

    daily_archive=$daily_dir/archive
    daily_archerr=$daily_dir/errors
    daily_bin=$daily_dir/build_test_$build_id.bin
    daily_log=$daily_dir/build_test_$build_id.log
    daily_err=$daily_dir/build_test_$build_id.err
    daily_cfg=$daily_dir/build_test_$build_id.cfg

    line_items=$daily_dir/line-items

    BIN_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.bin
    
#    ccswid=`date +%m%d`
    ccmkview='cleartool mkview -tag'
    ccsetcs="cleartool setcs -tag"
    ccsetview="cleartool setview -exec"
    ccendview="cleartool endview -ser"
    ccrmview="cleartool rmview -tag"
    ccview=monty_daily_xip_update_$machine
    ccconfig_spec="$daily_cfg"
    ccbuild="$build_cmd"
#    ccbuild="nice make -j2 -C /vobs/src_tree xip813DevRelease SWID=$ccswid"
    cccopy="cp $BIN_FILE $daily_bin"
    daily_chmod="find $daily_dir -type f -not -iname *$DATE*.log -exec chmod -w {} \; >> $daily_log"
    daily_cln="find $daily_archive -mtime +7 -print -delete"

    # Used to echo to the file only
    CSV="$ccsetcs $ccview $ccconfig_spec"
    BLD="$ccsetview \"$ccbuild\" $ccview"
    CPY="$ccsetview \"$cccopy\" $ccview"
    MKV="$ccmkview $ccview ~/views/$ccview.vws"
    RMV="$ccrmview $ccview"
    ERR="cp $daily_log $daily_err"

    # Cleanup yesterday's files
    cd $daily_dir > /dev/null 2>&1
    mv -f *.bin *.log *.cfg *.txt $daily_archive > /dev/null 2>&1
    mv -f *.err $daily_archerr > /dev/null 2>&1
    sleep 10
    cat $line_items > $daily_cfg
    echo -e "###############################################################################\n## $csname \n########\
#######################################################################\n" >> $daily_cfg
    cat $new_cs >> $daily_cfg
    echo "$(cat $daily_cfg) EVTC=true" > $daily_cfg
    rm $new_cs

    #cat $line_items | cat - $new_cs > TMP_FILE && mv TMP_FILE $new_cs
    #echo "$(cat $new_cs) EVTC=true" > TMP_FILE && mv TMP_FILE $new_cs
    #mv $new_cs $daily_cfg

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

    # Build the code
    echo "Executing :: $BLD" >> $daily_log
    echo -e $SEP >> $daily_log
#echo "running build here"
#echo "$ccsetview \"$ccbuild\" $ccview >> $daily_log 2>&1"
    $ccsetview "$ccbuild" $ccview >> $daily_log 2>&1
    STAT=$?
    if [ $STAT != 0 ]; then
        $ERR
        echo -e "BUILD ERROR: XiP Update build failed see $daily_err\n" |
        if [ -f /usr/bin/nail ]; then
            MAILRC=/dev/null from="$mailfr" nail -n -s "BUILD_ERROR: XiP Config Spec update build failed ! !" "$mailto"
        else
            mail -s "BUILD_ERROR: XiP Config Spec update build failed ! !" "$mailto" -- -f "$mailfr"
        fi
    else
        # Copy the .bin file
        echo "Executing :: $CPY" >> $daily_log
        echo -e $SEP >> $daily_log
        $ccsetview "$cccopy" $ccview >> $daily_log 2>&1
        echo -e $SEP >> $daily_log
        # Set the result to 0
        RESULT=0
    fi
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
    
    echo "Finished at `date`" >> $daily_log

    if [ $RESULT == 0 ]; then
        echo -e "The XiP daily config spec updated and the latest build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_bin\n\nBuild log file:\n$daily_log\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n" | 
        if [ -f /usr/bin/nail ]; then
            MAILRC=/dev/null from="$mailfr" nail -n -s "XiP Config Spec update and build success : $DATE" "$mailto"
        else
            mail -s "XiP Config Spec update and build success : $DATE" "$mailto" -- -f "$mailfr"
        fi
    else
       rm $daily_log
    fi
}

if [ -f "$new_cs" ]; then
    $exe
fi
