#!/bin/sh
ps=`mktemp -t manpageXXXX`.ps
man -t $@ > "$ps"
open "$ps"