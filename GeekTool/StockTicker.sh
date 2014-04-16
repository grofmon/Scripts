#!/bin/bash
# Stock Data Grabber - Version 2
# Robert Wolterman - 2010
# Pulls data from a list of stocks for easier use in geektool
# Original web page parsing found on macrumers.com forum

# OUTPTYPE OF -c IS FOR COLORED OUTPUT
# OUTPTYPE OF -n IS FOR NONCOLORED OUTPUT
OUTPTYPE="-c"

# SETS UP THE VARIABLE FOR THE TICKER FILE
TICKFILE="/Users/monty/Library/Scripts/GeekTool/StockTicker.txt"

# Sets the variable for the tmp file
TMPFILE="/tmp/geektool/stockticker.txt"

# Check for ethernet connection
ping -c 1 www.google.com >/dev/null 2>&1
ret="$?"


TODAY=`date "+%a"`
TIME=`date "+%H"`
if [ "$TODAY" = "Sat" -o "$TODAY" = "Sun" ]; then
    echo ""
    echo "Stock Market Closed Today"
    CLOSED="true"
elif [ $TIME -lt 07 -o $TIME -gt 14 ]; then
    echo ""
    echo "Stock Market Closed For The Day"
    CLOSED="true"
fi

if [ ! -d /tmp/geektool ]; then
    mkdir /tmp/geektool
fi

# if i have an inet connection
if [ "$ret" = "0" ]; then
    if [ "$CLOSED" != "true" ]; then
        # clear out old stockfile when script updates
        rm $TMPFILE

        # GET DATA FROM THE FILE
        cat $TICKFILE | while read line
        do 
            tmp="${line:0:1}"
            if [ $tmp != "#" ]; then
                MARKET=`echo "${line}" | cut -d " " -f1`
                SYMBOL=`echo "${line}" | cut -d " " -f2`
            
            # FOR THE ACTUAL NASDAQ, DOW JONES, OR S&P 500 INDEX
                if [ "$MARKET" = "INDEXNASDAQ:.IXIC" ] || [ "$MARKET" = "INDEXDJX:.DJI" ] || [ "$MARKET" = "INDEXSP:.INX" ]; then
                    URL=http://www.google.com/finance?q=$MARKET
            # GENERAL STOCKS
                elif [ "$MARKET" = "NYSE" ] || [ "$MARKET" = "NASDAQ" ] || [ "$MARKET" = "AMEX" ] || [ "$MARKET" = "EPA" ] || [ "$MARKET" = "AMEX" ] || [ "$MARKET" = "TSE" ] || [ "$MARKET" = "LON" ] || [ "$MARKET" = "ETR" ] || [ "$MARKET" = "OTC" ]; then
                    URL=http://www.google.com/finance?q=$MARKET:$SYMBOL
                else
                    echo "No input given"
                fi                            
                # DOWNLOAD FILE TO /TMP
                curl --silent $URL > /tmp/geektool/$SYMBOL.stock

            # COMPANY ID
            COMPID=`grep '_chartConfigObject.companyId =' /tmp/geektool/$SYMBOL.stock | cut -d '=' -f2 | cut -d ';' -f1 | cut -d " " -f2  | sed s/\'//g`
            # VALUE
            STKVAL=`grep "ref_$COMPID\_l" /tmp/geektool/$SYMBOL.stock | cut -d ">" -f2 | cut -d "<" -f1`
            # VALUE OF CHANGE IN DOLLARS
            CHANGEVAL=`grep "id=\"ref_$COMPID\_c" /tmp/geektool/$SYMBOL.stock | cut -d ">" -f3 | cut -d "<" -f1`
            # GET THE PLUS/MINUS OF THE CHANGE
            PNE=${CHANGEVAL:0:1}
            # VALUE OF CHANGE IN PERCENT
            CHANGEPER=`grep "id=\"ref_$COMPID\_cp" /tmp/geektool/$SYMBOL.stock | cut -d ">" -f2 | cut -d "<" -f1`
            # FIGURE OUT COLOR FOR POS/NEG CHANGE AND ECHO TO THE TMP FILE
            if [ "$PNE" == "-" ]; then
                # NEGATIVE CHANGE
                BCOL="-"
            elif [ "$PNE" == "+" ]; then
                # POSITIVE CHANGE
                BCOL="+"
            else
                # NO CHANGE
                BCOL="="
            fi
            
            # Shorten some symbol names for display
        #    if [ "$SYMBOL" = "DOW" ]; then
        #        SYMBOL="DOW "
        #    elif [ "$SYMBOL" = "NASDAQ" ]; then
        #        SYMBOL="NSDQ"
        #    elif [ "$SYMBOL" = "S&P-500" ]; then
        #        SYMBOL="S&P "
        #    fi

            # DEPENDING ON OUTPTYPE, PERFORM THE PROPER ACTION
            if [ $OUTPTYPE == "-n" ]; then
                # DUMP DATA INTO THE TEMP FILE TO ENABLE TABLE CREATION
                echo $SYMBOL: $STKVAL $CHANGEVAL $CHANGEPER >> $TMPFILE
            elif [ $OUTPTYPE == "-c" ]; then
                # DUMP DATA INTO THE TEMP FILE FOR COLOR TABLE CREATION
                echo $BCOL";"$SYMBOL";"$STKVAL";"$CHANGEVAL";"$CHANGEPER >> $TMPFILE
            fi
        fi
    done
fi

    if [ "$CLOSED" = "true" ]; then
        OUTPTYPE="-x"
    fi
    if [ $OUTPTYPE == "-n" ]; then
        # OUTPUT TO A TABLE
        (printf "%s\t%s\t%s\t%s\n"; cat $TMPFILE) | column -t
    elif [ $OUTPTYPE == "-c" ]; then
            # OUTPUT COLORS
        awk 'BEGIN{FS=";";}{ 
               if ($1 == "+")
                 printf "\033[1;37m%-10s\033[36m%-12s\033[32m%-8s%-8s\n",$2,$3,$4,$5;
               else if ($1 == "-")
                 printf "\033[1;37m%-10s\033[36m%-12s\033[31m%-8s%-8s\n",$2,$3,$4,$5;
               else
                 printf "\033[1;37m%-10s\033[36m%-12\033[1;37ms%-8s%-8s\n",$2,$3,$4,$5;
             }' $TMPFILE
    else
        awk 'BEGIN{FS=";";}{ 
               if ($2 == "SATS")
                 printf "\033[1;37m%-10s%-12s%-8s%-8s\n",$2,$3,$4,$5;
               else if ($2 == "DISH")
                 printf "\033[1;37m%-10s%-12s%-8s%-8s\n",$2,$3,$4,$5;
             }' $TMPFILE
    fi
fi
