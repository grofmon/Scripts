-- Setup Dynamic Variables
global theCount
global theUtils
global theLoop

-- Setup Static Variables
-- Static Variables
property theGrowlApp : "Mount EchoStar"
property theGrowlIcon : "AirPort Utility"
property theSetMessage : "The EchoStar newtork is mounted."
property theClearMessage : "The EchoStar newtork is un-mounted."
property mountEngineering : "smb://inverness1.echostar.com/engineering"
property mountShared : "smb://inverness1.echostar.com/shared"
property mountEngPvcs : "smb://inv-etc1.echostar.com/eng-pvcs"
property mountMontyLinux : "smb://linux-pc-251.echostar.com/monty-linux"
property mountCcshare : "smb://linux-pc-251.echostar.com/ccshare"
property mountView : "smb://linux-pc-251.echostar.com/view"
property theMounts : {mountView, mountCcshare, mountMontyLinux, mountEngineering, mountShared, mountEngPvcs}
property theDiscs : {"view", "ccshare", "monty-linux", "engineering", "shared", "eng-pvcs"}

on MountNetwork()
	log "Mounting Echostar Network"
	tell application "Finder"
		repeat theLoop times
			if not (exists disk (item theLoop of theDiscs)) then
				mount volume (item theLoop of theMounts)
				set theCount to (theCount + 1)
			end if
			set theLoop to (theLoop - 1)
		end repeat
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end MountNetwork

on UnMountNetwork()
	log "Unmounting Echostar Network"
	tell application "Finder"
		repeat theLoop times
			if (exists disk (item theLoop of theDiscs)) then
				eject (item theLoop of theDiscs)
			end if
			set theLoop to (theLoop - 1)
		end repeat
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end UnMountNetwork

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	-- Save the script name
	set theScript to utilAppName(me) of theUtils
	-- Initialize theCount
	set theCount to 0
	-- Setup Loop variable
	set theLoop to count theMounts
	
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		log theScript & ": The InputArg is \"" & InputArg & "\""
		if InputArg is "clear" then
			my UnMountNetwork()
		end if
	else
		log theScript & ": The InputArg is empty"
		if utilEchostarNetwork() of theUtils is true then
			my MountNetwork()
		end if
	end if
end run
