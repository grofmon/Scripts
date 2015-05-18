#!/bin/sh

array=( XIP110 XIP110RC XIP112 XIP813 XIP913 ZIP110 )
#array=( 813 913 )

mailto="montgomery.groff@echostar.com"
mailfr="QT-CS-Check"

for prod in "${array[@]}"
do
datefile="`date '+%a %b %d %Y'` at `date '+%T %Z'`"
bin_dir=/home/monty/bin
tmp_file=/tmp/"$prod"_cs_update
csprevious=`ls -t /home/monty/config_specs/"$prod"/*.cs | head -2 | tail -1`
cscurrent=`ls -t /home/monty/config_specs/"$prod"/*.cs | head -1`
csfile=`echo $cscurrent | sed "s/\/home\/monty\/config_specs\/$prod\///g"`
newcs=`echo $csfile | sed "s/\.cs/\.cfg/"`
dateprevious=`date -r $csprevious '+%m%d%y_%H00'`
datecurrent=`date -r $cscurrent '+%m%d%y_%H00'`
out_dir=/ccshare/linux/c_files/QtReleases/daily_builds
out_file=$out_dir/$prod/cs_diffs/cs_diff_"$datecurrent"-"$dateprevious".txt

# First, check to see if the latest version of the config spec is available
if [ -f $cscurrent ]; then
# Second, check to see if we have already run the diff"
# -- if diff has already been run, skip it"
    if [ ! -f "$out_file" ]; then
        semaphore=/tmp/"$prod"_diff_cs.lock.d

        semaphore_acquire () {
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
        current=$(
            $bin_dir/print_cs $cscurrent |
            grep '^element'
        )

        # Create a sanitized version of the previous config spec"
        previous=$(
            $bin_dir/print_cs $csprevious |
            grep '^element'
        )

        # Copy the previous version into a tmp_file for the diff"
        echo "$previous" > $tmp_file

        if [ "$previous" != "$current" ] ; then
            echo -e "The XiP$prod daily config_spec was updated $datefile. This is an informational message and you are advised to update your local view's config spec as necessary.\nDifferences are outlined below: **\n" > $out_file
            echo -e "Comparing:\n\t$csprevious\n\t$cscurrent\n" >> $out_file
            echo "$current" | diff -U 0 $tmp_file - | sed ' /+++/d ; /---/d ; s/@@.*@@/\n-- Version update from (-) to (+) --/g' >> $out_file
            echo -e "\n ---- End of Report ----\n" >> $out_file
            if [ -f /usr/bin/mailx ]; then
                cat $out_file | mailx -n -s "xip config_spec update for $prod" -r "$mailfr" "$mailto"
            else
                cat $out_file | mail -n -s "xip config_spec update for $prod" "$mailto" -- -F "$mailfr" -f "$mailfr"
            fi
            rm $tmp_file
            cp $cscurrent $out_dir/$prod/$newcs
            chmod +w $out_dir/$prod/$newcs
        fi
        semaphore_release
    fi
fi
done
