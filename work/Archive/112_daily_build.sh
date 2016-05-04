#!/bin/sh
# Monty's daily build script
# Usage: 
#        daily_build.sh <model> <option>
#        where:
#              model is a valid model (110, 813, or 913)
#              options is either empty or "unique_view"


# The first parameter needs to be the model
if [ "$1" = "112" ]; then
    model=$1
else
    echo "Model not properly defined"
    echo "usage: daily_build.sh <model> <unique_build>"
    exit 1
fi

if [ "$2" = "unique_view" ]; then
    unique_view=true
fi

DATE=`date +%Y%m%d`
SEP="\n#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#\n"
RESULT=1

# Update with your email address
mailto="montgomery.groff@echostar.com"
mailfr="XIP112-Daily-Build"
# Update with your build directory
daily_dir=/home/monty/daily_build_112
# Create the build dir if it doesn't exist
if [ ! -d $daily_dir ]; then
    echo "creating $daily_dir"
    mkdir -p $daily_dir
fi

csname=`ls $daily_dir | grep XiP"$model".*.cs | head -1`
build_id=`echo "$csname" | sed s/\.cs//g | sed s/_64MB//g`
new_cs="$daily_dir"/"$csname"
# Pick up any line items you might have via this file
line_items=$daily_dir/line-items
if [ $unique_view ]; then
    # Create a unique view every day. Don't forget to clean up
    ccview="$USER"_"$build_id"
else
    # Re-use the same view every day
    ccview="$USER"_test_"$model"
fi

if [ ! -f "$new_cs" ]; then
    # Nothing to do right now, just exit
    exit 1
fi

daily_archive=$daily_dir/archive
# Create the archive dir if it doesn't exist
if [ ! -d $daily_archive ]; then
    echo "creating $daily_archive"
    mkdir -p $daily_archive
fi

daily_archerr=$daily_dir/errors
# Create the error dir if it doesn't exist
if [ ! -d $daily_archerr ]; then
    echo "creating $daily_archerr"
    mkdir -p $daily_archerr
fi

# Setup file variables
daily_bin=$daily_dir/daily_dev_$build_id.bin
daily_mot=$daily_dir/daily_dev_$build_id.mot
daily_log=$daily_dir/daily_dev_$build_id.log
daily_err=$daily_dir/daily_dev_$build_id.err
daily_cfg=$daily_dir/daily_dev_$build_id.cfg
daily_txt=$daily_dir/daily_dev_$build_id.txt
BIN_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.bin

# Setup clearcase commands
ccswid=`date +%m%d`
ccmkview='cleartool mkview -tag'
ccsetcs="cleartool setcs -tag"
ccsetview="cleartool setview -exec"
ccendview="cleartool endview -ser"
ccrmview="cleartool rmview -tag"
ccconfig_spec="$daily_cfg"
# Make any build command modifications necessary
### e.g. Adding DTCP=false to the build command
#ccbuild="`grep make $new_cs | sed 's/#//' | sed 's/\-j. /\-j4 \-C \/vobs\/src_tree /' | sed '$s/\(.*\)/\1 DTCP=false/'`"
ccbuild="`grep -w make $new_cs | sed 's/#//' | sed 's/\-j. /\-j4 \-C \/vobs\/src_tree /'`"

cccopy="cp $BIN_FILE $daily_bin"
daily_chmod="find $daily_dir -type f -not -iname *$DATE*.log -exec chmod 644 {} \; >> $daily_log"
daily_cln="find $daily_archive -mtime +7 -print -delete"

# Used to echo to the file only
CSV="$ccsetcs $ccview $ccconfig_spec"
BLD="$ccsetview \"$ccbuild\" $ccview"
CPY="$ccsetview \"$cccopy\" $ccview"
MKV="$ccmkview $ccview ~/views/$ccview.vws"
RMV="$ccrmview $ccview"
ERR="cp $daily_log $daily_err"

# Set the email messages
errsubj="BUILD_ERROR: XiP$model Config Spec build failed !! : $DATE"
errtext="BUILD ERROR: see $daily_err"
subj="XiP$model Config Spec build success : $DATE"
text="The XiP daily config spec updated and the latest build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_bin\n\nBuild log file:\n$daily_log\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n"

# Cleanup yesterday's files
cd $daily_dir > /dev/null 2>&1
if [ -f *.err ]; then
    mv -f *.err *.log *.cfg *.txt $daily_archerr > /dev/null 2>&1
else
    mv -f *.bin *.mot *.log *.cfg *.txt $daily_archive > /dev/null 2>&1
fi

echo "Starting Daily build at `date`" > $daily_log
echo -e $SEP >> $daily_log

# Create config spec
echo "Executing :: Create config spec" >> $daily_log
echo -e $SEP >> $daily_log
sed -e '/inv_gdev_cr82844/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_hal_cr82789/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_input_mgr_cr82961/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_opnsrc_cr82845/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_proc_mgr_cr83025/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_tools_cr82999/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sed -e '/inv_tools_cr83003/s/^/##/' < $new_cs > temp.cs && mv temp.cs $new_cs
sleep 3
if [ -f $line_items ]; then
    # Add your line items
    cat $line_items > $daily_cfg
fi
echo -e "$SEP## $csname $SEP" >> $daily_cfg
cat $new_cs >> $daily_cfg
echo -e "$SEP## Build Command \n# $ccbuild $SEP" >> $daily_cfg
csfiles=`ls *.cs 2> /dev/null | wc -l`
if [ "$csfiles" != "0" ]; then
    rm *.cs
fi

cleartool lsview | grep $ccview > /dev/null 2>&1
RET=$?
if [ $RET = 0 ]; then
    # Remove the view to ensure a clean build
    echo "Executing :: $RMV" >> $daily_log
    echo -e $SEP >> $daily_log
    $ccrmview $ccview >> $daily_log 2>&1
    echo -e $SEP >> $daily_log
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


# Build the code
echo "Executing :: $BLD" >> $daily_log
echo -e $SEP >> $daily_log
$ccsetview "time $ccbuild" $ccview >> $daily_log 2>&1
#echo "$ccsetview \"$ccbuild\" $ccview >> $daily_log 2>&1"
STAT=$?
echo -e $SEP >> $daily_log
if [ $STAT != 0 ]; then
    # The build failed, send an email
    $ERR
    echo -e "$errtext" | 
    if [ -f /usr/bin/mailx ]; then
    # SUSE uses mailx
        mailx -n -s "$errsubj" -r "$mailfr" "$mailto"
    else
        # RedHat uses mail
        mail -s "$errsubj" "$mailto" -- -F "$mailfr" -f "$mailfr"
    fi
else
    # The build was successful
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
find $daily_archive -type f -mtime +7 -print -delete  >> $daily_log
cd $daily_archerr
find $daily_archerr -type f -mtime +7 -print -delete  >> $daily_log
echo -e $SEP >> $daily_log

if [ $RESULT == 0 ]; then
    echo -e "$text" > $daily_txt 
    cat $daily_txt |
    if [ -f /usr/bin/mailx ]; then
        # SUSE uses mailx
        mailx -n -s "$subj" -r "$mailfr" "$mailto"
    else
        # RedHat uses mail
        mail -s "$subj" "$mailto" -- -F "$mailfr" -f "$mailfr"
    fi
else
    rm $daily_log
fi

$ccendview $ccview
