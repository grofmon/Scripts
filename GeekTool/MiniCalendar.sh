#!/bin/sh
echo "Su Mo Tu We Th Fr Sa"
cal | grep -v "[a-zA-Z*] [0-9]" | grep -v "Su"
