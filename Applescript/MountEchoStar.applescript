--Logging
set logScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utilities:SysLog.scpt")
tell application "Finder"
	set thisPath to path to me
	set thisScript to name of file thisPath as text
end tell

-- Get the IP address
set en0Ip to do shell script "/sbin/ifconfig en0 | grep 'inet ' | awk '{print $2}'"
set en1Ip to do shell script "/sbin/ifconfig en1 | grep 'inet ' | awk '{print $2}'"

-- Local Variables
set pathEngineering to "smb://inverness1.echostar.com/engineering"
set path2200 to "smb://inverness1.echostar.com/engineering/software/2200"
set pathShared to "smb://inverness1.echostar.com/shared"
set pathMorpheus to "smb://edn-data2.echostar.com/morpheus"
set pathLinux to "smb://10.79.97.251/linux"
set pathCcshare to "smb://10.79.97.251/ccshare"
set pathCablebox to "smb://10.79.97.251/ccshare/linux/c_files/cablebox"
set thisMsg to thisScript & ": Mounting "

-- Tell Finder what to do
tell application "Finder"
	-- If we are connected to an EchoStar Network, the ip address will start with 10.7x
	set eNetwork to "false"
	if en0Ip contains "10." then
		set eNetwork to "true"
	end if
	if en1Ip contains "10." then
		set eNetwork to "true"
	end if
	if eNetwork is "true" then
		try
			sysLog(thisMsg & path2200) of logScript
			mount volume path2200
		end try
		
		try
			sysLog(thisMsg & pathCablebox) of logScript
			mount volume pathCablebox
		end try
		
		try
			sysLog(thisMsg & pathCcshare) of logScript
			mount volume pathCcshare
		end try
		
		try
			sysLog(thisMsg & pathLinux) of logScript
			mount volume pathLinux
		end try
		
		(*
		try
			sysLog(thisMsg & pathEngineering) of logScript
			mount volume pathEngineering
		end try
*)
		(*
		try
			sysLog(thisMsg & pathShared) of logScript
			mount volume pathShared
		end try
*)
		(*
		try
			sysLog(thisMsg & pathMorpheus) of logScript
			mount volume pathMorpheus
		end try
*)
	end if
end tell


