-- Global Variables
global theUtils

-- Static Variables
property theGrowlApp : "Fitness Apps"
property theGrowlIcon : "Garmin Training Center"
property theSetMessage : "The Fitness applications have been launched."
property theClearMessage : "The Fitness applications have been closed."
property theList : {"Garmin Training Center", "Garmin ANT Agent"}

--Launch a few applications
on LoadFitnessApps()
	repeat with theApp in theList
		if utilAppIsRunning(theApp) of theUtils is false then
			tell application theApp to activate
		end if
	end repeat
	
	tell application "Microsoft Excel"
		activate
		open "Users:monty:Documents:Dropbox:Personal:Fitness:Fitness Log 2012.xlsx"
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end LoadFitnessApps

-- Close a few applications
on CloseFitnessApps()
	repeat with theApp in theList
		if utilAppIsRunning(theApp) of theUtils is true then
			tell application theApp to quit
		end if
	end repeat
	tell application "Microsoft Excel"
		close workbook "Fitness Log 2012.xlsx" saving ask
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end CloseFitnessApps

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias (POSIX file "/usr/local/bin/Utils.scpt")
	
	if utilAppIsRunning("Garmin Training Center") of theUtils is true or utilAppIsRunning("Garmin ANT Agent") of theUtils is true then
		-- Close some apps
		my CloseFitnessApps()
	else
		-- Load some apps
		my LoadFitnessApps()
	end if
end run