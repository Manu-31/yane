Cet exemple explique comment Docker peut permettre la mise en place d'un réseau. Ici seulement Docker est utilisé (pas de yane ;-)). Cependant il peut vous permettre de comprendre comment yane intègre Docker quand bien même il ne le réalise pas exactement de la même façon. Le but de cet exemple est de vous familiariser avec Docker et de mettre en pratique ce que nous avons vu précédemment. Le même exemple réalisé avec yane se trouve [ici](https://github.com/SylvainDaste/yane/tree/908937b3e405379cf55557eb002b8f3bf9692d9c/examples/docker-1).

**Script :** à la fin de cette page vous trouverez un script récapitulant les différentes commandes vu ici.

**Attention :** Noubliez pas de stopper et d'enlever vos containers lorsque vous n'en n'aurez plus besoin : `# docker kill <docker-id>` et `# docker rm <docker-id>`

## Détails de la configuration souhaitée :

![Réseau simple de machines docker](https://github.com/SylvainDaste/yane/blob/908937b3e405379cf55557eb002b8f3bf9692d9c/Doc/Docker/reseau_simple_1.jpg "Réseau simple de machine docker")

**Sous réseau br0 :** 192.168.1.0/24

|Stations   |A           |B           |C           |
|-----------|------------|------------|------------|
|Adresses IP|192.168.1.10|192.168.1.20|192.168.1.30|

**Sous réseau br1 :** 192.168.2.0/24

|Station   |C           |D           |E           |
|----------|------------|------------|------------|
|Adresse IP|192.168.2.10|192.168.2.20|192.168.2.30|


## Créations des ponts :

```
$ docker network create -d bridge --subnet 192.168.1.0/24 br0
$ docker network create -d bridge --subnet 192.168.2.0/24 br1
```

Ces deux commandes vont mettre en place deux ponts que l'on peut observer avec `brctl` ou `bridge` :

```
$ brctl show
bridge name		bridge id		STP enabled	interfaces
br-48ed238142f0		8000.02426b4a0c5a	no		veth315a5d9
								vethb45bdb7
								vethe9e8281
br-4c8d1d3ab5cf		8000.024246a2fbb5	no		vetha16ecfe
								vethdbd76cb
								vethf2c06fe
docker0			8000.0242f46784a9	no
```

**Remarque :** `docker0` est le pont par défault de Docker.

## Créations des hosts :

```
$ docker create -it --name stationA --hostname stationA --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh
$ docker create -it --name stationB --hostname stationB --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh
$ docker create -it --name stationC --hostname stationC --net br0 --cap-add NET_ADMIN alpine:latest /bin/sh
$ docker create -it --name stationD --hostname stationD --net br1 --cap-add NET_ADMIN alpine:latest /bin/sh
$ docker create -it --name stationE --hostname stationE --net br1 --cap-add NET_ADMIN alpine:latest /bin/sh
```

**Rappels :** L'option `--cap-add NET_ADMIN` permet au conteneur de pouvoir modifier ses propres interfaces. On pourrait aussi utiliser l'option `--privileged` qui est plus générale.

## Boot des hosts :

```
		$ docker start stationA
		$ docker start stationB
		...
```

## Le cas de la station C :

La stationC appartient déjà au réseau 192.168.1.0/24 mais pas à 192.168.2.0/24 :

```
		$ docker network connect stationC br1
```

## Mettre en place les adresses ip :

```
		$ docker exec stationA ip addr add 192.168.1.10/24 dev eth0
		$ docker exec stationB ip addr add 192.168.1.20/24 dev eth0
		$ docker exec stationC ip addr add 192.168.1.30/24 dev eth0
		$ docker exec stationC ip addr add 192.168.2.10/24 dev eth1
		...
```

## Activez le routage de C :

```
		$ docker exec stationC echo 1 > /proc/sys/net/ipv4/ip_forward
```

## Mettre en place les tables de routage des stations :


* Stations d'extrémitées X du sous réseau 192.168.1.0/24 :

```
		$ docker exec stationX ip route add 192.168.2.0/24 via 192.168.1.30
```

* Stations d'extrémitées X du sous réseau 192.168.2.0/24 :

```
		$ docker exec stationX ip route add 192.168.1.0/24 via 192.168.2.10
```

# Qu'est-ce que yane réutilise de cet exemple pour intégrer Docker ?

Cette question est importante. Yane doit pouvoir faire communiquer des technologies de virtualisation différentes. Par exemple les netns doivent pouvoir être en capacités de communiquer avec un conteneur Docker. Par conséquent les commandes `# docker network` ne sont pas envisageables pour configurer les conteneurs Docker. En revanche yane utilise exactement la même technique qu'ici pour créer puis booter les stations.

Pour comprendre comment yane met en place des liens entre netns et conteneurs Docker il faut lire la page : [Netns et Docker]()

# Script

```Bash
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
echo Run : $ docker attach station<ID_STATION>
```