FROM ubuntu:latest
RUN apt-get update
RUN apt-get -y install iproute2 net-tools quagga telnet nano iputils-ping tcpdump inetutils-traceroute 
COPY  ./quagga /etc/quagga
ENTRYPOINT /etc/init.d/quagga start && /bin/bash
