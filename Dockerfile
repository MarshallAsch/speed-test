FROM debian


LABEL maintainer="Marshall Asch <maasch@rogers.com>"

RUN apt-get update && \
	apt-get install -y \
	jq \
	curl

WORKDIR /root

COPY speedTest.sh /root/speedTest.sh
COPY speedTest_once.sh /root/speedTest_once.sh

COPY speedtest /root/speedtest

# Make sure they are executable
RUN chmod +x /root/speedTest.sh /root/speedTest_once.sh /root/speedtest && \
	mv /root/speedtest /bin/speedtest

CMD /root/speedTest.sh
