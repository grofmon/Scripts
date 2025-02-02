#!/bin/sh
if [ "$1" = "update" ]; then
    update=true
fi

DATE=`date +%Y%m%d`
SEP="\n#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#\n"
RESULT=1

machine=`echo $HOSTNAME | sed 's/[^0-9]*//g'`

if [ "$update" = "true" ]; then
    mailto="montgomery.groff@echostar.com"
    mailfr="EVTC-Updated-Build"
#    mailbcc="montgomery.groff@echostar.com, grofmon@echostar.com, monty.groff@echostar.com"
    
    csname=`ls /home/monty/daily_build/ | grep XiP813`
    build_id=`echo $csname | sed s/\.cs//g | sed s/XiP813_//g | sed s/_64MB//g`
    new_cs=/home/monty/daily_build/$csname
    daily_dir=/home/monty/daily_build
    line_items=$daily_dir/line-items
    ccview=monty_update_$machine
    if [ ! -f "$new_cs" ]; then
        exit 1
    fi
else
    mailto="Engineering.EVTC@echostar.com"
#    mailto="montgomery.groff@echostar.com"
    mailfr="EVTC-Daily-Build"    
#    mailbcc="Richard.Bauer@echostar.com, Kit.Chan@echostar.com, Alan.Cohn@echostar.com, David.Crandall@echostar.com, James.Gaul@echostar.com, Montgomery.Groff@echostar.com, Kyle.Haugsness@echostar.com, Vijay.Jayaraman@echostar.com, Miguel.Mayorga@echostar.com, Manuel.NovoaIII@echostar.com, Casey.Paiz@echostar.com, Spencer.Schumann@echostar.com, Matthew.Siwiec@echostar.com, Sanjiv.Topiwalla@echostar.com, Marcus.Gering@echostar.com, Shiqiang.Chu@echostar.com, Bin.Zhang@echostar.com, Vincent.Brechtel@echostar.com"
    
    daily_dir=/ccshare/linux/c_files/evtc/daily_build
    ccview=monty_daily_$machine
    build_id=$DATE
fi

export PATH=$PATH:/ccshare/linux/cc_tools/perl_scripts:/ccshare/linux/c_scripts:/ccshare/linux/cc_tools:/ccshare/linux/cc_tools/build_scripts

export PKG_CONFIG_PATH=/usr/lib/pkgconfig

daily_archive=$daily_dir/archive
daily_archerr=$daily_dir/errors
daily_bin=$daily_dir/evtc_dev_$build_id.bin
daily_mot=$daily_dir/evtc_dev_$build_id.mot
daily_log=$daily_dir/evtc_dev_$build_id.log
daily_err=$daily_dir/evtc_dev_$build_id.err
daily_cfg=$daily_dir/evtc_dev_$build_id.cfg
daily_txt=$daily_dir/evtc_dev_$build_id.txt
daily_tip=/home/monty/bin/build_cs.sh
BIN_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.bin

ccswid=`date +%m%d`
ccmkview='cleartool mkview -tag'
ccsetcs="cleartool setcs -tag"
ccsetview="cleartool setview -exec"
ccendview="cleartool endview -ser"
ccrmview="cleartool rmview -tag"

if [ "$update" = "true" ]; then
    ccconfig_spec="$daily_cfg"
    ccbuild="`grep make $new_cs | sed 's/#//' | sed 's/\-j2/\-j2 \-C \/vobs\/src_tree/' | sed 's/^[ \t]*//' | sed 's/$/ EVTC=true/'`"
else
    ccconfig_spec=/ccshare/linux/c_files/evtc/config_spec/evtc_cs.cfg
    ccbuild="`grep make $ccconfig_spec | sed 's/#//' | sed 's/\-j2/\-j2 \
\-C \/vobs\/src_tree/' | sed 's/^[ \t]*//'`"
fi

cccfg="$daily_tip"
cccopy="cp $BIN_FILE $daily_bin"
daily_chmod="find $daily_dir -type f -not -iname *$DATE*.log -exec chmod 644 {} \; >> $daily_log"
daily_cln="find $daily_archive -mtime +7 -print -delete"

#Used to echo to the file only
CSV="$ccsetcs $ccview $ccconfig_spec"
BLD="$ccsetview \"$ccbuild\" $ccview"
CPY="$ccsetview \"$cccopy\" $ccview"
MKV="$ccmkview $ccview ~/views/$ccview.vws"
RMV="$ccrmview $ccview"
ERR="cp $daily_log $daily_err"
CFG="$cccfg $ccconfig_spec"

if [ "$update" = "true" ]; then
    errsubj="BUILD_ERROR: XiP Config Spec update build failed !! : $DATE"
    errtext="BUILD ERROR: see $daily_err"
    subj="XiP Config Spec update and build success : $DATE"
    text="The XiP daily config spec updated and the latest build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_bin\n\nBuild log file:\n$daily_log\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n"
else
    errsubj="BUILD ERROR: EVTC Daily Build FAILED !! : $DATE"
    errtext="BUILD ERROR: see $daily_err"
    subj="EVTC Daily Build Success : $DATE"
    text="The EVTC daily build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_bin\n\nBuild log file:\n$daily_log\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n"
fi

# Cleanup yesterday's files
cd $daily_dir > /dev/null 2>&1
mv -f *.bin *.mot *.log *.cfg *.txt $daily_archive > /dev/null 2>&1
mv -f *.err $daily_archerr > /dev/null 2>&1

echo "Starting Daily build for EVTC at `date`" > $daily_log
echo -e $SEP >> $daily_log

# Create config spec
if [ "$update" = "true" ]; then
    echo "Executing :: Create config spec" >> $daily_log
    echo -e $SEP >> $daily_log
    cat $line_items > $daily_cfg
    echo -e "###############################################################################\n## $csname \n###############################################################################\n" >> $daily_cfg
    cat $new_cs >> $daily_cfg
    echo "$(cat $daily_cfg) EVTC=true" > $daily_cfg
    rm $new_cs
fi

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

if [ "$update" != "true" ]; then
    # Log the config spec
    echo "Executing :: $CFG" >> $daily_log
    echo -e $SEP >> $daily_log
    $cccfg $ccconfig_spec > $daily_cfg
    cat $daily_cfg >> $daily_log 2>&1
    echo -e $SEP >> $daily_log
fi

# Build the code
echo "Executing :: $BLD" >> $daily_log
echo -e $SEP >> $daily_log
$ccsetview "$ccbuild" $ccview >> $daily_log 2>&1
#echo "$ccsetview \"$ccbuild\" $ccview >> $daily_log 2>&1"
STAT=$?
echo -e $SEP >> $daily_log
if [ $STAT != 0 ]; then
    $ERR
    echo -e "$errtext" | 
    if [ -f /usr/bin/mailx ]; then
#with bcc        mailx -n -s "$errsubj" -r "$mailfr" -b "$mailbcc" "$mailto"
        mailx -n -s "$errsubj" -r "$mailfr" "$mailto"
    else
#with bcc        mail -s "$errsubj" "$mailto" -c "$mailcc" -b "$mailbcc" -- -f "$mailfr"
        mail -s "$errsubj" "$mailto" -c "$mailcc" -- -f "$mailfr"
    fi
else
    # Copy the .bin file
    echo "Executing :: $CPY" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccsetview "$cccopy" $ccview >> $daily_log 2>&1
    echo -e $SEP >> $daily_log

    RESULT=0
fi

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
    
if [ "$update" != "true" ]; then
    # Make the files read-only
    echo "Executing :: $daily_chmod" >> $daily_log
    echo -e $SEP >> $daily_log
    cd $daily_dir
    echo "Finished at `date`" >> $daily_log
    find $daily_dir -type f -not -iname *$DATE*.log -exec chmod 644 {} \; >> $daily_log
fi



if [ $RESULT == 0 ]; then
    echo -e "$text" > $daily_txt 
    cat $daily_txt |
    if [ -f /usr/bin/mailx ]; then
#with bcc        mailx -n -s "$subj" -r "$mailfr" -b "$mailbcc" "$mailto"
        mailx -n -s "$subj" -r "$mailfr" "$mailto"
    else
#with bcc        mail -s "$subj" "$mailto" -c "$mailcc" -b "$mailbcc" -- -f "$mailfr"
        mail -s "$subj" "$mailto" -c "$mailcc" -- -f "$mailfr"
    fi
else
    rm $daily_log
fi
