(*
--Logging
set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
*)

tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

property theDate : (current date) - (15 * days)
property theWorkMailboxes : {"Reference"}
property theWorkAccount : "Exchange"
property theMailboxes : {"newsletters", "support org", "political", "denver trail runners"}
property theAccount : "Gmail"
property gmailTotal : 0
property workTotal : 0

tell application "Mail" to activate
set theDate to (current date) - (15 * days)
tell application "Mail"
	repeat with theMailbox in theMailboxes
		#set gmailTotal to 0
		set theList to (every message of (mailbox theMailbox of account theAccount) whose date sent is less than theDate)
		set gmailTotal to (count of theList) + gmailTotal
		repeat with theMessage in theList
			move theMessage to (mailbox "Trash" of account theAccount)
		end repeat
		#		utilSysLog("\"" & scriptName & ": Account " & theAccount & " Moved " & gmailTotal & " messages from the " & theMailbox & " to the Trash\"") of theUtils
	end repeat
	repeat with theWorkMailbox in theWorkMailboxes
		#set workTotal to 0
		set theWorkList to (every message of (mailbox theWorkMailbox of account theWorkAccount) whose date sent is less than theDate)
		set workTotal to count of theWorkList
		repeat with theWorkMessage in theWorkList
			move theWorkMessage to (mailbox "Trash" of account theWorkAccount)
		end repeat
		#		utilSysLog("\"" & scriptName & ": Account " & theWorkAccount & " Moved " & workTotal & " messages from the " & theWorkMailbox & " to the Trash\"") of theUtils
	end repeat
	do shell script "echo  \"Date to delete by: \"" & theDate & "\" \\nMoved \"" & gmailTotal & "\" Gmail messages to the Trash\\nMoved \"" & workTotal & "\" Work messages to the Trash\" | mail -s " & scriptName & "\" run success\" montgomery.groff@echostar.com"
end tell