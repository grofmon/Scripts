#!/bin/sh

array=( 110 813 913)

for prod in "${array[@]}"
do

backup_dir=/ccshare/linux/c_files/xip/$prod/cs_diffs
month=`date +%m`
year=`date +%Y`
cd $backup_dir
echo "Backup files for $prod CS Diffs:"
ls cs_diff_*.txt
tar czvf archive-"$year"-"$month".tgz cs_diff_*.txt
rm cs_diff_*.txt
done
