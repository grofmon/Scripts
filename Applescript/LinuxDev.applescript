
on newShell()
	tell application "Terminal"
		do script "ssh -Y monty@10.79.97.251"
		activate
	end tell
end newShell

on newTerminal()
	tell application "Terminal" to activate
	tell application "System Events"
		keystroke "ssh -Y monty@10.79.97.251"
		keystroke return
	end tell
end newTerminal

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	
	if utilAppIsRunning("Terminal") of theUtils is true then
		my newShell()
	else
		my newTerminal()
	end if
end run