#!/usr/bin/python
# -*- coding: utf-8 -*-

import pywapi

# Get the current conditions for the given station.
noaa = pywapi.get_weather_from_noaa('KAPA')
# This is the list of output lines.
out = []

# Go through the dictionaries and construct a list of the desired output lines.
out.append(noaa['weather'])

print '\n'.join(out).encode('utf8')
