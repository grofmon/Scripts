on run argv
	set theHours to "Charlie:Users:monty:Documents:Dropbox:Echostar:Managerial:hours_2012.xlsx"
	tell application "Microsoft Excel"
		activate
		set myFile to full name of active workbook
		if myFile is equal to theHours then
			close workbook (the name of active workbook)
		else
			open theHours
		end if
	end tell
end run