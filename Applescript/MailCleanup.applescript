(*
tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell
*)

property theAcctList : {"Echostar"}
property theMboxList : {"Archive", "newsletters", "support org", "political", "denver trail runners"}

tell application "Mail" to activate
set MoveDate to (current date) - (7 * days)
set DeleteDate to (current date) - (40 * days)
set MoveTotal to 0
set DeleteTotal to 0
tell application "Mail"
	repeat with theAcct in theAcctList
		# Loop through mailboxes looking for old messages
		repeat with theMailbox in theMboxList
			if (mailbox theMailbox of account theAcct) exists then
				set theList to (every message of (mailbox theMailbox of account theAcct) whose date sent is less than MoveDate)
				# Increment the count of old messages found
				set MoveTotal to (count of theList) + MoveTotal
				# Move old messages to the Trash
				repeat with theMessage in theList
					#log "move " & theMailbox & " message"
					move theMessage to trash mailbox
				end repeat
			end if
		end repeat
	end repeat
	
	# Find old messages in the Trash mailbox	
	set the theDeleteList to (every message of trash mailbox whose date sent is less than DeleteDate)
	# Increment the count of old messages found
	set DeleteTotal to count of theDeleteList
	repeat with theDeleteMessage in theDeleteList
		#log "delete email"
		set deleted status of theDeleteMessage to true
	end repeat
	
	log "MoveTotal = " & MoveTotal
	log "DeleteTotal = " & DeleteTotal
	
	set sendMessage to "Move emails older than " & (short date string of MoveDate) & " to the Trash
 - Moved " & MoveTotal & " emails
Delete emails older than " & (short date string of DeleteDate) & "
 - Deleted " & DeleteTotal & " emails"
	
	(*	
	# Send an imessage
	tell application "Messages"
		# Test code to get service names and buddies list
		#get services
		#get name of services
		#get buddies
		#get name of buddies
		send sendMessage to buddy "monty@taolam.com" of service "E:grofmon@gmail.com"
	end tell
*)
	# Send and email
	do shell script "echo  \"" & sendMessage & "\" | mail -s \"MailCleanup run success\" montgomery.groff@echostar.com"
end tell