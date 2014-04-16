#!/bin/sh

SATS=`curl http://www.google.com/finance?q=SATS | sed -n '/price-panel style/,/ Close/p' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed '/^$/d' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | head -1 | awk '{print $1 "\t" $2 "\t" $3}'`
DISH=`curl http://www.google.com/finance?q=DISH | sed -n '/price-panel style/,/ Close/p' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed '/^$/d' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | head -1 | awk '{print $1 "\t" $2 "\t" $3}'`
DOW=`curl http://www.google.com/finance?q=INDEXDJX:.DJI | sed -n '/price-panel style/,/ Close/p' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed '/^$/d' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | head -1 | awk '{print $1 "\t" $2 "\t" $3}'`
NASDAQ=`curl http://www.google.com/finance?q=INDEXNASDAQ:.IXIC | sed -n '/price-panel style/,/ Close/p' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed '/^$/d' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | head -1 | awk '{print $1 "\t" $2 "\t" $3}'`
SP500=`curl http://www.google.com/finance?q=INDEXSP:.INX | sed -n '/price-panel style/,/ Close/p' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed '/^$/d' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | head -1 | awk '{print $1 "\t" $2 "\t" $3}'`

HEADER=`echo "VOL/PRICE CHANGE %" | awk '{print $1 "\t" $2 "\t" $3}'`

if [ ! -z "$SATS" ]; then
    echo "STOCK     : $HEADER"
    echo "DOW JONES : $DOW"
    echo "S&P 500   : $SP500"
    echo "NADAQ     : $NASDAQ"
    echo "DISH      : $DISH"
    echo "SATS      : $SATS"
fi
