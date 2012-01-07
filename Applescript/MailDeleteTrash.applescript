--Logging
set commonScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utilities:SysLog.scpt")
tell application "Finder"
	set scriptPath to path to me
	set scriptName to name of file scriptPath as text
end tell

-- Count the email deleted
set theCount to 0
set theDeleted to 0
set toDelete to false
tell application "System Events"
	if exists process "Mail" then
		tell application "Mail"
			set theList to every message of (mailbox "Deleted Items" of account "Echostar") whose all headers contains "inv-lx"
			repeat with theMessage in theList
				if sender of theMessage contains "CART@echostar.com" then
					if subject of theMessage does not contain "DELTA" then
						set toDelete to true
					end if
				end if
				if subject of theMessage contains "[REVIEW]" then
					set toDelete to true
				end if
				if sender of theMessage contains "ccadmin@inv" then
					if subject of theMessage contains "CRs in code review needing approval from  Managers" then
						set toDelete to true
					end if
					if subject of theMessage contains "No CRs to build" then
						set toDelete to true
					end if
					if subject of theMessage contains "SUCCESSFUL :" then
						set toDelete to true
					end if
					if subject of theMessage contains "SUCCESSFUL Nightly Build" then
						set toDelete to true
					end if
				end if
				if sender of theMessage contains "coverity_build@inv" then
					if subject of theMessage contains "No new Coverity Defects" then
						set toDelete to true
					end if
				end if
				if sender of theMessage contains "gandalf@inv" then
					if subject of theMessage contains "CR Rejected" then
						set toDelete to true
					end if
					if subject of theMessage contains "CR Approved" then
						set toDelete to true
					end if
					if subject of theMessage contains "Ready for Code Review" then
						set toDelete to true
					end if
				end if
				if toDelete is true then
					set read status of theMessage to false
					set theDeleted to theDeleted + 1
					set theCount to theCount + 1
				end if
			end repeat
			sysLog("\"" & scriptName & ": Counted: " & theCount & " Deleted: " & theDeleted & " in Echostar->Trash\"") of commonScript
		end tell
	end if
end tell
