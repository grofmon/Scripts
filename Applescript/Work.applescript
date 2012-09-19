-- Static Variables
property theGrowlApp : "Monty's Setup"
property theGrowlIcon : "System Preferences"
property theSetMessage : "Work Initialization Complete."

on run
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	
	#	utilNotifyGrowl(theGrowlApp, theGrowlIcon, "Starting Work Initialization") of theUtils
	
	tell application "System Events" to tell security preferences
		if get require password to wake is false then
			set require password to wake to true
			utilNotifyGrowl("Screen Saver Password", "Mission Control", "The Screen Saver Password has been enabled.") of theUtils
		end if
	end tell
	
	run script ((path to library folder from user domain as string) & "Scripts:ControlApps.scpt") as alias with parameters "set"
	
	#run script ((path to library folder from user domain as string) & "Scripts:NetworkSettings.scpt") as alias with parameters "set"
	
	#run script ((path to library folder from user domain as string) & "Scripts:MountEchostar.scpt") as alias with parameters "set"
	
	#run script ((path to library folder from user domain as string) & "Scripts:AdiumProxy.scpt") as alias with parameters "set"	
	
	#run script ((path to library folder from user domain as string) & "Scripts:MailFetchInterval.scpt") as alias with parameters "set"
	
	#	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	
end run