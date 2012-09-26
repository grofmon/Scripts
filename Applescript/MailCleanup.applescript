tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

property WorkMbox : {"Archive"}
property WorkAcct : "Exchange"
property HomeMbox : {"newsletters", "support org", "political", "denver trail runners"}
property HomeAcct : "Gmail"

tell application "Mail" to activate
set MoveDate to (current date) - (7 * days)
set DeleteDate to (current date) - (40 * days)
set PrintMoveDate to (short date string of MoveDate)
set PrintDeleteDate to (short date string of DeleteDate)
set HomeTotal to 0
set WorkTotal to 0
set DeleteTotal to 0
tell application "Mail"
	# Loop through mailboxes looking for old messages
	repeat with theMailbox in HomeMbox
		set theList to (every message of (mailbox theMailbox of account HomeAcct) whose date sent is less than MoveDate)
		# Increment the count of old messages found
		set HomeTotal to (count of theList) + HomeTotal
		# Move old messages to the Trash
		repeat with theMessage in theList
			#log "move home message"
			move theMessage to (mailbox HomeTrash of account HomeAcct)
		end repeat
	end repeat
	# Loop through mailboxes looking for old messages
	repeat with theWorkMailbox in WorkMbox
		set theWorkList to (every message of (mailbox theWorkMailbox of account WorkAcct) whose date sent is less than MoveDate)
		# Increment the count of old messages found
		set WorkTotal to (count of theWorkList) + WorkTotal
		# Move old messages to the Trash
		repeat with theWorkMessage in theWorkList
			#log "move work message"
			move theWorkMessage to (mailbox WorkTrash of account WorkAcct)
		end repeat
	end repeat
	
	# Find old messages in the Trash mailbox	
	set the theDeleteList to (every message of trash mailbox whose date sent is less than DeleteDate)
	# Increment the count of old messages found
	set DeleteTotal to count of theDeleteList
	repeat with theDeleteMessage in theDeleteList
		#log "delete home email"
		delete theDeleteMessage
	end repeat
	log "HomeTotal = " & HomeTotal
	log "WorkTotal = " & WorkTotal
	log "DeleteTotal = " & DeleteTotal
	#	try
	do shell script "echo \"Move emails older than \"" & PrintMoveDate & "\" to the Trash\\n - Found \"" & HomeTotal & "\" Gmail emails\\n - Found \"" & WorkTotal & "\" Exchange emails\\n
Delete emails older than \"" & PrintDeleteDate & "\" from the Trash\\n - Deleted \"" & DeleteTotal & "\" emails\" | mail -s " & scriptName & "\" run success\" montgomery.groff@echostar.com"
	#	on error
	#		log "nothing to look at here, move along"
	#	end try
end tell