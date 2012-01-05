(*
--Logging
set commonScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utilities:SysLog.scpt")
tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell
*)

(*
-- Count the email marked as read
set theCount to 0
*)

set theDate to (current date) - (1 * days)

tell application "System Events"
	if exists process "Mail" then
		tell application "Mail"
			set theList1 to every message of (mailbox "Trash" of account "Echostar") whose date sent is less than theDate and read status is false
			repeat with theMessage in theList1
				set read status of theMessage to true
				#set theCount to theCount + 1
			end repeat
			(*			
			-- Now un-mark certain newer emails for reference
			set theList2 to every message of (mailbox "Trash" of account "Echostar") whose date sent is greater than theDate and (sender contains "broadcom.com" or sender contains "612_hardware_support" or sender contains "larry.wisniewski" or sender contains "patrick.elliot" or sender contains "linda.mork" or sender contains "jonathan.kuo" or sender contains "coverity_build" or sender contains "Email_Admin" or sender contains "ccadmin" or sender contains "agileadministrator")
			repeat with theMessage in theList2
				set read status of theMessage to false
			end repeat
			
			set theList3 to every message of (mailbox "Trash" of account "Echostar") whose date sent is greater than theDate and (sender does not contain "broadcom.com" and sender does not contain "612_hardware_support" and sender does not contain "larry.wisniewski" and sender does not contain "patrick.elliot" and sender does not contain "linda.mork" and sender does not contain "jonathan.kuo" and sender does not contain "coverity_build" and sender does not contain "Email_Admin" and sender does not contain "ccadmin" and sender does not contain "agileadministrator" and sender does not contain "gandalf") and read status is false
			repeat with theMessage in theList3
				set read status of theMessage to true
				#set theCount to theCount + 1
			end repeat
*)
			#sysLog("\"" & scriptName & ": Marked " & theCount & " emails as read in all Trash\"") of commonScript
			
		end tell
	end if
end tell

