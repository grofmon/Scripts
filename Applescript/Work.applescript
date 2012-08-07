-- Static Variables
property theGrowlApp : "Monty's Setup"
property theGrowlIcon : "System Preferences"
property theSetMessage : "Work Initialization Complete."

on run
	-- Setup access to Utilities script
	set theUtils to load script alias (POSIX file "/usr/local/bin/Utils.scpt")
	
	tell application "System Events" to tell security preferences
		if get require password to wake is false then
			set require password to wake to true
			utilNotifyGrowl("Screen Saver Password", "Mission Control", "The Screen Saver Password has been enabled.") of theUtils
		end if
	end tell
	
	run script ((POSIX file "/usr/local/bin/ControlApps.scpt")) with parameters "set"
	
	#run script ((POSIX file "/usr/local/bin/NetworkSettings.scpt.scpt")) with parameters "set"
	
	#run script ((POSIX file "/usr/local/bin/MountEchostar.scpt")) with parameters "set"
	
	#run script ((POSIX file "/usr/local/bin/AdiumProxy.scpt.scpt")) with parameters "set"	
	
	#run script ((POSIX file "/usr/local/bin/MailFetchInterval.scpt")) with parameters "set"
	
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	
end run