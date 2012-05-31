-- Static Variables
property theGrowlApp : "Monty's Setup"
property theGrowlIcon : "System Preferences"
property theSetMessage : "Work Initialization Complete."

on run
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	
	tell application "System Events" to tell security preferences
		if get require password to wake is false then
			set require password to wake to true
			utilNotifyGrowl("Screen Saver Password", "Mission Control", "The Screen Saver Password has been enabled.") of theUtils
		end if
	end tell
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:ControlApps.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:NetworkSettings.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MountEchostar.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:AdiumProxy.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailFetchInterval.scpt")) & " set"
	
	#	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailAccountSet.scpt")) & " set"
	
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	
end run