#!/bin/sh

label=$1
outdir=$2

usage ()
{
   echo "Usage poke_913.sh <label> <output directory>"
   echo "Copies files to the output directory. Then, runs DBSPoke on files in 'output directory'. The script assumes the approriate files have been copied to the directory"
   echo
   echo "  Files to copy are located in /vobs/src_tree/build/link/appcreate/"
   echo "   gandalf.mot"
   echo "   gandalf.bin"
   echo "   Production.reg"
   echo "   Production.sign_command"
   echo
}

if [ -z "$label" -o -z "$outdir" ]; then
    usage
    exit 1
fi

if [ ! -d "$outdir" ]; then
    mkdir -p "$outdir"
fi

cleartool catcs > "$outdir"/"$label"NDEA_unsigned.cs
cd /vobs/src_tree/build/link/appcreate
cp gandalf.mot gandalf.bin Production.* "$outdir"
cd "$outdir"

/ccshare/linux/c_files/cart_logs/pokecmdln -d XIP913/XIP913CR_Extend_Production -o "$outdir"/"$label"NDEA_unsigned.hex -c /ccshare/linux/c_files/DBSPoke/dbspoke.cfg --prompt="Hardware ID",NDEA --prompt="Hardware Component IDs",0001010105FF80020A01000000000000000000000000 "$outdir"/gandalf.mot
