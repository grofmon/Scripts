#!/usr/bin/python
# -*- coding: utf-8 -*-

import pywapi

# Get the current conditions for the given station.
yahoo = pywapi.get_weather_from_yahoo('80112', '')

# This is the list of output lines.
out = []

# Go through the dictionaries and construct a list of the desired output lines.
out.append('Sunrise: %s Sunset: %s' % (yahoo['astronomy']['sunrise'], yahoo['astronomy']['sunset']))

print '\n'.join(out).encode('utf8')
