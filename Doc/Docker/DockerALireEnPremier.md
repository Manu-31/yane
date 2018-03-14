# Bases de Docker

Yane permet d'utiliser plusieurs technologies de virtualisation. L'une des plus connues est Docker. Docker permet de virtualiser facilement différents systèmes d'exploitation. L'avantage et la différence de docker par rapport aux namespaces est de pouvoir virtualiser l'hôte et ainsi de séparer l'intégralité du système de fichier.

Pour pouvoir émuler un réseau Docker vous devez d'abord [l'installer](http://docs.docker.com/engine/installation/). Nous utiliserons ici la version communautaire de Docker 17.12.1-ce. La commande `docker version` nous donne la version de votre Docker.

Si vous souhaitez plus d'informations sur Docker :
* [documentation](http://docs.docker.com/)
* [débuter](http://training.play-with-docker.com/)
* [forums](https://forums.docker.com/)
* Un (bref) man de docker existe !

***

L'équivalent des hôtes dans yane sont des containers dans Docker. Les containers ne sortent pas de nulle part ! Ils sont construit à partir d'images. Avec Docker vous pouvez avoir accès à une multitude d'images différentes (ubuntu, debian, mysql, quagga, apache, etc...). Il existe des images "de base" (ubuntu, alpine, debian,...) à partir desquelles on peut construire des images plus élaborées en y ajoutant des packages, des fichiers de configurations, etc. En plus de cela le [dockerhub](http://hub.docker.com) permet à la communauté Docker de partager ces images. Grâce au DockerHub on peut réutiliser le travail d'un autre afin d'obtenir des images stables et testées par la communauté. 

## 1. Lancer un container docker

La première chose à faire est de lancer un container simple avec des outils indispensable en réseau (ifconfig/net-tools, ip-route2, traceroute, ping, etc...). Pour notre premier hôte on va utiliser une image [alpine](http://alpinelinux.org/) (c'est une distribution Linux). Lançons donc un container de alpine et faisons en sorte qu'il ne s'arrête pas.
```
$ docker run -itd --name=host-a alpine       
a96b2cfb571b9a467b96cc5d7ce752f63fc5fd44d48bee867a7f57cbc99aca64                                                                                                    
root@r2d2~# docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES                     
a96b2cfb571b        alpine              "/bin/sh"           11 seconds ago      Up 9 seconds                            host-a
```
Si vous souhaitez interagir avec votre container et par exemple y lancer des programmes, créer des fichiers, installer des packages, etc... Il existe différentes manière de le faire :

* Pour lancer une seule commande sur le container host-a : `$ docker exec host-a echo hello world`.
* Pour lancer un terminal sur le container host-a : `$ docker exec -it host-a sh`

On peut donc lancer un ifconfig pour voir la configuration réseau de ce container ou bien tenter de pinger depuis cette machine une adresse IP connu :

		$ docker exec host-a ping 8.8.8.8

**Remarque :** Par défaut docker donne un accès à internet ! Ce n'est pas le cas dans yane ! (voir les [services](https://github.com/SylvainDaste/yane/blob/3b04fb0e0acfb342116c4768b31e2a3e9975646b/yane_module_services) et notamment le service [dnsmasq](https://github.com/SylvainDaste/yane/blob/3b04fb0e0acfb342116c4768b31e2a3e9975646b/yane_module_dnsmasq)).

Ou bien consulter vos interfaces ainsi que les routes créées par Docker :

		$ docker exec host-a ip route ; ip a

Si vous créez d'autres containers ils seront placés dans le même réseau par défaut. En effet docker a mis en place, par défaut, un réseau où tous vos containers sont reliés entre-eux par un bridge. Par défaut ce bridge est `docker0`. Vous pouvez le consulter avec `# brctl show docker0`.

## 2. Arrêter un container

Vous pouvez arrêter un container grâce à la commande : `$ docker container kill host-a`
Vous pouvez le relancer avec : `$ docker container restart host-a`

## 3. Les réseaux avec Docker

Dans cette partie notre objectif sera d'émuler des réseaux. Nous sommes capable de mettre en place un seul réseau (containers avec bridge docker0). Cependant nous ne pouvons pas spécifier sa topologie. Il serait plus intéressant de pouvoir émuler plusieurs sous-réseaux et de les interconnecter.

Pour cela Docker possède une fonctionnalité toute faite : `$ docker network` :
* Vous pouvez visualiser les réseaux docker déjà présent grâce à : `$ docker network ls`.
* Vous pouvez connecter un container à un réseau grâce à la commande : `$ docker network connect my_network host-a`. En réalité cela revient à ajouter une interface à notre container. Docker va de lui même ajouter une adresse IP.
* Vous pouvez déconnecter un container d'un réseau grâce à la commande : `$ docker network disconnet my_network host-a`. Cela revient à supprimer une interface de notre container.
* Vous pouvez créer de nouveaux réseaux grâce à la commande : `$ docker network create --gateway=10.0.0.1 --subnet=10.0.0.0/16 my_network`. Par défaut ce réseau repose sur un driver de type bridge. Ceci signifie que Docker créer un bridge où tous les containers connectés à ce réseau y seront reliés. Il existe d'autres drivers fournis par Docker, nous n'en parlerons pas ici.

**Remarque**: un container peut être connecté à plusieurs réseaux on peut donc créer des routeurs !

## 4. Et maintenant ?

Avec yane nous utilisons Docker d'une autre manière qu'ici. Pour une meilleure idée de notre utilisation de docker avec yane je vous invite à aller voir le fichier : [ExempleDockerNamespace.md](./ExempleDockerNamespace.md).
Vous pourrez découvrir comment yane interconnecte un docker avec un namespace.

Vous pouvez également aller voir le fichier [ExempleDocker1.md](./ExempleDocker1.md) pour un exemple d'un réseau plus complexe avec docker (Docker uniquement).
