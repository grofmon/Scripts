-- Static Variables
property theGrowlApp : "Monty's Setup"
property theGrowlIcon : "System Preferences"
property theSetMessage : "Home Initialization Complete."

on run
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	tell application "System Events" to tell security preferences
		if get require password to wake is true then
			set require password to wake to false
		end if
	end tell
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:ControlApps.scpt")) & " clear"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:NetworkSettings.scpt")) & " clear"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MountEchostar.scpt")) & " clear"
	
	#	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:AdiumProxy.scpt")) & " clear"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailFetchInterval.scpt")) & " clear"
	
	#	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailAccountSet.scpt")) & " clear"
	
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	
end run