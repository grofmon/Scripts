-- Static Variables
property theGrowlApp : "Monty's Setup"
property theGrowlIcon : "System Preferences"
property theSetMessage : "Work Initialization Complete."

on run
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:ControlApps.scpt")) & " set"
	
		do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:NetworkSettings.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MountEchostar.scpt"))
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:AdiumProxy.scpt")) & " set"
	
	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailFetchInterval.scpt")) & " set"
	
	#	do shell script "/usr/bin/osascript " & (POSIX path of file ((path to library folder from user domain as string) & "Scripts:MailAccountSet.scpt")) & " set"
	
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
	
end run