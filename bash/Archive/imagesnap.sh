#!/bin/sh

if [ ! -d /Users/monty/Downloads/images ]; then
 mkdir /Users/monty/Downloads/images
fi

IMAGE="/Users/monty/Downloads/images/"`date "+%m%d%y-%H%M%S"`".jpg"
echo $IMAGE

/usr/local/bin/imagesnap $IMAGE

#open $IMAGE