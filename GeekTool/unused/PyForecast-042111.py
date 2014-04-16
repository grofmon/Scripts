#!/usr/bin/python
# -*- coding: utf-8 -*-

import pywapi

# Get the current conditions for the given station.
google = pywapi.get_weather_from_google('80112', '')

# This is the list of output lines.
out = []

# Go through the dictionaries and construct a list of the desired output lines.
day1 = google['forecasts'][0]
day2 = google['forecasts'][1]
day3 = google['forecasts'][2]
day4 = google['forecasts'][3]
out.append(u'''%s: %s, %3d°/%3d°''' % (day1['day_of_week'], day1['condition'], int(day1['high']), int(day1['low'])))
out.append(u'''%s: %s, %3d°/%3d°''' % (day2['day_of_week'], day2['condition'], int(day2['high']), int(day2['low'])))
out.append(u'''%s: %s, %3d°/%3d°''' % (day3['day_of_week'], day3['condition'], int(day3['high']), int(day3['low'])))
out.append(u'''%s: %s, %3d°/%3d°''' % (day4['day_of_week'], day4['condition'], int(day4['high']), int(day4['low'])))

print '\n'.join(out).encode('utf8')
