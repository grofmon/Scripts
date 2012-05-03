-- Setup access to Utilities script
set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")

-- Static Variables
property theGrowlApp : "Fitness Apps"
property theGrowlIcon : "Garmin Training Center"
property theSetMessage : "The Fitness applications have been launched."

--Launch a few applications
set theList to {"Garmin Training Center", "Garmin ANT Agent"}
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
