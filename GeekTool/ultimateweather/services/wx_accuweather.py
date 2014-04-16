""" AccuWeather
 ROBERT WOLTERMAN (xtacocorex) - 2012

 GRABS THE WEATHER FROM THE ACCUWEATHER SITE
 
 THIS CLASS INHERITS FROM forecasts.Forecasts 
 
 *** THIS CURRENTLY DOES NOT SUPPORT THE FOLLOWING ***
     IMAGE DOWNLOAD
     METRIC UNITS
 
 *** ONLY TESTED FOR US LOCATIONS ***
 
"""

# MODULE IMPORTS
from globals          import *
from utilityfunctions import *
import forecasts

# CHANGELOG
# 04 AUGUST 2012
#  - ADDED SUPPORT FOR PRINTING THE DEGREE SYMBOL, REQUIRES GEEKLET TO BE SET TO UNICODE
# 28 JULY 2012
#  - MAKING THIS ACTUALLY WORK SINCE IT WASN'T DOING ANYTHING BEFORE
#  - THIS WILL ONLY DO US UNITS FOR THE TIME BEING
#  - WILL NOT DO IMAGE DOWNLOADING :( -> YAHOO QUERY STUFF REMOVES THE HTML CODE
#    THAT I CAN USE TO GET A START AT FINDING THE IMAGE INFORMATION
# 21 APRIL 2012
#  - INITIAL WRITE

# ACCUWEATHER IMAGE URL MAP
ACCUWXIMGMAP = {
"day-i-su"     : "http://vortex.accuweather.com/adc2010/images/icons-day/su-m.png",
"day-i-msu"    : "http://vortex.accuweather.com/adc2010/images/icons-day/msu-m.png",
"day-i-psu"    : "http://vortex.accuweather.com/adc2010/images/icons-day/psu-m.png",
"day-i-ic"     : "http://vortex.accuweather.com/adc2010/images/icons-day/ic-m.png",
"day-i-h"      : "http://vortex.accuweather.com/adc2010/images/icons-day/h-m.png",
"day-i-mc"     : "http://vortex.accuweather.com/adc2010/images/icons-day/mc-m.png",
"day-i-c"      : "http://vortex.accuweather.com/adc2010/images/icons-day/c-m.png",
"night-i-c"    : "http://vortex.accuweather.com/adc2010/images/icons-day/c-m.png",
"day-i-d"      : "http://vortex.accuweather.com/adc2010/images/icons-day/d-m.png",
"night-i-d"    : "http://vortex.accuweather.com/adc2010/images/icons-day/d-m.png",
"day-i-f"      : "http://vortex.accuweather.com/adc2010/images/icons-day/f-m.png",
"night-i-f"    : "http://vortex.accuweather.com/adc2010/images/icons-day/f-m.png",
"day-i-s"      : "http://vortex.accuweather.com/adc2010/images/icons-day/s-m.png",
"night-i-s"    : "http://vortex.accuweather.com/adc2010/images/icons-day/s-m.png",
"day-i-mcs"    : "http://vortex.accuweather.com/adc2010/images/icons-day/mcs-m.png",
"day-i-psus"   : "http://vortex.accuweather.com/adc2010/images/icons-day/psus-m.png",
"day-i-t"      : "http://vortex.accuweather.com/adc2010/images/icons-day/t-m.png",
"night-i-t"    : "http://vortex.accuweather.com/adc2010/images/icons-day/t-m.png",
"day-i-mct"    : "http://vortex.accuweather.com/adc2010/images/icons-day/mct-m.png",
"day-i-psut"   : "http://vortex.accuweather.com/adc2010/images/icons-day/psut-m.png",
"day-i-r"      : "http://vortex.accuweather.com/adc2010/images/icons-day/r-m.png",
"night-i-r"    : "http://vortex.accuweather.com/adc2010/images/icons-day/r-m.png",
"day-i-fl"     : "http://vortex.accuweather.com/adc2010/images/icons-day/fl-m.png",
"night-i-fl"   : "http://vortex.accuweather.com/adc2010/images/icons-day/fl-m.png",
"day-i-mcfl"   : "http://vortex.accuweather.com/adc2010/images/icons-day/mcfl-m.png",
"day-i-psfl"   : "http://vortex.accuweather.com/adc2010/images/icons-day/psfl-m.png",
"day-i-sn"     : "http://vortex.accuweather.com/adc2010/images/icons-day/sn-m.png",
"night-i-sn"   : "http://vortex.accuweather.com/adc2010/images/icons-day/sn-m.png",
"day-i-mcsn"   : "http://vortex.accuweather.com/adc2010/images/icons-day/mcsn-m.png",
"day-i-i"      : "http://vortex.accuweather.com/adc2010/images/icons-day/i-m.png",
"night-i-i"    : "http://vortex.accuweather.com/adc2010/images/icons-day/i-m.png",
"day-i-sl"     : "http://vortex.accuweather.com/adc2010/images/icons-day/sl-m.png",
"night-i-sl"   : "http://vortex.accuweather.com/adc2010/images/icons-day/sl-m.png",
"day-i-fr"     : "http://vortex.accuweather.com/adc2010/images/icons-day/fr-m.png",
"night-i-fr"   : "http://vortex.accuweather.com/adc2010/images/icons-day/fr-m.png",
"day-i-rsn"    : "http://vortex.accuweather.com/adc2010/images/icons-day/rsn-m.png",
"night-i-rsn"  : "http://vortex.accuweather.com/adc2010/images/icons-day/rsn-m.png",
"day-i-w"      : "http://vortex.accuweather.com/adc2010/images/icons-day/w-m.png",
"day-i-ho"     : "http://vortex.accuweather.com/adc2010/images/icons-day/ho-m.png",
"day-i-co"     : "http://vortex.accuweather.com/adc2010/images/icons-day/co-m.png",
"night-i-cl"   : "http://vortex.accuweather.com/adc2010/images/icons-night/cl-m.png",
"night-i-w"    : "http://vortex.accuweather.com/adc2010/images/icons-night/w-m.png",
"night-i-mcl"  : "http://vortex.accuweather.com/adc2010/images/icons-night/mcl-m.png",
"night-i-pc"   : "http://vortex.accuweather.com/adc2010/images/icons-night/pc-m.png",
"night-i-ic"   : "http://vortex.accuweather.com/adc2010/images/icons-night/ic-m.png",
"night-i-h"    : "http://vortex.accuweather.com/adc2010/images/icons-night/h-m.png",
"night-i-mc"   : "http://vortex.accuweather.com/adc2010/images/icons-night/mc-m.png",
"night-i-pcs"  : "http://vortex.accuweather.com/adc2010/images/icons-night/pcs-m.png",
"night-i-mcs"  : "http://vortex.accuweather.com/adc2010/images/icons-night/mcs-m.png",
"night-i-pct"  : "http://vortex.accuweather.com/adc2010/images/icons-night/pct-m.png",
"night-i-mct"  : "http://vortex.accuweather.com/adc2010/images/icons-night/mct-m.png",
"night-i-mcfl" : "http://vortex.accuweather.com/adc2010/images/icons-night/mcfl-m.png",
"night-i-mcsn" : "http://vortex.accuweather.com/adc2010/images/icons-night/mcsn-m.png",
"night-i-ho"   : "http://vortex.accuweather.com/adc2010/images/icons-day/ho-m.png",
"night-i-co"   : "http://vortex.accuweather.com/adc2010/images/icons-day/co-m.png"
               }

class ACCUWeather(forecasts.Forecasts):
    def __init__(self):
        self.baseimgurl = ""
        # INITIALIZE THE INHERITED CLASS
        forecasts.Forecasts.__init__(self)
                
    def setURL(self,opts):

        if opts.accuwxfcasttype == 'current':
            # DETERMINE IF WE ARE USING A HARDCODED URL
            if opts.url != '':
                # YOU ARE ON YOUR OWN FOR PROVIDING UNITS WITH THE HARD CODED URL
                yqlquery = 'select * from html where url="%s"' % opts.url
            else:
                #if opts.metric:
                #    u = "c"
                #else:
                #    u = "f"
                citystate = self.location.city.replace(" ","-") + "-" + USSTATEMAP[self.location.stprov.title()].lower()
                yqlquery = 'select * from html where url="http://www.accuweather.com/en/us/%s/%s/current-weather/"' % (citystate,self.location.zipcode)
            ender = ' and xpath=\'//div[@id="detail-now"] \''
            self.url = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
            if opts.debug:
                print "\n*** currenturl creation"
                print yqlquery
                print self.url
                print DEBUGSPACER
        elif opts.accuwxfcasttype == 'multiday':
            # DETERMINE IF WE ARE USING A HARDCODED URL
            if opts.url != '':
                # YOU ARE ON YOUR OWN FOR PROVIDING UNITS WITH THE HARD CODED URL
                yqlquery = 'select * from html where url="%s"' % opts.url
            else:
                #if opts.metric:
                #    u = "c"
                #else:
                #    u = "f"
                citystate = self.location.city.replace(" ","-") + "-" + USSTATEMAP[self.location.stprov.title()].lower()
                yqlquery = 'select * from html where url="http://www.accuweather.com/en/us/%s/%s/daily-weather-forecast/"' % (citystate,self.location.zipcode)
            # FIGURE OUT WHAT WE WANT TO GET FROM THE YQL
            ender = ' and xpath=\'//div[@id="feed-tabs"]\''
            # CREATE THE URL
            self.url = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
            if opts.debug:
                print "\n*** multiday url creation"
                print yqlquery
                print self.url
                print DEBUGSPACER
    
    def parseData(self,opts):
        # CLEAR OUT THE FORECAST LIST
        self.forecasts = []
        # CREATE OUR UNITS DICTIONARY
        self.units = {'temperature' : '',
                      'pressure'    : '',
                      'distance'    : '',
                      'speed'       : '',
                      'sriseperiod' : '',
                      'ssetperiod'  : ''
                      }
    
        # DETERMINE IF WHAT WE ARE PARSING
        if   opts.accuwxfcasttype == 'current':
            # GET THE CURRENT CONDITION
            tmpfcast = forecasts.FCDay()
            tmpfcast.condition  = self.jsondata['query']['results']['div']['div']['div'][0]['div']['span'][0]['content']
            tmp = replaceNonAscii(self.jsondata['query']['results']['div']['div']['div'][0]['div']['p']['span']['content']," ")
            tmpfcast.tempfeeel  = tmp.split(" ")[1]
            tmpfcast.curtemp    = self.jsondata['query']['results']['div']['div']['div'][0]['div']['span'][1]['content']
            self.units['temperature'] = "F"   # FORCING THIS TO NON METRIC
            # NEED TO FIGURE OUT HOW TO GET THE IMAGEs
            # CREATE STRING TO MAP INTO THE IMAGE URL DICTIONARY
            #tmpstring = ""
            #tmpfcast.imageurl   = "" #ACCUWXIMGMAP[tmpstring}
            #fext = tmpfcast.imageurl[-4:]
            #getImage(tmpfcast.imageurl,"accuweather_current_wx"+fext,IMAGESAVELOCATION)
            tmpfcast.humidity   = self.jsondata['query']['results']['div']['div']['div'][1]['ul']['li'][0]['p']['strong']
            tmp = replaceNonAscii(self.jsondata['query']['results']['div']['div']['div'][1]['ul']['li'][1]['p']['strong']," ")
            tmp = tmp.split(" ")
            tmpfcast.pressure      = tmp[0]
            self.units['pressure'] = tmp[1]
            tmp = replaceNonAscii(self.jsondata['query']['results']['div']['div']['div'][1]['ul']['li'][6]['p']['strong']," ")
            tmp = tmp.split(" ")
            tmpfcast.visibility    = tmp[0]
            self.units['distance'] = tmp[1].lower()    # THIS IS IN TITLE CASE ON THE WEBSITEs

            # APPEND THIS TO THE FORECAST LIST
            self.forecasts.append(tmpfcast)
            # DEBUG
            if opts.debug:
                print tmpfcast
            
        elif opts.accuwxfcasttype == 'multiday':
            # GET THE NUMBER OF ITEMS IN THE FORECAST
            self.numfcasts      = len(self.jsondata['query']['results']['div']['ul']['li'])
            # LOOP THROUGH AND GET THE FORECAST DATA
            for i in xrange(self.numfcasts):
                # GET THE CURRENT CONDITION
                tmpfcast = forecasts.FCDay()
                tmpfcast.condition  = self.jsondata['query']['results']['div']['ul']['li'][i]['div']['div']['span'][0]['content']
                tmpfcast.day        = self.jsondata['query']['results']['div']['ul']['li'][i]['div']['h3']['a']['content']
                tmpfcast.date       = self.jsondata['query']['results']['div']['ul']['li'][i]['div']['h4']
                #tmpfcast.imageurl   = "" #self.baseimgurl % tmpfcast.code
                #fext = tmpfcast.imageurl[-4:]
                #myfname = "accuweather_fcast_day%d%s" % (i+1,fext)
                #getImage(tmpfcast.imageurl,myfname,IMAGESAVELOCATION)
                tmpfcast.high       = self.jsondata['query']['results']['div']['ul']['li'][i]['div']['div']['strong']['content']
                tmpfcast.low        = removeNonAscii(self.jsondata['query']['results']['div']['ul']['li'][i]['div']['div']['span'][1]['content']).lstrip()
                # APPEND THIS TO THE FORECAST LIST
                self.forecasts.append(tmpfcast)
                # DEBUG
                if opts.debug:
                    print tmpfcast

        
    def printForecasts(self, opts):
        # DETERMINE IF WHAT WE ARE PRINTING
        if   opts.accuwxfcasttype == 'current':
            if opts.degreesymbol:
                u = DEGREE+self.units['temperature']
            else:
                u = self.units['temperature']
            if opts.currentoutputtype == 'simple':
                print "%s %s%s" % (self.forecasts[0].condition,self.forecasts[0].curtemp,u)
            if opts.currentoutputtype == 'detailed':
                print "Condition:   %s"    % (self.forecasts[0].condition)
                print "Temperature: %s%s"  % (self.forecasts[0].curtemp,u)
                print "Humidity:    %s"    % (self.forecasts[0].humidity)
                print "Pressure:    %s %s" % (self.forecasts[0].pressure,self.units['pressure'])
                print "Visibility:  %s %s" % (self.forecasts[0].visibility,self.units['distance'])
            if not opts.hideprovides:
                print "accuweather.com"
        elif opts.accuwxfcasttype == 'multiday':
            # FIGURE OUT HOW USER WANTS DATA DISPLAYED
            if opts.orientation == 'vertical':
                # LOOP THROUGH THE NUMBER THE USER SPECIFIED
                # THE CHECK FOR THIS VALUE WILL HAVE BEEN DONE WHEN THE PROGRAM STARTS
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                mystr1 = "%s: %s\n%s\nH: %3s%s L: %3s%s\n"
                mystr2 = "%s: %s\n%s\nH: %3s%s L: %3s%s"
                for i in xrange(opts.accuweathernumdays):
                    u = self.units['temperature']
                    mytuple = (self.forecasts[i].date,self.forecasts[i].day,self.forecasts[i].condition.title(),self.forecasts[i].high,u,self.forecasts[i].low,u)
                    if i != opts.accuweathernumdays-1:
                        print mystr1 % mytuple
                    else:
                        print mystr2 % mytuple
            elif opts.orientation == 'horizontal':
                mystr1 = "%16s"
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                mystr2 = "High: %3s%s"
                mystr3 = "Low:  %3s%s"
                datelist = []
                highlist = []
                lowlist  = []
                condlist = []
                for i in xrange(opts.accuweathernumdays):
                    tmp = mystr1 % (self.forecasts[i].date + ": " + self.forecasts[i].day).ljust(16)
                    datelist.append(tmp)
                    condlist.append(self.forecasts[i].condition.title())
                    tmp = mystr2 % (self.forecasts[i].high,u)
                    highlist.append(tmp)
                    tmp = mystr3 % (self.forecasts[i].low,u)
                    lowlist.append(tmp)
                # CREATE OUR MATRIX
                matrix = [datelist,condlist,highlist,lowlist]
                # PRINT THE TABLE
                printTable(matrix,(4,opts.accuweathernumdays),'left')
            if not opts.hideprovides:
                print "accuweather.com"

