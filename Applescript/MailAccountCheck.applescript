-- Setup access to Utilities script
set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")

-- Static Variables
property theGrowlApp : "Mail Account"
property theGrowlIcon : "AppleScript Editor"
property theGrowlImage : "file:///System/Library/PreferencePanes/InternetAccounts.prefPane/Contents/Resources/InternetAccounts.icns"
property theSetMessage : "The personal Mail accounts have been enabled."
property theClearMessage : "The personal Mail accounts have been disabled."
set theList to {"Monty", "Gmail"}
#set theList to {"Monty", "Gmail", "Lori", "MobileMe"}

tell application "System Events"
	-- Mail Account Closer
	tell application "Mail"
		if enabled of account "Monty" is true then
			repeat with theAccount in theList
				if exists account theAccount then
					set enabled of account theAccount to false
				end if
			end repeat
			utilNotifyGrowlImage(theGrowlApp, theGrowlIcon, theGrowlImage, theClearMessage) of theUtils
		else
			repeat with theAccount in theList
				if exists account theAccount then
					set enabled of account theAccount to true
				end if
			end repeat
			utilNotifyGrowlImage(theGrowlApp, theGrowlIcon, theGrowlImage, theSetMessage) of theUtils
		end if
	end tell
end tell