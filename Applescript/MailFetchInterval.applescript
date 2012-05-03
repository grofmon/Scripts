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
		my setMailFetch1Min()
	end if
end run