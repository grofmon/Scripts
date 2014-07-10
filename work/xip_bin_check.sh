#!/bin/sh

array=( XIP110Update XiP110CRUpdate XiP112Update XIP813Update XiP913Update )

#mailto="Engineering.SWXiPProjectleads@echostar.com, Engineering.EVTC@echostar.com, Engineering-SuperJoey@echostar.com"
mailto="montgomery.groff@echostar.com"
mailfr="XIP-Bin-Check"

for prod in "${array[@]}"
do
bin_dir=/home/monty/bin
motfile=`ls -t /ccshare/linux/c_files/"$prod"/*.mot | head -1`
binfile=`ls -t /ccshare/linux/c_files/"$prod"/*.mot | head -1 | cut -d'.' -f1 | cut -d'/' -f6`.bin

#echo "Mot file to convert: $motfile"
#echo "Bin file to create:  $binfile"

if [ $prod = XIP110Update ]; then
    model=110
elif [ $prod = XiP110CRUpdate ]; then
    model=110rc
elif [ $prod = XiP112Update ]; then
    model=112
elif [ $prod = XIP813Update ]; then
    model=813
elif [ $prod = XiP913Update ]; then
    model=913
fi           

outfile=/home/monty/stb/$model/$binfile


# First, check to see if the latest bin file is available
if [ -f $motfile ]; then
# Second, check to see if we have already converted the mot to binary
# -- if file has been converted, skip it
    if [ ! -f $outfile ]; then
        semaphore=/tmp/"$prod"_mot_convert.lock.d

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

        # Convert the mot file to a binary
        objcopy -I srec -O binary $motfile $outfile

        if [ -f /usr/bin/mailx ]; then
            echo -e "New binfile available here: $outfile" | mailx -n -s "xip bin file update for XiP$model" -r "$mailfr" "$mailto"
        else
            echo -e "New binfile available here: $outfile" | mail -n -s "xip bin file update for XiP$model" "$mailto" -- -F "$mailfr" -f "$mailfr"
        fi
        semaphore_release
    fi
fi
done
