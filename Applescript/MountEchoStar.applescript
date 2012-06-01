-- Setup Dynamic Variables
global theUtils
global theLoop
global isMounted

-- Setup Static Variables
-- Static Variables
property theGrowlApp : "Mount EchoStar"
property theGrowlIcon : "AirPort Utility"
property theSetMessage : "The EchoStar newtork is mounted."
property theClearMessage : "The EchoStar newtork is un-mounted."
property mountEngineering : "smb://inverness1.echostar.com/engineering"
property mountShared : "smb://inverness1.echostar.com/shared"
property mountEngPvcs : "smb://inv-etc1.echostar.com/eng-pvcs"
property mountMontyLinux : "smb://10.79.97.251/monty-linux"
property mountCcshare : "smb://10.79.97.251/ccshare"
property mountView : "smb://10.79.97.251/view"
property theMounts : {mountView, mountCcshare, mountMontyLinux, mountEngineering, mountShared, mountEngPvcs}
property theDiscs : {"view", "ccshare", "monty-linux", "engineering", "shared", "eng-pvcs"}

on MountNetwork()
	tell application "Finder"
		repeat theLoop times
			try
				mount volume (item theLoop of theMounts)
			on error
				log "Oops!"
			end try
			set theLoop to (theLoop - 1)
		end repeat
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theSetMessage) of theUtils
end MountNetwork

on UnMountNetwork()
	tell application "Finder"
		repeat theLoop times
			try
				eject (item theLoop of theDiscs)
			on error
				log "Oops!"
			end try
			set theLoop to (theLoop - 1)
		end repeat
	end tell
	utilNotifyGrowl(theGrowlApp, theGrowlIcon, theClearMessage) of theUtils
end UnMountNetwork

on run argv
	-- Setup access to Utilities script
	set theUtils to load script alias ((path to library folder from user domain as string) & "Scripts:Utils.scpt")
	
	-- Setup Loop variable
	set theLoop to count theMounts
	set isMounted to false
	
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		if InputArg is "clear" then
			my UnMountNetwork()
		else if InputArg is "set" then
			my MountNetwork()
		end if
	else
		tell application "Finder"
			repeat theLoop times
				if (exists disk (item theLoop of theDiscs)) then
					set isMounted to true
					exit repeat
				end if
			end repeat
		end tell
		
		if isMounted is true then
			my UnMountNetwork()
		else
			my MountNetwork()
		end if
	end if
end run
