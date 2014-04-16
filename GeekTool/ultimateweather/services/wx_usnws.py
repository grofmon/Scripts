""" USNationalWeatherService
 ROBERT WOLTERMAN (xtacocorex) - 2012

 GRABS THE WEATHER FROM THE US NATIONAL WEATHER SERVICE SITE
 
 THIS CLASS INHERITS FROM forecasts.Forecasts 
"""

# MODULE IMPORTS
from globals          import *
from utilityfunctions import *
import forecasts

# CHANGELOG
# 05 AUGUST 2012
#  - ADDED SUPPORT FOR GETTING, PARSING, & PRINTING WEATHER WARNING FOR CURRENT WEATHER ONLY
# 04 AUGUST 2012
#  - ADDED SUPPORT FOR PRINTING THE DEGREE SYMBOL, REQUIRES GEEKLET TO BE SET TO UNICODE
# 28 JULY 2012
#  - UPDATED TO SUPPORT NEW PAGE LAYOUT
#  - ADDED SUPPORT FOR CURRENT WEATHER IMAGE
# 21 APRIL 2012
#  - EXTRACTION FROM THE MAIN SCRIPT AND PUT INTO THE SERVICES MODULE

class USNationalWeatherService(forecasts.Forecasts):
    def __init__(self):
        self.baseimgurl = "http://forecast.weather.gov"
        self.havewindchill = False
        # INITIALIZE THE INHERITED CLASS
        forecasts.Forecasts.__init__(self)

    def setURL(self,opts):
        # FIGURE OUT OUR URL FOR WORK
        # DETERMINE IF WE ARE USING A HARDCODED URL
        if opts.url != '':
            # YOU ARE ON YOUR OWN FOR PROVIDING UNITS WITH THE HARD CODED URL
            yqlquery = 'select * from html where url="%s"' % opts.url
        else:
            if self.location.country != "united states":
                print "*** US NATIONAL WEATHER SERVICE IS ONLY FOR RESIDENTS OF THE UNITED STATES ***"
                sys.exit(-1)
            else:
                mytuple = (self.location.city.title().replace(" ","+"),USSTATEMAP[self.location.stprov.title()],self.location.lat,self.location.lon)
            yqlquery = 'select * from html where url="http://forecast.weather.gov/MapClick.php?CityName=%s&state=%s&textField1=%s&textField2=%s"' % mytuple
        # FIGURE OUT WHAT WE WANT TO GET FROM THE YQL
        if   opts.usnwsfcasttype == 'current':
            # THE TOOL IN OPERA THAT ALLOWS YOU TO EXPLORE HTML SOURCE IS AWESOME
            ender = ' and xpath=\'//div[@class="full-width-borderbottom current-conditions"]  \''
        elif opts.usnwsfcasttype == 'multidaysimple':
            ender = ' and xpath=\'//div[@class="partial-width-borderbottom point-forecast-icons"]  \''
        elif opts.usnwsfcasttype == 'multidaydetailed':
            ender = ' and xpath=\'//ul[@class="point-forecast-7-day"] \''
        self.url = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
        if opts.debug:
            print "\n*** us nws url creation"
            print yqlquery
            print self.url
            print DEBUGSPACER
        
        # DETERMINE IF WE WANT WEATHER WARNING INFORMATION
        if opts.wxwarnings:
            # USE THE SAME YQL QUERY FROM ABOVE, BUT CHANGE THE ENDER
            ender = 'and xpath=\'//div[@class="hazardous-conditions"] \''
            self.hazurl = YQLBASEURL + "?q=" + myencode(yqlquery+ender) + "&format=" + YQLFORMAT1
            if opts.debug:
                print "\n*** us nws url creation - hazards/warnings"
                print yqlquery
                print self.hazurl
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
        # DETERMINE WHAT WE ARE PARSING
        if   opts.usnwsfcasttype == 'current':
            # THE INTERESTING THING ABOUT THE CURRENT FORECAST ON THE NWS SITE
            # IS THAT IT PROVIDES METRIC NEXT TO THE FAHRENHEIT DATA
            tmpfcast = forecasts.FCDay()
            # LETS GET THE WEATHER IMAGE
            imgloc              = self.jsondata['query']['results']['div']['div'][0]['div'][0]['p']['img']['src']
            tmpfcast.imageurl   = self.baseimgurl + imgloc
            fext = tmpfcast.imageurl[-4:]
            myfname = "usnws_current_wx%s" % (fext)
            getImage(tmpfcast.imageurl,myfname,IMAGESAVELOCATION)
            # LETS GET THE CURRENT CONDITION
            tmpfcast.condition  = self.jsondata['query']['results']['div']['div'][0]['div'][1]['p'][0]['content'].rstrip()
            # LETS GET THE TEMPERATURE
            if opts.metric:
                tempdata = replaceNonAscii(self.jsondata['query']['results']['div']['div'][0]['div'][1]['p'][2]['span']['content']," ")
            else:
                tempdata = replaceNonAscii(self.jsondata['query']['results']['div']['div'][0]['div'][1]['p'][1]['content']," ")
            tmp                       = tempdata.split(" ")
            tmpfcast.curtemp          = tmp[0]
            self.units['temperature'] = tmp[1]

            # HUMIDITY
            tmpfcast.humidity = self.jsondata['query']['results']['div']['div'][1]['ul']['li'][0]['p']
            # WIND AND GUST
            winddata = self.jsondata['query']['results']['div']['div'][1]['ul']['li'][1]['p']
            if winddata != "Calm":
                winddata = winddata.split(" ")
                tmpfcast.winddir    = winddata[0]
                tmpfcast.windspeed  = winddata[1]
                self.units['speed'] = winddata[2]
                if len(winddata) > 3:
                    tmpfcast.windgust   = winddata[3]
                    self.units['speed'] = winddata[4]
                else:
                    tmpfcast.windgust   = "0"
            else:
                tmpfcast.windspeed  = winddata
                tmpfcast.winddir    = ""
                tmpfcast.windgust   = ""
                self.units['speed'] = ""
            
            # PRESSURE
            presdata = self.jsondata['query']['results']['div']['div'][1]['ul']['li'][2]['p']
            if opts.metric:
                tmp = presdata.split(" (")[1].split(")")[0].split(" ")
                tmpfcast.pressure      = tmp[0]
                self.units['pressure'] = tmp[1]
            else:
                tmp = presdata.split(" (")[0].split(" ")
                tmpfcast.pressure      = tmp[0]
                self.units['pressure'] = tmp[1]

            # DEW POINT
            dewdata = replaceNonAscii(self.jsondata['query']['results']['div']['div'][1]['ul']['li'][3]['p']," ")
            if opts.metric:
                tmp = dewdata.split(" (")[1].split(")")[0].split(" ")
                tmpfcast.dewpoint      = tmp[0]
            else:
                tmp = dewdata.split(" (")[0].split(" ")
                tmpfcast.dewpoint      = tmp[0]

            # WIND CHILL/HEAT INDEX MAY BE AROUND ALL THE TIME NOW...
            if self.jsondata['query']['results']['div']['div'][1]['ul']['li'][4]['span']['content'] in ["Heat Index","Wind Chill"]:
                feeldata = replaceNonAscii(self.jsondata['query']['results']['div']['div'][1]['ul']['li'][5]['p']," ")
                self.havewindchill = True   # KEEPING THIS JUST IN CASE I HAVE TO REVERT
                if opts.metric:
                    tmp               = feeldata.split(" (")[1].split(")")[0].split(" ")
                    tmpfcast.tempfeel = tmp[0]
                else:
                    tmp               = feeldata.split(" (")[0].split(" ")
                    tmpfcast.tempfeel = tmp[0]
            else:
                # VISIBILITY
                visidata = self.jsondata['query']['results']['div']['div'][1]['ul']['li'][4]['p'].split(" ")
                tmpfcast.visibility    = visidata[0]
                self.units['distance'] = visidata[1]
                # BLANK OUT TEMP FEEEL
                tmpfcast.tempfeel      = "--"

            # DO WE NEED TO PARSE OUT WEATHER WARNING INFORMATION
            if opts.wxwarnings:
                # CHECK TO SEE WHAT THE RESULTS ARE, THERE ARE 3 POSSIBLE TYPES
                # 1 - NULL -> NO DATA AT ALL
                # 2 - HAZARD WEATHER OUTLOOK -> NO DATA
                # 3 - DATA + HAZARD WEATHER OUTLOOK -> DATA!
                if self.jsondatahazard['query']['results'] != 'null':
                    # WE WANT TO GO ON, GOAL IS TO KEEP THE WARNING LIST EMPTY IF THERE IS NO DATA
                    lidata = self.jsondatahazard['query']['results']['div']['ul']['li']
                    # DETERMINE IF WE HAVE A LIST
                    if type(lidata) is list:
                        for li in lidata:
                            tmp = li['a']['content']
                            if tmp != "Hazardous Weather Outlook":
                                tmpfcast.warnings.append(tmp)
                    else:
                        tmp = lidata['a']['content']
                        if tmp != "Hazardous Weather Outlook":
                            tmpfcast.warnings.append(tmp)


            # APPEND THIS TO THE FORECAST LIST
            self.forecasts.append(tmpfcast)
            # DEBUG
            if opts.debug:
                print tmpfcast
        elif opts.usnwsfcasttype == 'multidaysimple':
            # GET THE NUMBER OF ITEMS IN THE 'td' LIST, THERE SHOULD BE NINE
            self.numfcasts = len(self.jsondata['query']['results']['div']['div'])
            # SET OUR VARIABLE TO SEE IF WE ARE IN A NIGHT ITEM
            innight = False
            # LOOP THROUGH THE NUMBER OF FORECASTS AND GET THE DATA
            for i in xrange(self.numfcasts):
                tmpfcast = forecasts.FCDay()
                # WE CAN ONLY GET DATE, CONDITION, HIGH OR LOW, % PRECIPITATION, AND IMAGE URL
                tmpfcast.date       = self.jsondata['query']['results']['div']['div'][i]['p'][0]['content'].rstrip()
                # FIGURE OUT IF WE ARE DOING A NIGHT TIME FORECAST OR NOT
                if "Night" in tmpfcast.date or "Afternoon" in tmpfcast.date:
                    tmpfcast.date   = tmpfcast.date.replace("\n"," ")
                # WEATHER IMAGE
                imgloc              = self.jsondata['query']['results']['div']['div'][i]['p'][1]['img']['src']
                tmpfcast.imageurl   = self.baseimgurl + imgloc
                fext = tmpfcast.imageurl[-4:]
                myfname = "usnws_fcast_day%d%s" % (i+1,fext)
                getImage(tmpfcast.imageurl,myfname,IMAGESAVELOCATION)
                # TEMPERATURE
                tempdata = replaceNonAscii(self.jsondata['query']['results']['div']['div'][i]['p'][3]['content']," ")
                tempdata = tempdata.split(": ")
                # BASE TEMPERATURES ON IF WE ARE LOOKING FOR A HIGH OR A LOW IN THE TABLE DATA
                tmp                  = tempdata[1].split(" ")
                if tempdata[0] == "Low":
                    tmpfcast.low     = tmp[0]
                    tmpfcast.high    = "--"
                else:
                    tmpfcast.high    = tmp[0]
                    tmpfcast.low     = "--"
                self.units['temperature'] = tmp[1]
                # CONDITION
                tmp                  = self.jsondata['query']['results']['div']['div'][i]['p'][2]['content'].rstrip()
                tmpfcast.condition   = tmp.replace("\n"," ")
                # CHANCE OF PRECIPITATION
                imgalttest = self.jsondata['query']['results']['div']['div'][i]['p'][1]['img']['alt']
                if "ChanceShowersChanceforMeasurablePrecipitation" in imgalttest:
                    tmpfcast.pcntprecip = imgaltest.replace("ChanceShowersChanceforMeasurablePrecipitation","")
                else:
                    tmpfcast.pcntprecip = "0%"
                # APPEND THIS TO THE FORECAST LIST
                self.forecasts.append(tmpfcast)
                # DEBUG
                if opts.debug:
                    print tmpfcast
        elif opts.usnwsfcasttype == 'multidaydetailed':
            # GET THE NUMBER OF FORECAST ELEMENTS
            self.numfcasts = len(self.jsondata['query']['results']['ul']['li'])
            # LOOP THROUGH THE LISTS AND CREATE OUR FORECAST DAY OBJECTS
            for i in xrange(self.numfcasts):
                tmpfcast = forecasts.FCDay()
                # SET THE DATE
                tmpfcast.condition = self.jsondata['query']['results']['ul']['li'][i]['p']
                tmpfcast.date     = self.jsondata['query']['results']['ul']['li'][i]['span']['content']
                # APPEND THIS TO THE FORECAST LIST
                self.forecasts.append(tmpfcast)
                # DEBUG
                if opts.debug:
                    print tmpfcast

    def printForecasts(self, opts):
        # DETERMINE IF WHAT WE ARE PRINTING
        if   opts.usnwsfcasttype == 'current':
            if opts.currentoutputtype == 'detailed':
                print "Condition:   %s" % self.forecasts[0].condition
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                if self.havewindchill:
                    mtuple = (self.forecasts[0].curtemp,u,self.forecasts[0].tempfeel,u,self.forecasts[0].dewpoint,u)
                    print "Temperature: %3s%s\nFeels Like:  %3s%s\nDew Point:   %3s%s" % mtuple
                else:
                    mtuple = (self.forecasts[0].curtemp,u,self.forecasts[0].dewpoint,u)
                    print "Temperature: %3s%s\nDew Point:   %3s%s" % mtuple
                print "Humidity:    %3s" % (self.forecasts[0].humidity)
                print "Pressure:    %s %s" % (self.forecasts[0].pressure,self.units['pressure'])
                u = self.units['speed']
                if self.forecasts[0].winddir != "":
                    print "Wind: %s%s - %s\nGust: %s%s" % (self.forecasts[0].windspeed,u,self.forecasts[0].winddir,self.forecasts[0].windgust,u)
                else:
                    print "Wind: %s\nGust: %s%s" % (self.forecasts[0].windspeed,self.forecasts[0].windgust,u)
                print "Visibility:  %s %s" % (self.forecasts[0].visibility,self.units['distance'])
            elif opts.currentoutputtype == 'simple':
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                print "%s | %3s%s" % (self.forecasts[0].condition,self.forecasts[0].curtemp,u)
            # PRINT OUT THE WEATHER WARNINGS
            if opts.wxwarnings and self.forecasts[0].warnings != []:
                print "Warnings:"
                for warning in self.forecasts[0].warnings:
                    print warning
            if not opts.hideprovides:
                print "forecast.weather.gov"
        elif opts.usnwsfcasttype == 'multidaysimple':
            # FIGURE OUT THE ORIENTATION OF PRINTING DATA
            if   opts.orientation == 'vertical':
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                mystr = "%s\n%s\n%s: %3s%s\nPrecipitation: %s\n"
                for fcast in self.forecasts:
                    if fcast.high == '--':
                        mytuple = (fcast.date,fcast.condition,"L",fcast.low,u,fcast.pcntprecip)
                    elif fcast.low == '--':
                        mytuple = (fcast.date,fcast.condition,"H",fcast.high,u,fcast.pcntprecip)
                    print mystr % mytuple
            elif opts.orientation == 'horizontal':
                if opts.degreesymbol:
                    u = DEGREE+self.units['temperature']
                else:
                    u = self.units['temperature']
                mystr1 = "%16s"
                mystr2 = "High: %3s%s"
                mystr3 = "Low:  %3s%s"
                mystr4 = "Chc Precip: %s"
                datelist = []
                templist = []
                condlist = []
                preclist = []
                for fcast in self.forecasts:
                    tmp = mystr1 % fcast.date.ljust(16)
                    datelist.append(tmp)
                    condlist.append(fcast.condition)
                    if fcast.high == '--':
                        tmp = mystr2 % (fcast.low,u)
                    elif fcast.low == '--':
                        tmp = mystr3 % (fcast.high,u)
                    templist.append(tmp)
                    tmp = mystr4 % fcast.pcntprecip
                    preclist.append(tmp)
                # CREATE OUR MATRIX
                matrix = [datelist,condlist,templist,preclist]
                # PRINT THE TABLE
                printTable(matrix,(4,9),'left')
                if not opts.hideprovides:
                    print "forecast.weather.gov"
        elif opts.usnwsfcasttype == 'multidaydetailed':
            # LOOP THROUGH THE FORECASTS AND PRINT THE DATA
            mystr = "%s\n%s\n"
            for fcast in self.forecasts:
                print mystr % (fcast.date,fcast.condition)
            if not opts.hideprovides:
                print "forecast.weather.gov"

