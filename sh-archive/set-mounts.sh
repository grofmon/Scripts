#!/bin/sh

MOUNT="/Users/monty/Library/Scripts/MountEchostar.scpt"
NETWORK="/Users/monty/Library/Scripts/NetworkSettings.scpt"

# Need the proper DNS servers to mount EchoStar network drives
if [ -f "$NETWORK" ]; then
    osascript "$NETWORK" $@
fi


# Mount/unmount EchoStar networked drives
# Pass argument 'clear' to unmount

if [ -f "$MOUNT" ]; then
    osascript "$MOUNT" $@
else
    echo "$MOUNT script not found"
fi
