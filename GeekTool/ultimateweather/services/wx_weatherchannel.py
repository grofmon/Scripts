""" WeatherChannel
 ROBERT WOLTERMAN (xtacocorex) - 2012

 GRABS THE WEATHER FROM THE WEATHER CHANNEL SITE
 
 THIS CLASS INHERITS FROM forecasts.Forecasts 
"""

# MODULE IMPORTS
from globals          import *
from utilityfunctions import *
import forecasts

# CHANGELOG
# 21 APRIL 2012
#  - EXTRACTION FROM THE MAIN SCRIPT AND PUT INTO THE SERVICES MODULE
#  - KNOWN ISSUES: *** CURRENTLY NOT FULLY IMPLEMENTED ***

class WeatherChannel(forecasts.Forecasts):
    def __init__(self):
        self.baseimgurl = ""
        # INITIALIZE THE INHERITED CLASS
        forecasts.Forecasts.__init__(self)

    def setURL(self,opts):
        # FIGURE OUT OUR URL FOR WORK
        print "setURL not implemented yet"
        if   opts.weatherdotcomfcasttype == 'current':
            # DETERMINE IF WE ARE USING A HARDCODED URL
            if opts.url != '':
                # YOU ARE ON YOUR OWN FOR PROVIDING UNITS WITH THE HARD CODED URL
                yqlquery = 'select * from html where url="%s"' % opts.url
            else:
                if opts.metric:
                    u = "c"
                else:
                    u = "f"
                mytuple = (self.location.locid,u)
                yqlquery = 'select * from html where url="http://www.weather.com/weather/today/%s"' % self.location.locid
            # FIGURE OUT WHAT WE WANT TO GET FROM THE YQL
            ender = ' and xpath=\'//table[@class="twc-forecast-table twc-second"]\''
            # CREATE THE URL
            self.url = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
            if opts.debug:
                print "\n*** current url creation"
                print yqlquery
                print self.url
                print DEBUGSPACER
        elif opts.weatherdotcomfcasttype == 'tomorrow':
            print "tomorrow"
        elif opts.weatherdotcomfcasttype == 'fiveday':
            print "fiveday"
        elif opts.weatherdotcomfcasttype == 'tenday':
            print "tenday"
    
    def parseData(self,opts):
        # CLEAR OUT THE FORECAST LIST
        self.forecasts = []
        # DETERMINE WHAT WE ARE PARSING
        if   opts.weatherdotcomfcasttype == 'current':
            print "current"
        elif opts.weatherdotcomfcasttype == 'tomorrow':
            print "tomorrow"
        elif opts.weatherdotcomfcasttype == 'fiveday':
            print "fiveday"
        elif opts.weatherdotcomfcasttype == 'tenday':
            print "tenday"

    def printForecasts(self, opts):
        # DETERMINE IF WHAT WE ARE PRINTING
        print "print forecasts not implemented"
        if   opts.weatherdotcomfcasttype == 'current':
            print "current"
        elif opts.weatherdotcomfcasttype == 'tomorrow':
            print "tomorrow"
        elif opts.weatherdotcomfcasttype == 'fiveday':
            print "fiveday"
        elif opts.weatherdotcomfcasttype == 'tenday':
            print "tenday"
