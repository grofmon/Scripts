-- Setup access to Utilities script
set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")

-- Static Variables
property theGrowlApp : "Screen Saver Password"
property theGrowlIcon : "Mission Control"
property theSetMessage : "The Screen Saver Password has been enabled."
property theClearMessage : "The Screen Saver Password has been disabled."

tell application "System Events"
	tell security preferences
		if get require password to wake is true then
			set require password to wake to false
			utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
		else
			set require password to wake to true
			utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
		end if
	end tell
end tell
