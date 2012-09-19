(*
--Logging
set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
*)

tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

property WorkMbox : {"Reference"}
property WorkAcct : "Exchange"
property WorkTrash : "Deleted Items"
property HomeMbox : {"newsletters", "support org", "political", "denver trail runners"}
property HomeAcct : "Gmail"
property HomeTrash : "Trash"

tell application "Mail" to activate
set MoveDate to (current date) - (7 * days)
set DeleteDate to (current date) - (40 * days)
set PrintMoveDate to (short date string of MoveDate)
set PrintDeleteDate to (short date string of DeleteDate)
set HomeTotal to 0
set AorkTotal to 0
set HomeDeleteTotal to 0
set WorkDeleteTotal to 0
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
		set AorkTotal to count of theWorkList
		# Move old messages to the Trash
		repeat with theWorkMessage in theWorkList
			#log "move work message"
			move theWorkMessage to (mailbox WorkTrash of account WorkAcct)
		end repeat
	end repeat
	
	# Find old messages in HomeTrash	
	set the theHomeDeleteList to (every message of (mailbox HomeTrash of account HomeAcct) whose date sent is less than DeleteDate)
	# Increment the count of old messages found
	set HomeDeleteTotal to count of theHomeDeleteList
	repeat with theHomeDeleteMessage in theHomeDeleteList
		#log "delete home email"
		delete theHomeDeleteMessage
	end repeat
	
	# Find old messages in WorkTrash	
	set the theWorkDeleteList to (every message of (mailbox WorkTrash of account WorkAcct) whose date sent is less than DeleteDate)
	# Increment the count of old messages found
	set WorkDeleteTotal to count of theWorkDeleteList
	repeat with theWorkDeleteMessage in theWorkDeleteList
		#log "delete work email"
		delete theWorkDeleteMessage
	end repeat
	log "HomeTotal = " & HomeTotal
	log "WorkTotal = " & AorkTotal
	log "HomeDeleteTotal = " & HomeDeleteTotal
	log "WorkDeleteTotal = " & WorkDeleteTotal
	try
		do shell script "echo \"Move emails older than \"" & PrintMoveDate & "\" to the Trash\\n - Found \"" & HomeTotal & "\" Gmail emails\\n - Found \"" & AorkTotal & "\" Exchange emails\\n
Delete emails older than \"" & PrintDeleteDate & "\" from the Trash\\n - Deleted \"" & HomeDeleteTotal & "\" Gmail emails\\n - Deleted \"" & WorkDeleteTotal & "\" Exchange emails\" | mail -s " & scriptName & "\" run success\" montgomery.groff@echostar.com"
	on error
		log "nothing to look at here, move along"
	end try
end tell