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
		set proxy enabled of account "monty@taolam.com" to true
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
		set proxy enabled of account "monty@taolam.com" to false
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end ClearProxy

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		if InputArg is "clear" then
			my ClearProxy()
		else if InputArg is "set" then
			my SetProxy()
		end if
	else
		tell application "Adium"
			activate
			if proxy enabled of account "monty@taolam.com" is true then
				my ClearProxy()
			else
				my SetProxy()
			end if
		end tell
	end if
end run