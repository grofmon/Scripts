#!/bin/bash

sudo /sbin/modprobe -r ftdi_sio

# Use these vendor and product id combination for Echo* USB Serial dongle.
sudo /sbin/modprobe ftdi_sio vendor=0x046D product=0xC00C
