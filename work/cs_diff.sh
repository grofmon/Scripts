#!/bin/sh
cmd=${0##/*/}
exe=`echo $cmd | sed 's/.\///'`

config_spec="/home/monty/config_specs/cs/TIP"

echo ""
# First build the initial script, this is needed since we include /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >  tmp1
cat ${config_spec} | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp1
chmod +x tmp1
# Next, create the secondary script to expand /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >  tmp2
./tmp1 | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp2
rm tmp1
chmod +x tmp2
# Finally, expand the versions of all files included in /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >>  tmp3
./tmp2 | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp3
cat tmp3 | sed 's/\/cat\//\/include\//' > cs.sh
rm tmp2 tmp3
chmod +x cs.sh
./cs.sh > /home/monty/config_specs/t
rm cs.sh


config_spec="/home/monty/config_specs/cs/XIPCS.cs"

echo ""
# First build the initial script, this is needed since we include /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >  tmp1
cat ${config_spec} | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp1
chmod +x tmp1
# Next, create the secondary script to expand /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >  tmp2
./tmp1 | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp2
rm tmp1
chmod +x tmp2
# Finally, expand the versions of all files included in /ccshare/linux/c_spec/${config_spec}
echo "#!/bin/sh" >>  tmp3
./tmp2 | sed 's/include/cat/' | sed 's/element/echo \"element/'  | sed '/echo /s/$/"/' >> tmp3
cat tmp3 | sed 's/\/cat\//\/include\//' > cs.sh
rm tmp2 tmp3
chmod +x cs.sh
./cs.sh > /home/monty/config_specs/x
rm cs.sh

cd /home/monty/config_specs

#diff -d -U 0 x t | sed ' /+++/d ; /---/d ; s/element .*\.\.\. //g ; s/ \-nocheckout//g ; s/@@.*@@/\n-- Version difference Olympia=(-) TIP=(+) --/g'

diff -d -U 0 x t | sed ' /+++/d ; /---/d ; s/element .*\.\.\. //g ; s/ \-nocheckout//g ; s/@@.*@@//g ; s/^-/OLY-> /g ; s/^+/TIP+> /g'
