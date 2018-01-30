#!/bin/bash
#-------------------------------------------------------------------------------------
#Kill and delete every container named stationX
echo Deleting remaining stations
docker container kill stationA stationB stationC stationD stationE 2> /dev/null
docker container rm stationA stationB stationC stationD stationE 2> /dev/null

#Delete every bridge named br0 or br1
echo Deleting remaining network
docker network rm br0 br1 2> /dev/null
#-------------------------------------------------------------------------------------

#Create bridges
echo Creating Briges...
docker network create -d bridge --subnet 192.168.1.0/24 br0 > /dev/null
echo br0 OK
docker network create -d bridge --subnet 192.168.2.0/24 br1 > /dev/null
echo br1 OK

#Create hosts
echo Creating Hosts...
docker create -it --name stationA --hostname stationA --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh > /dev/null
echo StationA OK
docker create -it --name stationB --hostname stationB --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh > /dev/null
echo StationB OK
docker create -it --name stationC --hostname stationC --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh > /dev/null
echo StationC OK
docker create -it --name stationD --hostname stationD --net br1 --cap-add NET_ADMIN alpine:latest /bin/sh > /dev/null
echo StationD OK
docker create -it --name stationE --hostname stationE --net br1 --cap-add NET_ADMIN alpine:latest /bin/sh > /dev/null
echo StationE OK

#Boot hosts
echo Booting hosts...
docker start stationA > /dev/null
echo StationA started
docker start stationB > /dev/null
echo StationB started
docker start stationC > /dev/null
echo StationC started
docker start stationD > /dev/null
echo StationD started
docker start stationE > /dev/null
echo StationE started

#Connect C to br1
docker network connect br1 stationC

#Set IP addresses
echo Configurating IP...
docker exec stationA ip addr add 192.168.1.10/24 dev eth0
docker exec stationB ip addr add 192.168.1.20/24 dev eth0
docker exec stationC ip addr add 192.168.1.30/24 dev eth0
docker exec stationC ip addr add 192.168.2.10/24 dev eth1
docker exec stationD ip addr add 192.168.2.20/24 dev eth0
docker exec stationE ip addr add 192.168.2.30/24 dev eth0
echo IP configs OK

#Set routes
docker exec stationA ip route add 192.168.2.0/24 via 192.168.1.30
docker exec stationB ip route add 192.168.2.0/24 via 192.168.1.30
docker exec stationD ip route add 192.168.1.0/24 via 192.168.2.10
docker exec stationE ip route add 192.168.1.0/24 via 192.168.2.10

#Activate routing
echo Station C is now a router
docker exec stationC echo 1 > /proc/sys/net/ipv4/ip_forward

echo Si vous voulez interagir avec une station :
echo Run : $ docker attach stationA
