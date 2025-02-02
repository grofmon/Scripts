#!/bin/sh
config_spec="${1}"

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
./cs.sh
rm cs.sh

