-- Get the IP address
set theIp to do shell script "/sbin/ifconfig  | grep 'inet'| grep -v '127.0.0.1' | grep -v 'inet6' | awk '{ print $2}'" -- add this to get the first octet " | cut -d. -f1"

-- Local Variables
set Engineering to "smb://inverness1/engineering"
set Shared to "smb://inverness1/shared"
set Software to "smb://inverness1/engineering/software"
set Linux to "smb://linux-pc-251/linux"
set Ccshare to "smb://linux-pc-251/ccshare"
-- Local lists
set theMountList to {Software, Shared, Linux, Engineering, Ccshare}
set theDiskList to {"software", "shared", "linux", "engineering", "ccshare"}
-- Loop variable
set loopVar to count theMountList

-- If we are connected to an EchoStar Network, the ip address will start with 10.73 or 10.79
if theIp contains "10.73" or theIp contains "10.79" then
	-- Tell Finder what to do
	tell application "Finder"
		-- Loop through the mounts
		repeat loopVar times
			-- mount if NOT mounted
			if not (exists disk (item loopVar of theDiskList)) then
				mount volume (item loopVar of theMountList)
			end if
			-- Update the loop variable
			set loopVar to (loopVar - 1)
		end repeat
	end tell
else
	tell application "Finder"
		repeat loopVar times
			-- Eject if already mounted
			if (exists disk (item loopVar of theDiskList)) then
				eject (item loopVar of theDiskList)
			end if
			-- Update the loop variable
			set loopVar to (loopVar - 1)
		end repeat
	end tell
end if


