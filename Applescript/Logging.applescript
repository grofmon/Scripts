on log_event(theMsg)
	set theLine to (do shell script "date  +'%Y-%m-%d %H:%M:%S'" as string) & " " & theMsg
	do shell script "echo " & theLine & " >> ~/Library/Logs/AppleScript-events.log"
end log_event