tell application "Mail"
	set theList to every message of (mailbox "Deleted Items" of account "Exchange") whose read status is false
	repeat with theMessage in theList
		set read status of theMessage to true
	end repeat
end tell

