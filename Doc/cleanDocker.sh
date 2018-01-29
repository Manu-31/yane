#!/bin/bash
#-------------------------------------------------------------------------------------
#Kill and delete every container named stationX
echo Deleting remaining stations
docker container kill stationA stationB stationC stationD stationE 2> /dev/null
docker container rm stationA stationB stationC stationD stationE 2> /dev/null

#Delete every bridge named br0 or br1
echo Deleting remaining network
docker network rm br0 br1 2> /dev/null
