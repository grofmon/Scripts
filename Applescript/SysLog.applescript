on sysLog(theMsg)
	do shell script "/usr/bin/logger " & theMsg
end sysLog