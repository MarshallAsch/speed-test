
This container is designed to run a (speedtest)[https://speedtest.net] periodicly and report the results to influxdb.

Currently this container is designed for x86_64 platforms.

## Running the container

```
$ docker run \
	-d \
	--name speedtest \
	-e DBUSER=user \
	-e DBPASS=password \
	-e DBHOST=192.168.1.3 \
	-e DBPORT=8086 \  			# Default 8086
	-e DBNAME=speed_test \   	# Default 'net_speed'
	-e TIMING=60 \     			# Default 60s
	--restart unless-stopped \
	marshallasch/speedtest
```

### Parameters

|  Parameter  | Function |
| ---------- | ------ |
| -e DBUSER | the database user |
| -e DBPASS | the database password |
| -e DBHOST | the database server |
| -e DBPORT | the database communication port |
| -e DBNAME | the database name |
| -e TIMING=30 | the number of seconds between running speed tests |


