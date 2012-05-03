-- Global Variables
global theUtils
global theCount

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
		set theCount to (theCount + 1)
	end repeat
	
	tell application "Microsoft Excel"
		activate
		open "Users:monty:Documents:Dropbox:Personal:Fitness:Fitness Log 2012.xlsx"
	end tell
	
	if theCount is greater than 0 then
		utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	end if
end LoadFitnessApps

-- Close a few applications
on CloseFitnessApps()
	repeat with theApp in theList
		if utilAppIsRunning(theApp) of theUtils is true then
			tell application theApp to quit
			set theCount to (theCount + 1)
		end if
	end repeat
	if theCount is greater than 0 then
		utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
	end if
end CloseFitnessApps

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	-- Initialize theCount
	set theCount to 0
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		log theScript & ": The InputArg is \"" & InputArg & "\""
		if InputArg is "clear" then
			-- Close some apps
			my CloseFitnessApps()
		end if
	else
		log theScript & ": The InputArg is empty"
		-- Load some apps
		my LoadFitnessApps()
	end if
end run