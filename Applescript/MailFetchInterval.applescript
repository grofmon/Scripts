-- Global Variables
global theUtils

on setMailFetch1Min()
	if utilAppIsRunning("Mail") of theUtils is true then
		tell application "Mail" to set fetch interval to 1
		log "Setting mail fetch interval to 1 minute."
	end if
end setMailFetch1Min

on setMailFetch15Min()
	if utilAppIsRunning("Mail") of theUtils is true then
		tell application "Mail" to set fetch interval to 15
		log "Setting mail fetch interval to 15 minutes."
	end if
end setMailFetch15Min

-- Time based version
#set timeNow to (time of (current date))
#set timeMin to (time of (date ("7:00:00" as string)))
#set timeMax to (time of (date ("18:00:00" as string)))
#if appIsRunning("Mail") then
#	tell application "Mail"
#		if timeNow is greater than timeMin and timeNow is less than timeMax then
#			set fetch interval to 1
#		else
#			set fetch interval to 15
#		end if
#	end tell
#end if

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		log theScript & ": The InputArg is \"" & InputArg & "\""
		if InputArg is "clear" then
			my setMailFetch15Min()
		end if
	else
		log theScript & ": The InputArg is empty"
		if utilEchostarNetwork() of theUtils is true then
			my setMailFetch1Min()
		else
			my setMailFetch15Min()
		end if
	end if
end run