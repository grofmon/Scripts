tell application "Safari" to activate
tell application "System Events"
	tell process "Safari"
		click menu item 8 of menu "User Agent" of menu item "User Agent" of menu "Develop" of menu bar item "Develop" of menu bar 1
	end tell
end tell