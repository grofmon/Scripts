tell application "System Events" to tell the front menu bar of process "SystemUIServer"
	set menu_extras to value of attribute "AXDescription" of menu bar items
	repeat with i from 1 to the length of menu_extras
		if item i of menu_extras is "airport menu extra" then
			set airport_extra to i
			exit repeat
		end if
	end repeat
	tell menu bar item airport_extra
		click
		tell 2nd menu item of front menu
			click
		end tell
	end tell
end tell