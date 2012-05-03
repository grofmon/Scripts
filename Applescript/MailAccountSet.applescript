-- Global Variables
global theUtils

on disableAccount()
	tell application "Mail" to set enabled of account "Echostar" to false
end disableAccount

on enableAccount()
	tell application "Mail" to set enabled of account "Echostar" to true
end enableAccount

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	if utilAppIsRunning("Mail") of theUtils is true then
		-- Get the command line argument if there is one
		if (count argv) is greater than 0 then
			set InputArg to item 1 of argv
			log theScript & ": The InputArg is \"" & InputArg & "\""
			if InputArg is "clear" then
				my disableAccount()
			end if
		else
			log theScript & ": The InputArg is empty"
			my enableAccount()
		end if
	end if
end run