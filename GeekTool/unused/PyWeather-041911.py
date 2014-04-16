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
out.append('Weather Report for \033[36m' + noaa['location'])
out.append('\033[0mLast update: \033[36m' + noaa['observation_time_rfc822'].split(',')[1])
out.append('\033[0mConditions: \033[36m' + noaa['weather'])
out.append(u'\033[0mTemperature: \033[36m%.0f° F (%.0f° C)' % (float(noaa['temp_f']), float(noaa['temp_c'])))
try:
  out.append(u'\033[0mWind Chill: \033[36m%s°' % noaa['windchill_f'])
except KeyError:
  pass
try:
  gust = ', \033[0mgusting to \033[36m%s MPH' % noaa['wind_gust_mph']
except KeyError:
  gust = ''
out.append('\033[0mWind: \033[36m%s \033[0mat \033[36m%s MPH%s' % ( noaa['wind_dir'], noaa['wind_mph'], gust))
out.append('\033[0mRelative Humidity: \033[36m%s%%' % noaa['relative_humidity'])
try:
  out.append(u'\033[0mHeat Index: \033[36m%s°' % noaa['heat_index_f'])
except KeyError:
  pass
out.append('\033[0mPressure: \033[36m%2.2f \033[0mand \033[36m%s' % (float(yahoo['atmosphere']['pressure']), ypressure[yahoo['atmosphere']['rising']]))
out.append('\033[0mSunrise: \033[36m%s \033[0mSunset: \033[36m%s\033[0m' % (yahoo['astronomy']['sunrise'], yahoo['astronomy']['sunset']))
day1 = google['forecasts'][0]
day2 = google['forecasts'][1]
day3 = google['forecasts'][2]
day4 = google['forecasts'][3]
out.append('\033[33mForecast:')
out.append(u'''\033[35m %s: \033[36m%s \033[0m(High \033[36m%3d° \033[0mLow \033[36m%3d°\033[0m)''' % ("today", day1['condition'], int(day1['high']), int(day1['low'])))
out.append(u'''\033[35m %s: \033[36m%s \033[0m(High \033[36m%3d° \033[0mLow \033[36m%3d°\033[0m)''' % (day2['day_of_week'], day2['condition'], int(day2['high']), int(day2['low'])))
out.append(u'''\033[35m %s: \033[36m%s \033[0m(High \033[36m%3d° \033[0mLow \033[36m%3d°\033[0m)''' % (day3['day_of_week'], day3['condition'], int(day3['high']), int(day3['low'])))
out.append(u'''\033[35m %s: \033[36m%s \033[0m(High \033[36m%3d° \033[0mLow \033[36m%3d°\033[0m)''' % (day4['day_of_week'], day4['condition'], int(day4['high']), int(day4['low'])))

print '\n'.join(out).encode('utf8')
