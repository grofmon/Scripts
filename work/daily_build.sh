#!/bin/bash
# Monty's daily build script
# Usage: 
#        daily_build.sh <model> <option>
#        where:
#              model is a valid model (XIP110, XIP813, or XIP913)
#              options is either empty or "unique_view"

# The first parameter needs to be the model
if [ "$1" = "XIP110" -o "$1" = "XIP813" -o "$1" = "XIP913" -o "$1" = "XIP112" -o "$1" = "XIP110RC" -o "$1" = "ZIP110" ]; then
    model=$1
    if [ "$model" = "XIP913" -o "$model" = "XIP112" -o "$model" = "XIP110RC" -o "$model" = "ZIP110" ]; then
        opengl="true"
    else
        opengl="false"
    fi
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
#mailto="ZIP.Development@echostar.com"
#mailerr="montgomery.groff@echostar.com"
mailfr="Daily-Build"
# Update with your build directory
daily_dir=/ccshare/linux/c_files/QtReleases/daily_builds/$model
# Create the build dir if it doesn't exist
if [ ! -d $daily_dir ]; then
    echo "creating $daily_dir"
    mkdir -p $daily_dir
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

daily_docs=$daily_dir/html_docs
# Create the error dir if it doesn't exist
if [ ! -d $daily_docs ]; then
    echo "creating $daily_docs"
    mkdir -p $daily_docs
fi

csname=`ls $daily_dir | grep "$model".*.cfg | head -1`
build_id=`echo "$csname" | sed s/\.cfg//g | sed s/_64MB//g`
new_cs="$daily_dir"/"$csname"
# Pick up any line items you might have via this file
line_items=$daily_dir/line-items
if [ $unique_view ]; then
    # Create a unique view every day. Don't forget to clean up
    ccview="$USER"_"$build_id"
else
    # Re-use the same view every day
    ccview="$USER"_qt_"$model"
fi

if [ ! -f "$new_cs" ]; then
    # Nothing to do right now, just exit
    exit 1
fi

# Setup file variables
daily_bin=$daily_dir/qt_$build_id.bin
daily_upd=$daily_dir/qt_$build_id.update
daily_mot=$daily_dir/qt_$build_id.mot
daily_log=/tmp/qt_$build_id.log
daily_err=$daily_archerr/qt_$build_id.err
daily_cfg=$daily_dir/qt_$build_id.cs
daily_txt=$daily_dir/qt_$build_id.txt
daily_pkg=$daily_dir/qt_$build_id.tgz
qt_pre=/vobs/vendor/digia/qt/build/"$model"/5.4.0/"$model"_Qt.tar.gz

ccmkpre="make -C /vobs/vendor/digia/qt S=$model OPENGL=${opengl} prebuilt-package"
ccmkdocs='/vobs/gui/qt/tools/generate_docs > /dev/null 2>&1'

tmp_log=/tmp/qt_$build_id.log
# Redirect output to logfile
exec > $daily_log 2>&1

BIN_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.bin
UPD_FILE=/vobs/src_tree/build/link/appcreate/gandalf_dev_debug.update

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
#default-no modifications#ccbuild="`grep -w make $new_cs | sed 's/#//' | sed 's/\-j. /\-j4 \-C \/vobs\/src_tree /'`"
#ccbuild="`grep 'make ' $new_cs | sed 's/#//' | sed 's/-j./-j8 -C \/vobs\/src_tree /' | sed 's/QUIET= >& out//'  | sed 's/NETFLIX_UI=true//'  | sed 's/NETFLIX_DIAL=true//' | sed '$s/\(.*\)/\1 QT_GUI=true QT_QUICK_COMPILER=true QT_GUI_TESTS=true DATA_SEARCH=true IM_SUPPORT_TOUCHPAD=true EIT_SGS_JSON_FILES=true EVTC=false\n/'`"
#ccbuild="`grep 'make ' $new_cs | sed 's/#//' | sed 's/make /make -C \/vobs\/src_tree /' | sed 's/-j./-j8/' | sed 's/QUIET= >& out//'  | sed '$s/\(.*\)/\1 QT_GUI=true QT_QUICK_COMPILER=true QT_GUI_TESTS=true IM_SUPPORT_TOUCHPAD=true EIT_SGS_JSON_FILES=true/'`"
ccbuild="`grep make $new_cs | sed 's/#//'`"

cccopy="cp $UPD_FILE $daily_upd"

daily_chmod="find $daily_dir -type f -not -iname *$DATE*.log -exec chmod 644 {} \;"

# Used to echo to the file only
CSV="$ccsetcs $ccview $ccconfig_spec"
BLD="$ccsetview \"$ccbuild\" $ccview"
CPY="$ccsetview \"$cccopy\" $ccview"
PKG="$ccsetview \"$ccmkpre\" $ccview"
DOC="$ccsetview \"$ccmkdocs\" $ccview"
MKV="$ccmkview $ccview ~/views/$ccview.vws"
RMV="$ccrmview $ccview"
ERR="mv $daily_log $daily_err"
ERR2="mv $daily_cfg $daily_archerr"
DCL="find $daily_archive -mtime +60 -print -delete"
ECL="find $daily_err -mtime +60 -print -delete"

# Set the email messages
errsubj="BUILD_ERROR: $model Config Spec build failed !! : $DATE"
errtext="BUILD ERROR: see $daily_err"
subj="$model Config Spec w/Qt build success : $DATE"
text="The $model daily config spec updated and the latest build completed successfully. The following files are available:\n\nBinary image (untested):\n$daily_upd\n\nQt prebuilt package for this build:\n$daily_pkg\n\nConfig spec used for this build:\n$daily_cfg\n\nPrevious builds and logs are located in the 'archive' directory. Archives will be kept for 1 week, then removed from the repository.\n"

# Cleanup yesterday's files
cd $daily_dir > /dev/null 2>&1
#if [ -f *.err ]; then
#    mv -f *.err $daily_archerr > /dev/null 2>&1
#else
    find . -maxdepth 1 -type f -mtime +3 -exec mv -f {} $daily_archive  \; > /dev/null 2>&1
    rm *.txt > /dev/null 2>&1
#fi

echo "Starting Daily build at `date`"
echo -e $SEP

# Create config spec
echo "Executing :: Create config spec"
echo -e $SEP
if [ -f $line_items ]; then
    # Add your line items
    cat $line_items > $daily_cfg
fi
echo -e "$SEP## $csname $SEP" >> $daily_cfg
cat $new_cs >> $daily_cfg
#echo -e "$SEP## Build Command \n# $ccbuild $addl_params $SEP" >> $daily_cfg
csfiles=`ls *.cfg 2> /dev/null | wc -l`
if [ "$csfiles" != "0" ]; then
    rm *.cfg
fi

cleartool lsview | grep $ccview > /dev/null 2>&1
RET=$?
if [ $RET = 0 ]; then
    # Remove the view to ensure a clean build
    echo "Executing :: $RMV"
    echo -e $SEP
    $ccrmview $ccview
    echo -e $SEP
fi

# Make a new view
echo "Executing :: $MKV"
echo -e $SEP
$ccmkview $ccview ~/views/$ccview.vws
echo -e $SEP

# Set the config spec
echo "Executing :: $CSV"
echo -e $SEP
$ccsetcs $ccview $ccconfig_spec
echo -e $SEP

# Build the code
echo "Executing :: $BLD"
echo -e $SEP
$ccsetview "time $ccbuild" $ccview
#echo "$ccsetview \"$ccbuild\" $ccview"
STAT=$?
echo "DONE BUILDING"
echo -e $SEP
if [ $STAT != 0 ]; then
    # The build failed, send an email
    $ERR
    $ERR2
    echo -e "$errtext" | 
    # SUSE uses mailx
    mailx -n -s "$errsubj" -r "$mailfr" "$mailto"

    RESULT=1
else
    # The build was successful
    # Copy the .bin file
    echo "Executing :: $CPY"
    echo -e $SEP
    $ccsetview "$cccopy" $ccview
    # Create and copy the prebuilt-package
    echo "Executing :: $PKG"
    $ccsetview "rm $qt_pre > /dev/null 2>&1" $ccview
    $ccsetview "$ccmkpre" $ccview
    $ccsetview "cp $qt_pre $daily_pkg" $ccview
    echo -e $SEP
    echo "Executing :: $DOC"    
    $ccsetview "$ccmkdocs" $ccview
    $ccsetview "rm -rf $daily_docs" $ccview
    $ccsetview "mv -fu /vobs/gui/qt/docs/html $daily_docs" $ccview
    echo -e $SEP

    RESULT=0
fi

# Cleanup the archived files. Delete files older than 30 days
echo "Executing :: $DCL"
cd $daily_archive
find $daily_archive -type f -mtime +30 -print -delete 
echo "Executing :: $ECL"
cd $daily_archerr
find $daily_archerr -type f -mtime +30 -print -delete 
echo -e $SEP

if [ $RESULT = 0 ]; then
    mailto="Engineering.SWXiPDevelopment@echostar.com"
    echo -e "$text" > $daily_txt 
    cat $daily_txt |
    # SUSE uses mailx
    mailx -n -s "$subj" -r "$mailfr" "$mailto"
    cd $daily_dir
    mv *.txt $daily_archive
    mv $daily_log $daily_archive
fi

$ccendview $ccview
