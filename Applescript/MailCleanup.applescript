--Logging
set commonScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

property theDate : (current date) - (15 * days)
property theWorkMailboxes : {"config_spec", "build"}
property theWorkAccount : "Echostar"
property theMailboxes : {"newsletters", "support org", "political", "denver trail runners"}
property theAccount : "Gmail"
property totalCount : 0

tell application "Mail" to activate
tell application "Mail"
	set totalCount to 0
	# cleanup home email
	repeat with theMailbox in theMailboxes
		set theCount to 0
		set theList to (every message of (mailbox theMailbox of account theAccount) whose date sent is less than theDate)
		set theCount to count of theList
		set totalCount to totalCount + theCount
		repeat with theMessage in theList
			move theMessage to (mailbox "Trash" of account theAccount)
		end repeat
		utilSysLog("\"" & scriptName & ": Account " & theAccount & " Moved " & theCount & " messages from the " & theMailbox & " to the Trash\"") of commonScript
	end repeat
	# cleanup work email
	repeat with theWorkMailbox in theWorkMailboxes
		set theCount to 0
		set theWorkList to (every message of (mailbox theWorkMailbox of account theWorkAccount) whose date sent is less than theDate)
		set theCount to count of theList
		set totalCount to totalCount + theCount
		repeat with theWorkMessage in theWorkList
			move theWorkMessage to (mailbox "Trash" of account theWorkAccount)
		end repeat
		utilSysLog("\"" & scriptName & ": Account " & theWorkAccount & " Moved " & theCount & " messages from the " & theWorkMailbox & " to the Trash\"") of commonScript
	end repeat
	utilSysLog("\"" & scriptName & ": Moved " & totalCount & " total messages to the Trash\"") of commonScript
	do shell script "echo  \"Moved \"" & totalCount & "\" messages to the Trash\" | mail -s " & scriptName & "\" run success\" montgomery.groff@echostar.com"
end tell