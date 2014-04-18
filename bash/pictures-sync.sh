#!/bin/sh
#rsync --dry-run -av --ignore-existing --exclude *.aplibrary --exclude *.photolibrary --exclude *.lytrolib  --exclude "Photo Booth Library"* /Volumes/lori/Pictures/ Pictures/

rsync --dry-run -av --delete ~/Pictures/ /Volumes/monty/Pictures/