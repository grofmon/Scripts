#!/usr/bin/python
# -*- coding: utf-8 -*-

import pywapi

# Get the current conditions for the given station.
yahoo = pywapi.get_weather_from_yahoo('80112', '')
noaa = pywapi.get_weather_from_noaa('KAPA')
#google = pywapi.get_weather_from_google('80112', '')

# This is the list of output lines.
out = []

# Go through the dictionaries and construct a list of the desired output lines.
out.append(u'\033[32m%s\033[1;37m, \033[36m%.0f° \033[1;37mF (\033[35m%.0f° \033[1;37mC)' % (noaa['weather'],float(noaa['temp_f']), float(noaa['temp_c'])))

day1 = google['forecasts'][0]
day2 = google['forecasts'][1]
day3 = google['forecasts'][2]
day4 = google['forecasts'][3]
out.append(u'''   %s: \033[32m%s\033[1;37m, \033[36m%3d°\033[1;37m/\033[35m%3d°\033[1;37m''' % (day1['day_of_week'], day1['condition'], int(day1['high']), int(day1['low'])))
out.append(u'''   %s: \033[32m%s\033[1;37m, \033[36m%3d°\033[1;37m/\033[35m%3d°\033[1;37m''' % (day2['day_of_week'], day2['condition'], int(day2['high']), int(day2['low'])))
out.append(u'''   %s: \033[32m%s\033[1;37m, \033[36m%3d°\033[1;37m/\033[35m%3d°\033[1;37m''' % (day3['day_of_week'], day3['condition'], int(day3['high']), int(day3['low'])))
out.append(u'''   %s: \033[32m%s\033[1;37m, \033[36m%3d°\033[1;37m/\033[35m%3d°\033[1;37m''' % (day4['day_of_week'], day4['condition'], int(day4['high']), int(day4['low'])))

out.append('\033[1;37mSunrise: \033[33m%s \033[1;37mSunset: \033[33m%s\033[1;37m' % (yahoo['astronomy']['sunrise'], yahoo['astronomy']['sunset']))

print '\n'.join(out).encode('utf8')
