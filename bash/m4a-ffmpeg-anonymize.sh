#!/bin/sh
find . -iname "*.m4a" -exec ffmpeg -i {} -acodec copy {}.new.m4a \;