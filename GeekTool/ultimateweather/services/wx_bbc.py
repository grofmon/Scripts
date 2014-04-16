""" BBC
 ROBERT WOLTERMAN (xtacocorex) - 2012

 GRABS THE WEATHER FROM THE BBC WEATHER SITE
 
 THIS CLASS INHERITS FROM forecasts.Forecasts 
 
 YOU HAVE TO SPECIFY A URL FOR THIS, CURRENTLY
 DO NOT HAVE AUTOMATIC LOCATION GRABBING WORKING
 
 THIS WILL ONLY BE METRIC UNITS
 
 IMAGE GRABBING WON'T WORK FOR THE TIME BEING
 DUE TO THE IMAGE BEING A MAP
"""

# MODULE IMPORTS
from globals          import *
from utilityfunctions import *
import forecasts

# CHANGELOG
# 04 AUGUST 2012
#  - ADDED SUPPORT FOR PRINTING THE DEGREE SYMBOL, REQUIRES GEEKLET TO BE SET TO UNICODE
# 29 JULY 2012
#  - INITIAL WRITE

class BBCWeather(forecasts.Forecasts):
    def __init__(self):
        # INITIALIZE THE INHERITED CLASS
        forecasts.Forecasts.__init__(self)

    def setURL(self,opts):
        # FIGURE OUT OUR URL FOR WORK
        # DETERMINE IF WE ARE USING A HARDCODED URL
        if opts.url != '':
            # YOU ARE ON YOUR OWN FOR PROVIDING UNITS WITH THE HARD CODED URL
            yqlquery = 'select * from html where url="%s"' % opts.url
        else:
            #if self.location.country == "united states":
            #    wquery = "%s+%s" % (self.location.city.replace(" ","+"),self.location.stprov.replace(" ","+"))
            #else:
            #    wquery = "%s+%s+%s" % (self.location.city.replace(" ","+"),self.location.stprov.replace(" ","+"),self.location.country.replace(" ","+"))
            #yqlquery = 'select * from html where url="http://www.wunderground.com/cgi-bin/findweather/hdfForecast?query=%s"' % wquery
            print "NEED TO SPECIFY URL, SCRIPT EXITING"
        # FIGURE OUT WHAT WE WANT TO GET FROM THE YQL
        if   opts.bbcfcasttype == 'current':
            # THE TOOL IN OPERA THAT ALLOWS YOU TO EXPLORE HTML SOURCE IS AWESOME
            ender = ' and xpath=\'//div[@class="observationsRecord"]\''
        elif opts.bbcfcasttype == 'multiday':
            ender = ' and xpath=\'//div[@class="daily-window"]\''
        self.url = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
        if opts.debug:
            print "\n*** bbc url creation"
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
                      'speed'       : ''
                      }
        # DETERMINE WHAT WE ARE PARSING
        if   opts.bbcfcasttype == 'current':
            # GET THE CURRENT CONDITION
            tmpfcast = forecasts.FCDay()
            # IMAGE IS SHOWN ON WEBSITE, BUT IT IS A HUGE IMAGE MAP AND CANNOT BE EASILY MANIPULATED :(
            #tmpfcast.imageurl   = self.jsondata['query']['results']['div']['p'][0]['span']['img']['src']
            #fext = tmpfcast.imageurl[-4:]
            #getImage(tmpfcast.imageurl,"bbc_current_wx"+fext,IMAGESAVELOCATION)
            # CONDITION
            tmpfcast.condition  = self.jsondata['query']['results']['div']['p'][0]['span']['title']
            # TEMPERATURE
            if opts.metric:
                tmpfcast.curtemp          = self.jsondata['query']['results']['div']['p'][1]['span']['span']['span'][0]['content'].rstrip()
                self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['p'][1]['span']['span']['span'][0]['span']['content'])
            else:
                tmpfcast.curtemp          = self.jsondata['query']['results']['div']['p'][1]['span']['span']['span'][1]['content'].rstrip()
                self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['p'][1]['span']['span']['span'][1]['span']['content'])
            # =============
            # WIND STUFF MAY NOT WORK IF THERE IS NO WIND, CANNOT TEST AS I HAVEN'T FOUND A LOCATION THAT HAS 0 WIND
            # WINDSPEED
            if opts.metric:
                tmpfcast.windspeed  = self.jsondata['query']['results']['div']['p'][2]['span']['span'][0]['span']['span'][0]['content'].rstrip()
                self.units['speed'] = self.jsondata['query']['results']['div']['p'][2]['span']['span'][0]['span']['span'][0]['span']['content']
            else:
                tmpfcast.windspeed  = self.jsondata['query']['results']['div']['p'][2]['span']['span'][0]['span']['span'][1]['content'].rstrip()
                self.units['speed'] = self.jsondata['query']['results']['div']['p'][2]['span']['span'][0]['span']['span'][1]['span']['content']
            # WIND DIRECTION
            tmpfcast.winddir    = self.jsondata['query']['results']['div']['p'][2]['span']['span'][1]['content']
            # =============
            # PRESSURE
            tmpfcast.pressure   = self.jsondata['query']['results']['div']['div']['p'][2]['span']['content'].replace(",","")
            # VISIBILITY
            tmpfcast.visibility = self.jsondata['query']['results']['div']['div']['p'][1]['span']['content']
            # HUMIDITY
            tmpfcast.humidity   = self.jsondata['query']['results']['div']['div']['p'][0]['span']['content']


            # APPEND THIS TO THE FORECAST LIST
            self.forecasts.append(tmpfcast)
            # DEBUG
            if opts.debug:
                print tmpfcast
        elif opts.bbcfcasttype == 'multiday':
            # GET THE LENGTH OF THE DATA INSIDE THE DICTIONARY
            # THIS SHOULD ALWAYS RETURN 12 AND WE'RE GOING TO SKIP OVER
            # 4 AND 5 (STARTING FROM 0)
            self.numfcasts = len(self.jsondata['query']['results']['div']['ul']['li'])
            # LOOP THROUGH THE JSON DATA AND GET THE FORECAST INFORMATION
            day = 1
            for i in xrange(self.numfcasts):
                tmpfcast = forecasts.FCDay()
                # GET THE DATE
                tmpfcast.date       = self.jsondata['query']['results']['div']['ul']['li'][i]['h3']['a']['span']['span'][0]['content']
                #tmpfcast.imageurl   = self.jsondata
                #fext = tmpfcast.imageurl[-4:]
                #myfname = "wunderground_fcast_day%d%s" % (day,fext)
                #getImage(tmpfcast.imageurl,myfname,IMAGESAVELOCATION)
                # CONDITION
                tmpfcast.condition  = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][0]['title']
                # TEMPERATURE - HIGH
                try:
                    # CALLING THIS JSON CALL SO IT WILL FAIL AND WE CAN SET OUR TEXT AS WE WANT
                    tmpfcast.high           = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][1]['content'].rstrip()
                    tmpfcast.high           = " - "
                except:
                    if opts.metric:
                        tmpfcast.high          = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][1]['span']['span'][0]['content'].rstrip()
                        self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['ul']['li'][i]['span'][1]['span']['span'][0]['span']['content'])
                    else:
                        tmpfcast.high          = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][1]['span']['span'][1]['content'].rstrip()
                        self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['ul']['li'][i]['span'][1]['span']['span'][1]['span']['content'])
                # TEMPERATURE - LOW
                if opts.metric:
                    tmpfcast.low          = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][2]['span']['span'][0]['content'].rstrip()
                    self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['ul']['li'][i]['span'][2]['span']['span'][0]['span']['content'])
                else:
                    tmpfcast.low          = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][2]['span']['span'][1]['content'].rstrip()
                    self.units['temperature'] = removeNonAscii(self.jsondata['query']['results']['div']['ul']['li'][i]['span'][2]['span']['span'][1]['span']['content'])
                # =============
                # WIND STUFF MAY NOT WORK IF THERE IS NO WIND, CANNOT TEST AS I HAVEN'T FOUND A LOCATION THAT HAS 0 WIND
                # WINDSPEED
                if opts.metric:
                    tmpfcast.windspeed  = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][3]['span'][0]['span']['span'][0]['content'].rstrip()
                    self.units['speed'] = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][3]['span'][0]['span']['span'][0]['span']['content']
                else:
                    tmpfcast.windspeed  = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][3]['span'][0]['span']['span'][1]['content'].rstrip()
                    self.units['speed'] = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][3]['span'][0]['span']['span'][1]['span']['content']
                # WIND DIRECTION
                tmpfcast.winddir    = self.jsondata['query']['results']['div']['ul']['li'][i]['span'][3]['span'][1]['content']

                # APPEND THIS TO THE FORECAST LIST
                self.forecasts.append(tmpfcast)
                # DEBUG
                if opts.debug:
                    print tmpfcast

    def printForecasts(self, opts):
        # DETERMINE IF WHAT WE ARE PRINTING
        if   opts.bbcfcasttype == 'current':
            if opts.currentoutputtype == 'detailed':
                print "Condition:    %s" % self.forecasts[0].condition
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                print "Temperature: %3s%s" % (self.forecasts[0].curtemp,u)
                print "Humidity:     %s" % (self.forecasts[0].humidity)
                print "Pressure:    %s %s" % (self.forecasts[0].pressure,self.units['pressure'])
                u = self.units['speed']
                if self.forecasts[0].winddir != "":
                    print "Wind: %s%s - %s" % (self.forecasts[0].windspeed,u,self.forecasts[0].winddir)
                else:
                    print "Wind: %s" % (self.forecasts[0].windspeed)
                print "Visibility:  %s %s" % (self.forecasts[0].visibility,self.units['distance'])
            elif opts.currentoutputtype == 'simple':
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                print "%s | %3s%s" % (self.forecasts[0].condition,self.forecasts[0].curtemp,u)
            if not opts.hideprovides:
                print "bbc.co.uk"
        elif opts.bbcfcasttype == 'multiday':
            # FIGURE OUT HOW USER WANTS DATA DISPLAYED
            if opts.orientation == 'vertical':
                # LOOP THROUGH THE NUMBER THE USER SPECIFIED
                # THE CHECK FOR THIS VALUE WILL HAVE BEEN DONE WHEN THE PROGRAM STARTS
                if opts.degreesymbol:
                    u1 = DEGREE+self.units['temperature']
                else:
                    u1 = self.units['temperature']
                u2 = self.units['speed']
                mystr1a = "%s: %s\nH: %3s%s L: %3s%s\nWind: %s%s\n"
                mystr1b = "%s: %s\nH: %3s%s L: %3s%s\nWind: %s%s - %s\n"
                mystr2a = "%s: %s\nH: %3s%s L: %3s%s\nWind: %s%s"
                mystr2b = "%s: %s\nH: %3s%s L: %3s%s\nWind: %s%s - %s"
                for i in xrange(opts.bbcweathernumdays):
                    if self.forecasts[i].winddir != "--":
                        mytuple = (self.forecasts[i].date,self.forecasts[i].condition,self.forecasts[i].high,u1,self.forecasts[i].low,u1,self.forecasts[i].windspeed,u2,self.forecasts[i].winddir)
                        if i != opts.bbcweathernumdays-1:
                            print mystr1b % mytuple
                        else:
                            print mystr2b % mytuple
                    else:
                        mytuple = (self.forecasts[i].date,self.forecasts[i].condition,self.forecasts[i].high,u1,self.forecasts[i].low,u1,self.forecasts[i].windspeed,u2)
                        if i != opts.bbcweathernumdays-1:
                            print mystr1a % mytuple
                        else:
                            print mystr2a % mytuple
            elif opts.orientation == 'horizontal':
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                mystr1 = "%3s: %16s"
                mystr2 = "High: %3s%s"
                mystr3 = "Low:  %3s%s"
                mystr4 = "Wind: %s%s - %s"
                highlist = []
                lowlist  = []
                datecondlist = []
                windlist = []
                for i in xrange(opts.bbcweathernumdays):
                    tmp = mystr1 % (self.forecasts[i].date.ljust(3),self.forecasts[i].condition.ljust(16))
                    datecondlist.append(tmp)
                    tmp = mystr2 % (self.forecasts[i].low,u)
                    lowlist.append(tmp)
                    tmp = mystr3 % (self.forecasts[i].high,u)
                    highlist.append(tmp)
                    tmp = mystr4 % (self.forecasts[i].windspeed,self.units['speed'],self.forecasts[i].winddir)
                    windlist.append(tmp)
                # CREATE OUR MATRIX
                matrix = [datecondlist,highlist,lowlist,windlist]
                # PRINT THE TABLE
                printTable(matrix,(4,opts.bbcweathernumdays),'left')
            if not opts.hideprovides:
                print "bbc.co.uk"
