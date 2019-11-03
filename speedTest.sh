#!/bin/bash


#
# ENvironment variables that MUST be set in order for the script to function:
#
# - DBUSER
# - DBPASS
# - DBHOST
# - DBPORT	(default 8086)
# - DBNAME  (default 'net_speed')
#
# - TIMING (optional default 60) this is the number of seconds between polling the UPS
#
#


# TIMING should not be less than the daemons UPS polling rate (default 3s)
SEC_BETWEEN=$TIMING

if [ -z "$SEC_BETWEEN" ]
then
    SEC_BETWEEN=60
fi

if [ -z "$DBPORT" ]
then
    DBPORT=8086
fi

if [ -z "$DBNAME" ]
then
    DBNAME=net_speed
fi

# Make sure all of the required ENV variables are set
if [ -z "$DBUSER" ] || [ -z "$DBPASS" ] || [ -z "$DBHOST" ] || [ -z "$DBNAME" ]
then
     exit 1
fi

while :
do

	STATS=$(speedtest --accept-license -f json-pretty)


	LATENCY=$(echo -e "$STATS" | jq ".ping.latency" )
	JITTER=$(echo -e "$STATS" | jq ".ping.jitter")
	ISP=$(echo -e "$STATS" | jq ".isp")
	SERVER_ID=$(echo -e "$STATS" | jq ".server.id")
	SERVER_IP=$(echo -e "$STATS" | jq ".server.ip")
	SERVER_HOST=$(echo -e "$STATS" | jq ".server.host")
	INTERFACE=$(echo -e "$STATS" | jq ".interface.name")
	DOWNLOAD_BANDWIDTH=$(echo -e "$STATS" | jq ".download.bandwidth")
	UPLOAD_BANDWIDTH=$(echo -e "$STATS" | jq ".upload.bandwidth")
	TIMESTAMP=$(echo -e "$STATS" | jq ".timestamp")


	/usr/bin/curl -s -i -XPOST -u $DBUSER:$DBPASS "http://$DBHOST:$DBPORT/write?db=$DBNAME" --data-binary "speed_test,host=$HOSTNAME latency=$LATENCY,jitter=$JITTER,isp=$ISP,server_id=$SERVER_ID,server_ip=$SERVER_IP,server_host=$SERVER_HOST,interface=$INTERFACE,download_bandwidth=$DOWNLOAD_BANDWIDTH,upload_bandwidth=$UPLOAD_BANDWIDTH,timestamp=$TIMESTAMP" > /dev/null

	sleep $SEC_BETWEEN

done
