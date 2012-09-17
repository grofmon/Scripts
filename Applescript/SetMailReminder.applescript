tell application "Mail"
	set _sel to selection
	set _links to {}
	
	set the _message to item 1 of the _sel
	set theSubject to subject of _message
	set message_id to the message id of the _message
end tell

set message_url to "message://%3c" & message_id & "%3e"
set end of _links to message_url
set the clipboard to (_links as string)

set theBody to the clipboard

tell application "Reminders"
	set theReminder to make new reminder with properties {name:theSubject, body:theBody, priority:1}
	
end tell