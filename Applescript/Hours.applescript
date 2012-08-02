on run argv
	set theHours to "Charlie:Users:monty:Documents:Dropbox:Echostar:Managerial:hours_2012.numbers"
	tell application "Numbers"
		activate
		if exists document 1 then
			set myFile to name of document 1
			if myFile is "hours_2012" then
				close document 1
			end if
		else
			open theHours
		end if
	end tell
end run