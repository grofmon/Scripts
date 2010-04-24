tell application "Finder"
	try
		mount volume "SMB://montgomery.groff@in4d153002.echostar.com/Music$/"
	on error
		display dialog "There was an error mounting the Volume." & return & return & Â
			"The server may be unavailable at this time." & return & return & Â
			"Please inform the Network Administrator if the problem continues." buttons {"Okay"} default button 1
	end try
end tell
