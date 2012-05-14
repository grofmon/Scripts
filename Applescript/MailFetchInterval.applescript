-- Global Variables
global theUtils

-- Static Variables
property theGrowlApp : "Mail Account"
property theGrowlIcon : "AppleScript Editor"
property theGrowlImage : "file:///System/Library/PreferencePanes/InternetAccounts.prefPane/Contents/Resources/InternetAccounts.icns"
property theSetMessage : "The Mail fetch interval has been set to 1 minute."
property theClearMessage : "The Mail fetch interval has been set to 15 minutes."


on setMailFetch1Min()
	if utilAppIsRunning("Mail") of theUtils is true then
		tell application "Mail" to set fetch interval to 1
	end if
	utilNotifyGrowlImage(theGrowlApp, theGrowlIcon, theGrowlImage, theSetMessage) of theUtils
end setMailFetch1Min

on setMailFetch15Min()
	if utilAppIsRunning("Mail") of theUtils is true then
		tell application "Mail" to set fetch interval to 15
	end if
	utilNotifyGrowlImage(theGrowlApp, theGrowlIcon, theGrowlImage, theClearMessage) of theUtils
end setMailFetch15Min

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		if InputArg is "clear" then
			my setMailFetch15Min()
		else if InputArg is "set" then
			my setMailFetch1Min()
		end if
	else
		-- No command line, just toggle
		tell application "Mail"
			set theInterval to fetch interval
			if fetch interval is equal to 1 then
				my setMailFetch15Min()
			else
				my setMailFetch1Min()
			end if
		end tell
	end if
end run