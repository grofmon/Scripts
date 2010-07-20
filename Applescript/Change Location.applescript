-- Logging
set commonScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utilities:SysLog.scpt")
tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

-- Global property
global set_loc

-- Gets current Location
set current_location to do shell script "scselect 2>&1 | grep '^ ' 2>&1 | grep '*' | cut -f 2 -d '(' | cut -f 1 -d ')'"

-- checks if it is set to first location and changes to the other one if it is
if current_location is equal to "Automatic" then
	do shell script "scselect Work"
	set set_loc to "Work"
else if current_location is equal to "Work" then
	do shell script "scselect Automatic"
	set set_loc to "Automatic"
else
	tell application "Growl"
		set the allNotificationsList to {"Network Location"}
		set the enabledNotificationsList to {"Network Location"}
		register as application "Network Location" all notifications allNotificationsList default notifications enabledNotificationsList icon of application "System Preferences"
		notify with name "Network Location" title "Network Location" description "You aren't on either main location. Nothing has been changed." application name "Network Location"
	end tell
end if

-- Display status notification using Growl
tell application "Growl"
	set the allNotificationsList to {"Network Location"}
	set the enabledNotificationsList to {"Network Location"}
	register as application "Network Location" all notifications allNotificationsList default notifications enabledNotificationsList icon of application "System Preferences"
	notify with name "Network Location" title "Network Location" description "The Network Location has been changed to " & set_loc application name "Network Location"
	sysLog("\"" & scriptName & ": Network Location changed to " & set_loc & "\"") of commonScript
end tell

-- Mount/Unmount network directories
if set_loc is "Work" then
	--display dialog set_loc
	delay 20
	run script "/Users/monty/Library/Scripts/Monty's Scripts/Network Mount EchoStar.scpt"
else
	run script "/Users/monty/Library/Scripts/Monty's Scripts/Network UnMount EchoStar.scpt"
	
end if