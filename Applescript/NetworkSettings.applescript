-- Global Variables
global theUtils

-- Static Variables
property theGrowlApp : "Network Settings"
property theGrowlIcon : "Network Utility"
property theSetMessage : "Echostar network dns servers are set."
property theClearMessage : "The network dns servers are clear."

on SetNetworkSettings()
	-- Enable the Screen Saver password when connected to the E* network (but don't automatically disable it).
	tell application "System Events" to tell security preferences
		if get require password to wake is false then
			set require password to wake to true
		end if
	end tell
	
	-- Check to see if the search domains are empty.
	if utilCheckDns() of theUtils is false then
		#-- Set the Search Domains
		do shell script "/usr/sbin/networksetup -setsearchdomains \"Wi-Fi\" echostar.com sats.corp"
		do shell script "/usr/sbin/networksetup -setsearchdomains \"Ethernet\" echostar.com sats.corp"
		-- Set the DNS Servers
		do shell script "/usr/sbin/networksetup -setdnsservers  \"Wi-Fi\" 10.73.201.48 10.73.201.49 10.76.240.75 10.76.240.77 10.3.200.130"
		do shell script "/usr/sbin/networksetup -setdnsservers  \"Ethernet\" 10.73.201.48 10.73.201.49 10.76.240.75 10.76.240.77 10.3.200.130"
		-- Log the activity
		utilSysLog(theSetMessage) of theUtils
	end if
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end SetNetworkSettings

on ClearNetworkSettings()
	-- Check to see if the search domains are empty. 
	if utilCheckDns() of theUtils is true then
		#-- Clear the Search Domains
		do shell script "/usr/sbin/networksetup -setsearchdomains  \"Wi-Fi\" empty"
		do shell script "/usr/sbin/networksetup -setsearchdomains  \"Ethernet\" empty"
		-- Clear the Name Servers
		do shell script "/usr/sbin/networksetup -setdnsservers  \"Wi-Fi\" \"empty\""
		do shell script "/usr/sbin/networksetup -setdnsservers  \"Ethernet\" \"empty\""
		-- Log the activity
		utilSysLog(theClearMessage) of theUtils
	end if
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end ClearNetworkSettings

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		
		if InputArg is "clear" then
			my ClearNetworkSettings()
		else if InputArg is "set" then
			my SetNetworkSettings()
		end if
	else
		if utilCheckDns() of theUtils is true then
			my ClearNetworkSettings()
		else
			my SetNetworkSettings()
		end if
	end if
end run

