on echostarNetwork()
	-- Grab the IP address
	set IpAddr to do shell script "/sbin/ifconfig  | grep 'inet'| grep -v '127.0.0.1' | grep -v 'inet6' | awk '{ print $2}'" -- add this to get the first octet " | cut -d. -f1"
	-- Check to see if the IP address is 'like' those on the E* Networks
	if IpAddr contains "10.73" or IpAddr contains "10.79" then
		log "Connected to Echostar Network"
		return true
	else
		log "Not connected to Echostar Network"
		return false
	end if
end echostarNetwork