#!/usr/bin/python
# -*- coding: utf-8 -*-

import pywapi

# Get the current conditions for the given station.
noaa = pywapi.get_weather_from_noaa('KAPA')
yahoo = pywapi.get_weather_from_yahoo('80112', '')
google = pywapi.get_weather_from_google('80112', '')

# The Yahoo pressure dictionary.
ypressure = {'0': 'steady', '1': 'rising', '2': 'falling'}

# This is the list of output lines.
out = []

# Go through the dictionaries and construct a list of the desired output lines.
out.append(u'%s, %.0f° F (%.0f° C)' % (noaa['weather'],float(noaa['temp_f']), float(noaa['temp_c'])))

print '\n'.join(out).encode('utf8')
