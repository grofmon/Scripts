on appIsRunning(appName)
	tell application "System Events" to set appNameIsRunning to exists (processes where name is appName)
	if appNameIsRunning is true then
		log appName & " is already running"
	else
		log appName & "is not running"
	end if
	return appNameIsRunning
end appIsRunning