-- Global variable
global theUtils

-- Static Variables
property theGrowlApp : "Adium Proxy"
property theGrowlIcon : "SSH Tunnel Manager"
property theSetMessage : "The Adium Socks Proxy is enabled."
property theClearMessage : "The Adium Socks Proxy is disabled."
property theAdium : "Adium"
property theTunnel : "SSH Tunnel Manager"

-- Enable the proxy and start SSH Tunnel Manager
on SetProxy()
	-- Start the SSH Tunnel if it is not running
	if utilAppIsRunning(theTunnel) of theUtils is false then
		tell application theTunnel to activate
	end if
	-- Enable the SOCKS proxy
	tell application "Adium"
		activate
		if proxy enabled of account "monty@taolam.com" is not true then
			set proxy enabled of account "monty@taolam.com" to true
		end if
		tell the account "montgomery.groff@echostar.com" to go online
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end SetProxy

-- Clear the proxy and quit SSH Tunnel Manager
on ClearProxy()
	-- Quit the SSH Tunnel if it is running
	if utilAppIsRunning(theTunnel) of theUtils is true then
		tell application theTunnel to quit
	end if
	tell application "Adium"
		activate
		if proxy enabled of account "monty@taolam.com" is not false then
			set proxy enabled of account "monty@taolam.com" to false
		end if
		#		tell the account "montgomery.groff@echostar.com" to go offline
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end ClearProxy

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
			my ClearProxy()
		end if
	else
		log theScript & ": The InputArg is empty"
		my SetProxy()
	end if
end run