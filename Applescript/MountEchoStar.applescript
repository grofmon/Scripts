-- Setup Dynamic Variables
global InputArg
global loopVar
global IpAddr

-- Setup Static Variables
property InputArg : ""
property Engineering : "smb://inverness1/engineering"
property Shared : "smb://inverness1/shared"
property Software : "smb://inverness1/engineering/software"
property Linux : "smb://linux-pc-251/linux"
property Ccshare : "smb://linux-pc-251/ccshare"
property MountList : {Software, Shared, Linux, Engineering, Ccshare}
property DiskList : {"software", "shared", "linux", "engineering", "ccshare"}

on MountNetwork()
	-- Get the IP address
	set IpAddr to do shell script "/sbin/ifconfig  | grep 'inet'| grep -v '127.0.0.1' | grep -v 'inet6' | awk '{ print $2}'" -- add this to get the first octet " | cut -d. -f1"
	
	-- If we are connected to an EchoStar Network, the ip address will start with 10.73 or 10.79	
	if IpAddr contains "10.73" or IpAddr contains "10.79" then
		log "Mounting Echostar Network"
		-- Tell Finder what to do
		tell application "Finder"
			-- Loop through the mounts
			repeat loopVar times
				-- mount if NOT mounted
				if not (exists disk (item loopVar of DiskList)) then
					mount volume (item loopVar of MountList)
				end if
				-- Update the loop variable
				set loopVar to (loopVar - 1)
			end repeat
		end tell
	end if
end MountNetwork

on UnMountNetwork()
	log "Unmounting Echostar Network"
	tell application "Finder"
		repeat loopVar times
			-- Eject if already mounted
			if (exists disk (item loopVar of DiskList)) then
				eject (item loopVar of DiskList)
			end if
			-- Update the loop variable
			set loopVar to (loopVar - 1)
		end repeat
	end tell
end UnMountNetwork

on run argv
	-- Setup Loop variable
	set loopVar to count MountList
	
	-- Get the command line argument if there is one
	if (count argv) is greater than 0 then
		set InputArg to item 1 of argv
		log "The InputArg is \"" & InputArg & "\""
		if InputArg is "unmount" then
			my UnMountNetwork()
		end if
	else
		log "The InputArg is empty"
		my MountNetwork()
	end if
end run
