set now to (current date)
set today to now - (time of now)
set theDate to today - (1 * days)
set theTotal to 0
tell application "Mail"
	set theArchive to mailbox "Archive" of account "Echostar"
	set theInbox to mailbox "Inbox" of account "Echostar"
	set theList to (every message of theInbox whose date received is less than theDate)
	# Increment the count of old messages found
	set theTotal to (count of theList) + theTotal
	# Move old messages to the Archive
	repeat with theMessage in theList
		move theMessage to theArchive
	end repeat
	log theDate
	
	log "theTotal = " & theTotal
	
	set theNotification to "Move emails older than " & (short date string of theDate) & " to the Archive
 - Moved " & theTotal & " emails"
	
	# Send and email
	#	do shell script "echo  \"" & theNotification & "\" | mail -s \"MailCleanup run success\" montgomery.groff@echostar.com"
	if theTotal is greater than 0 then
		# Display a notification
		display notification theNotification with title "Archive Echostar Emails"
	end if
end tell
