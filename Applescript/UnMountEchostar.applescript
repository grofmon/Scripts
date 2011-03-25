--Logging
set logScript to load script alias ((path to library folder from user domain as string) & "Scripts:Utilities:SysLog.scpt")
tell application "Finder"
	set thisPath to path to me
	set thisScript to name of file thisPath as text
end tell

-- Local Variables
set pathEngineering to "smb://inverness1/engineering"
set path2200 to "smb://inverness1/engineering/software/2200"
set pathShared to "smb://inverness1/shared"
set pathMorpheus to "smb://edn-data2/morpheus"
set pathLinux to "smb://linux-pc-251/linux"
set pathCcshare to "smb://linux-pc-251/ccshare"
set pathCablebox to "smb://linux-pc-251/ccshare/linux/c_files/cablebox"
set thisMsg to thisScript & ": Un-Mounting "

-- Tell Finder what to do
tell application "Finder"
	try
		sysLog(thisMsg & pathLinux) of logScript
		eject "linux"
	end try
	try
		sysLog(thisMsg & path2200) of logScript
		eject "2200"
	end try
	try
		sysLog(thisMsg & pathEngineering) of logScript
		eject "engineering"
	end try
	try
		sysLog(thisMsg & pathShared) of logScript
		eject "shared"
	end try
	try
		sysLog(thisMsg & pathMorpheus) of logScript
		eject "morpheus"
	end try
	try
		sysLog(thisMsg & pathCcshare) of logScript
		eject "ccshare"
	end try
	try
		sysLog(thisMsg & pathCablebox) of logScript
		eject "cablebox"
	end try
end tell