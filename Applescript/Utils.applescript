on utilSysLog(theMsg)
	do shell script "/usr/bin/logger " & theMsg
end utilSysLog

on utilEventLog(theMsg)
	set theLine to (do shell script "date  +'%Y-%m-%d %H:%M:%S'" as string) & " " & theMsg
	do shell script "echo " & theLine & " >> ~/Library/Logs/AppleScript-events.log"
end utilEventLog

on utilAppIsRunning(appName)
	tell application "System Events" to set appNameIsRunning to exists (processes where name is appName)
	if appNameIsRunning is true then
		log appName & " is already running"
	else
		log appName & " is not running"
	end if
	return appNameIsRunning
end utilAppIsRunning

on utilAppName(appName)
	tell application "Finder"
		set x to path to appName
		set y to name of file x as text
		return y
	end tell
end utilAppName

on utilCheckDns()
	-- Check to see if the search domains are empty. 
	set theResult to do shell script "/usr/sbin/networksetup -getdnsservers \"Wi-Fi\""
	if theResult contains "There aren't any DNS Servers set on Wi-Fi." then
		return false
	else
		return true
	end if
end utilCheckDns

on utilNotifyGrowl(appName, appIcon, appString)
	if utilAppIsRunning("Growl") then
		tell application "Growl"
			set the allNotificationsList to {appName}
			set the enabledNotificationsList to {appName}
			register as application appName all notifications allNotificationsList default notifications enabledNotificationsList icon of application appIcon
			notify with name appName title appName description appString application name appName
		end tell
	end if
end utilNotifyGrowl

on utilNotifyGrowlImage(appName, appIcon, appIMage, appString)
	if utilAppIsRunning("Growl") then
		tell application "Growl"
			set the allNotificationsList to {appName}
			set the enabledNotificationsList to {appName}
			register as application appName all notifications allNotificationsList default notifications enabledNotificationsList icon of application appIcon
			notify with name appName title appName description appString application name appName image from location appIMage
		end tell
	end if
end utilNotifyGrowlImage

