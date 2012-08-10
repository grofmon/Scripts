-- Global Variables
global theUtils

-- Static Variables
property theGrowlApp : "Control Apps"
property theGrowlIcon : "App Store"
property theSetMessage : "All Applications have been started."
property theClearMessage : "Some Applications have been closed."
property theOpenList : {"Mail", "iTunes", "Safari", "Reeder", "Calendar", "Evernote", "Messages", "Reminders"}
property theCloseList : {"Calendar", "Evernote", "Reminders"}

-- Launch a few applications, then hide them
on LoadApps()
	repeat with theApp in theOpenList
		if utilAppIsRunning(theApp) of theUtils is false then
			tell application theApp to activate
			delay 2
			-- Hide the application
			tell application "System Events"
				set visible of process theApp to false
			end tell
		end if
	end repeat
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end LoadApps

-- Close a few applications
on CloseApps()
	repeat with theApp in theCloseList
		if utilAppIsRunning(theApp) of theUtils is true then
			tell application theApp to quit
		end if
	end repeat
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end CloseApps

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		if InputArg is "clear" then
			my CloseApps()
		else if InputArg is "set" then
			my LoadApps()
		end if
	else
		my LoadApps()
	end if
end run
