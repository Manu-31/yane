Bases de Docker
===============

Yane permet d'utiliser plusieurs technologies de virtualisation. L'une des plus connue est Docker. Docker permet d'emuler différents systèmes sur n'importe quel OS. Pour pouvoir émuler un réseau Docker vous devez d'abord [l'installer](http://docs.docker.com/engine/installation/). Nous utiliserons ici la version communautaire de Docker.

Si vous souhaitez plus d'informations sur l'utilisation de Docker :
* [documentation](http://docs.docker.com/)
* [débuter](http://training.play-with-docker.com/)
* [forums](https://forums.docker.com/)
* Un man de docker existe !

1 - Lancer un container docker
----------------------------

L'équivalent des hosts dans yane seront des containers dans Docker. L'avantage de docker par rapport aux namespaces est de pouvoir avoir accès a une multitude d'images de container différentes (ubuntu, debian, ...) mais aussi de pouvoir y lancez toutes sortes d'applications (bases de données, serveur web, etc...) grâce au [dockerhub](http://hub.docker.com). On pourra ainsi générer du traffic varié sur notre réseau.

La première chose à faire est de lancer un container simple avec des outils indispensable en réseau (ifconfig/ip-tools, route, traceroute, ping, etc...). Pour notre premier hôte on va utiliser une image [alpine](http://alpinelinux.org/) (c'est une distribution linux). Lançons donc un container de alpine et faisons en sorte qu'il ne s'arrête pas.

		$ docker run -itd --name=host-a alpine       
		a96b2cfb571b9a467b96cc5d7ce752f63fc5fd44d48bee867a7f57cbc99aca64                                                                                                    
		root@r2d2~# docker container ls
		CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES                     
		a96b2cfb571b        alpine              "/bin/sh"           11 seconds ago      Up 9 seconds                            host-a

Si vous souhaitez interagir avec votre container et par exemple y lancer des programmes, créer des fichiers, installer des packages, etc... Il existe différentes manière de le faire :

* Pour lancer une seule commande sur le container host-a : `$ docker exec host-a echo hello world`.
* Pour lancer un terminal sur le container host-a : `$ docker exec -it host-a sh`

On peut donc lancer un ifconfig pour voir la configuration réseau de ce container ou bien tenter de pinger depuis cette machine une adresse IP connu :

		$ docker exec host-a ping 8.8.8.8

Ou bien consulter vos interfaces ainsi que les routes crées par Docker :

		$ docker exec host-a route-n ; ip a

Si vous créez d'autres containers ils seront placés dans le même réseau par défaut. En effet docker a mis en place un réseau tout seul où tous vos container sont reliés entre-eux par un bridge.

Vous pouvez arrêter un container grâce à la commande : `$ docker container kill host-a`
Vous pouvez le relancer avec : `$ docker container restart host-a`

2 - Créer un réseau avec Docker
-----------------------------

Notre objectif est d'émuler des réseaux. Nous sommes capable de mettre en place un seul réseau avec plusieurs machines dedans. Mais il serais plus interessant de pouvoir émuler plusieurs réseaux.

Pour cela Docker possède une fonctionnalité parfaite : `$ docker network` :
* Vous pouvez visualiser les réseaux docker déjà présent grâce à : `$ docker network ls`.
* Vous pouvez connecter un container à un réseau grâce à la commande : `$ docker network connect my_network host-a`. En réalité cela revient à ajouter une interface à notre container. Docker va de lui même ajouter une adresse IP.
* Vous pouvez déconnecter un container d'un réseau grâce à la commande : `$ docker network disconnet my_network host-a`. Ici cela revient à supprimer une interface de notre container.
* Vous pouvez créer de nouveaux réseau grâce à la commande : `$ docker network create --gateway=10.0.0.1 --subnet=10.0.0.0/16 my_network`. Par défaut ce réseau repose sur un driver de type bridge. Ceci signifie que Docker créer un bridge où tous les hôtes connectés à ce réseau seront reliés à celui-ci. Il existe d'autres drivers fournis par Docker, nous n'en parlerons pas ici.

**Remarque**: un container peut être connecté à plusieurs réseaux on peut donc créer des routeurs !

3 - Et maintenant ?
-------------------

Avec nous utilisons docker de manière différente qu'ici. Pour une meilleur idée de notre utilisation de docker avec yane je vous invite à aller voir le fichier : ExempleDockerNamespace.md.
Vous pourrez découvrir comment yane interconnecte un docker avec un namespace.

Vous pouvez également aller voir le fichier ExempleDocker1.md pour un exemple d'un réseau plus complexe avec docker (docker uniquement).
