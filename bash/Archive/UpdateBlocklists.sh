#!/bin/sh

echo "Killing Transmission"
killall Transmission
echo "Updating Blocklists"

cd /Users/monty/Library/Application\ Support/Transmission/blocklists/
#cd ~/Downloads/bt_test/

urls=(bt_ads bt_templist bt_bogon bt_dshield bt_hijacked pwqnlynprfgtjbgqoizj cslpybexmxyuacbyuvib bcoepfyewziejvcqyhqo bt_level1 bt_level2 bt_level3 bt_rangetest bt_spider bt_spyware ghlzqtqxnzctvvajwwag dcha_faker dcha_hacker ijfqtofzixtwayqovmxn )

file=(bt_ads bt_badpeers bt_bogon bt_dshield bt_hijacked bt_iana-multicast bt_iana-private bt_iana-reserved bt_level1 bt_level2 bt_level3 bt_rangetest bt_spider bt_spyware bt_webexploit dcha_faker dcha_hacker tbg_primarythreats )

# URL                    FILENAME
#--------------------------------
# bt_ads               > bt_ads
# bt_templist          > bt_badpeers
# bt_bogon             > bt_bogon
# bt_dshield           > bt_dshield
# bt_hijacked          > bt_hijacked
# pwqnlynprfgtjbgqoizj > bt_iana-multicast
# cslpybexmxyuacbyuvib > bt_iana-private
# bcoepfyewziejvcqyhqo > bt_iana-reserved
# bt_level1            > bt_level1
# bt_level2            > bt_level2
# bt_level3            > bt_level3
# bt_rangetest         > bt_rangetest
# bt_spider            > bt_spider
# bt_spyware           > bt_spyware
# ghlzqtqxnzctvvajwwag > bt_webexploit
# dcha_faker           > dcha_faker
# dcha_hacker          > dcha_hacker
# ijfqtofzixtwayqovmxn > tbg_primarythreats

for ((i=0; i<${#urls[@]}; i++))
do
    if curl -L -# http://list.iblocklist.com/?list=${urls[$i]} > ${file[$i]}.gz; then
        if gunzip -f ${file[$i]}.gz && rm -f ${file[$i]}.gz; then
            echo "blocklist " ${file[$i]} " updated"
        else
            rm -f ${file[$i]}.gz
            echo "blocklist " ${file[$i]} " not updated"
        fi
    fi
done

echo "Done Updating"
echo "Opening Transmission"
open /Applications/Transmission.app