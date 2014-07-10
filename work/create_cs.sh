#!/bin/sh
config_spec=$1
model=$2
label=$3

if [ -z "$config_spec" -o -z "$model" -o -z "$label" ]; then
    echo "usage: create_cs.sh <config_spec> <model> <label>"
    echo "       where: "
    echo "             config_spec = input config spec with approprirate model tags"
    echo "             model = model to generate output config spec"
    echo "             label = label name for config spec"
    echo ""
    echo "       e.g.  create_cs.sh ~/XIPCOMBINED.cs 913 BRC1"
    echo "     output  XIP913_BRC1.cs"
    exit
fi

sed 's/\#>XIP'$2'\#> //' ${config_spec} > XIP${model}_${label}.cs
sed -i '/#>/d' XIP${model}_${label}.cs
