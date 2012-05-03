-- Global Variables
global theUtils
global theCount

-- Static Variables
property theGrowlApp : "Control Apps"
property theGrowlIcon : "App Store"
property theSetMessage : "All Applications have been started."
property theClearMessage : "Some Applications have been closed."
property theHomeList : {"Mail", "Adium", "iTunes", "Safari", "Reeder"}
property theWorkList : {"iCal", "Evernote"}

-- Launch a few applications, then hide them
on LoadApps()
	repeat with theApp in theHomeList
		if utilAppIsRunning(theApp) of theUtils is false then
			tell application theApp to activate
			delay 2
			-- Hide the application
			tell application "System Events"
				set visible of process theApp to false
			end tell
			set theCount to (theCount + 1)
		end if
	end repeat
	if utilEchostarNetwork() of theUtils is true then
		my LoadEchostarApps()
	end if
	if theCount is greater than 0 then
		utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	end if
end LoadApps

-- Launch a few more apps for work, then hide them
on LoadEchostarApps()
	repeat with theApp in theWorkList
		if utilAppIsRunning(theApp) of theUtils is false then
			tell application theApp to activate
			delay 2
			-- Hide the application
			tell application "System Events"
				set visible of process theApp to false
			end tell
			set theCount to (theCount + 1)
		end if
	end repeat
end LoadEchostarApps

-- Close a few applications
on CloseApps()
	repeat with theApp in theWorkList
		if utilAppIsRunning(theApp) of theUtils is true then
			tell application theApp to quit
			set theCount to (theCount + 1)
		end if
	end repeat
	if theCount is greater than 0 then
		utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
	end if
end CloseApps

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
			my CloseApps()
		end if
	else
		log theScript & ": The InputArg is empty"
		-- Load some apps
		my LoadApps()
	end if
end run
