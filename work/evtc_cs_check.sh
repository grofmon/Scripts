#!/bin/sh
onhold=false

datestamp=`date "+%Y%m%d%H%M%S"`
datemail="`date '+%a %b %d %Y'` at `date '+%T %Z'`"
datesubj="`date "+%x %R %Z"`"

mailfr="EVTC-CS-Check"

mailto="Engineering.EVTC@echostar.com"

mailbcc="Richard.Bauer@echostar.com, Kit.Chan@echostar.com, Alan.Cohn@echostar.com, David.Crandall@echostar.com, James.Gaul@echostar.com, Montgomery.Groff@echostar.com, Kyle.Haugsness@echostar.com, Vijay.Jayaraman@echostar.com, Miguel.Mayorga@echostar.com, Manuel.NovoaIII@echostar.com, Casey.Paiz@echostar.com, Spencer.Schumann@echostar.com, Matthew.Siwiec@echostar.com, Sanjiv.Topiwalla@echostar.com, Marcus.Gering@echostar.com, Shiqiang.Chu@echostar.com, Bin.Zhang@echostar.com, Vincent.Brechtel@echostar.com"

bin_dir=/home/monty/bin
cfg_dir=/ccshare/linux/c_files/evtc/archive/daily_cs
tmp_file=/tmp/cs_update
out_file=$cfg_dir/cs_diffs/cs_diff_"$datestamp".txt
current_file=$cfg_dir/evtc_labels
archive_file=$cfg_dir/archive/evtc_cs_"$datestamp".cfg
cs=/ccshare/linux/c_files/evtc/config_spec/evtc_cs.cfg
updated=/ccshare/linux/c_files/evtc/daily_build/updated

semaphore="/tmp/diff_cs.lock.d"

semaphore_acquire () {
    # Create a semaphore
    wait_time="${2:-5}"
    while true; do
        if mkdir ${semaphore} &> /dev/null ; then
            break;
        fi
        sleep $wait_time
    done
}

semaphore_release () {
    rmdir ${semaphore}
}

semaphore_acquire
latest=$(
    $bin_dir/print_cs $cs |
    grep '^element'
)

last="0"
if [ -f $current_file ] ; then
    last=$(cat $current_file)
fi
if [ "$onhold" != "true" ]; then
    if [ "$last" != "$latest" ] ; then
        echo -e "The EVTC config_spec was updated at $datemail. This is an informational message and you are advised to update your local view's config spec as necessary.\n\n  file location: /ccshare/linux/c_files/evtc/config_spec/evtc_cs.cfg\n\nDifferences are outlined below: **\n" > $tmp_file
        echo "$latest" | diff -U 0 $current_file - | sed ' /+++/d ; /---/d ; s/@@.*@@/\n-- Version update from (-) to (+) --/g' >> $tmp_file
        echo -e "\n\n** Previous config spec archived as: $archive_file" >> $tmp_file
        
        if [ -f /usr/bin/mailx ]; then
            cat $tmp_file | mailx -n -s "Attention: EVTC config spec updated ($datesubj)" -r "$mailfr" -b "$mailbcc" "$mailto"
#NOBCC            cat $tmp_file | mailx -n -s "Attention: EVTC config spec updated ($datesubj)" -r "$mailfr" "$mailto"
        else
            cat $tmp_file | mail -s "Attention: EVTC config spec updated ($datesubj)" "$mailto" -b "$mailbcc" -- -f "$mailfr"
#NOBCC            cat $tmp_file | mail -s "Attention: EVTC config spec updated ($datesubj)" "$mailto" -- -f "$mailfr"
        fi

        mv $tmp_file $out_file
        cp $current_file $archive_file
        cp $current_file $updated
        echo "$latest" > $current_file
    fi
fi
semaphore_release
