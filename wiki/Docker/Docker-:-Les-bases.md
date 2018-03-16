Yane permet d'utiliser plusieurs technologies de virtualisation. L'une des plus connues est Docker. Docker permet de virtualiser facilement différents systèmes d'exploitation. L'avantage et la différence de Docker par rapport aux namespaces est de pouvoir virtualiser l'hôte et ainsi de séparer l'intégralité du système de fichiers.

Pour pouvoir émuler un réseau Docker vous devez d'abord [l'installer](http://docs.docker.com/engine/installation/). Nous utiliserons ici la version communautaire de Docker 17.12.1-ce. La commande `docker version` donne la version de Docker.

Si vous souhaitez plus d'informations sur Docker :
* [documentation](http://docs.docker.com/)
* [débuter](http://training.play-with-docker.com/)
* [forums](https://forums.docker.com/)
* Un (bref) man de docker existe !

## Les images :

L'équivalent des hôtes dans yane sont des conteneurs dans Docker. Les conteneurs ne sortent pas de nulle part ! Ils sont construit à partir d'images. Avec Docker vous pouvez avoir accès à une multitude d'images différentes (ubuntu, debian, mysql, quagga, apache, etc...). Il existe des images "de base" (ubuntu, alpine, debian,...) à partir desquelles on peut construire des images plus élaborées en y ajoutant des packages, des fichiers de configurations, etc. En plus de cela le [dockerhub](https://hub.docker.com) permet à la communauté Docker de partager ces images. Grâce au DockerHub on peut réutiliser le travail d'un autre afin d'obtenir des images stables et testées par la communauté. 

La construction d'images doit être maîtrisée pour utiliser yane avec Docker.

### docker images / docker image ls :

Ces deux commandes listent toutes les images que votre système a en local :

```
# docker images 
# docker images ls
```

### docker image pull :

En vous balladant sur [DockerHub](https://hub.docker.com) vous avez reperé une image intérressante. Pour la télécharger en local :

```
# docker image pull <REPOSITORY>:<TAG>
```

#### Exemple :

```
# docker image pull python:3.5
```

### docker image build :

Cette commande permet de construire une nouvelle image à partir d'un fichier [Dockerfile](Docker: les Images).

```
# docker image build --tag <TAG> <DIR>
```

#### Exemple :

```Bash
root@Fracassse:~/wiki-docker/images # ls -l
total 8,0K
-rw-r--r-- 1 sdaste sdaste 103 févr.  7 09:51 Dockerfile
root@Fracassse:~/wiki-docker/images # docker image build --tag exemple .
```

## Les conteneurs (container) :

### docker container create :

Pour créer un conteneur à partir d'une image mais ne pas le lancer :
```
# docker create [OPTIONS] <IMAGE>:<TAG> 
```

Je ne vais citer que les options utilisées par yane :

|OPTIONS 		|USAGE
|---------------|-----------------------------------------------------------------------------------|
|`-i`			| Permet de garder l'entrée standard ouverte même si le conteneur n'est pas attaché |
|`-t`			| Alloue un [pseudo TTY]()															|
|`--name`		| Assigne un nom au conteneur 														|
|`--hostname`	| Défini l'host name du conteneur                                                   |
|`--privileged`	| Donne des privilèges étendus                                                      |
|`--network`	| Connecte le conteneur au réseau (`none` pour le connecter à aucun réseau)         |

Les options `-i`, `-t` combinées, permettent lorsque le conteneur est attaché, d'avoir accès à un terminal.

#### Exemple :

Créer un conteneur nommé host-a, "attachable", avec des privilèges, à partir de la dernière image alpine :
```
root@Fracassse:~/wiki-docker # docker container create -it --name host-a --privileged alpine:latest
7ddbc5a57c28535b689951e6af09d4bd0cb21d51ea0fb9a9b7552cc2372574a0
```

**Remarque :** Cette commande va effectuer un `pull` si il ne trouve pas l'image en local.

### docker container run / docker container start :

Pour lancer un conteneur :

```
# docker container start [OPTIONS] <CONTAINER>
```

Yane n'utilise aucunes options particulières avec `docker start`.

Pour créer et lancer un conteneur :
```
# docker container run [OPTIONS] <IMAGE>:<TAG>
```

Les options de `docker container run` sont globalement celles de `docker container create` et de `docker container start` combinées.

### docker container exec :

Une fois un conteneur lancé. Pour executer une commande dans celui-ci :

```
# docker container exec <CONTAINER> <CMD>
```

#### Exemple :

Afficher les interfaces du conteneur `host-a` :
```
root@Fracassse:~/wiki-docker # docker container exec host-a ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```

### docker container stop / docker container kill :

Pour arrêter un conteneur :
```
# docker container stop <CONTAINER>
# docker container kill <CONTAINER>
```

La différence entre `kill` et `stop` est que kill ne sauvegardera pas l'état actuel du conteneur, contrairement à stop.

**Remarque :** yane utilise `kill` principalement pour sa rapidité.

### docker container rm :

Pour supprimer un conteneur :
```
# docker container rm <CONTAINER>
```

### docker container ls :

Pour lister tous les conteneurs actifs :
```
# docker container ls
```

Pour lister tous les conteneurs (même ceux à l'arrêt) :
```
# docker container ls -a
```

#### Exemple :

```
root@Fracasse:~ # docker run -itd --name host-a alpine:latest       
a96b2cfb571b9a467b96cc5d7ce752f63fc5fd44d48bee867a7f57cbc99aca64                                                                                                    
root@Fracasse:~ # docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES                     
a96b2cfb571b        alpine              "/bin/sh"           11 seconds ago      Up 9 seconds                            host-a
```

### docker container attach :

Pour attacher la console d'un conteneur à notre terminal :
```
# docker attach <CONTAINER>
```

## Les réseaux :

Par défaut lorsqu'un conteneur est lancé il est relié au pont `docker0`. Ces réseaux sont manipulables par docker avec :

* Vous pouvez visualiser les réseaux Docker : 
```
$ docker network ls
```

* Vous pouvez connecter un conteneur à un réseau : 
```
$ docker network connect <NETWORK> <CONTAINER>
```

* Vous pouvez déconnecter un conteneur : 
```
$ docker network disconnet my_network host-a
```

* Vous pouvez créer d'autres réseaux : 
```
$ docker network create [OPTIONS] my_network
```

Malheureusement `docker network` gène le fonctionnement de yane. Pour éviter ça Docker possède un type de réseau particulier : `none`.

#### Exemple :

Pour créer un conteneur qui ne sera pas rattacher au pont `docker0` :
```
# docker create -it --privileged --name host-b --net br0 alpine
```

## 4. Et maintenant ?

Pour un exemple complet d'une utilisation de Docker voir [ici]().
Pour une meilleure idée de notre utilisation de docker avec yane je vous invite à aller voir le fichier : [ExempleDockerNamespace.md](./ExempleDockerNamespace.md).
Vous pourrez découvrir comment yane interconnecte un docker avec un namespace.

Vous pouvez également aller voir le fichier [ExempleDocker1.md](./ExempleDocker1.md) pour un exemple d'un réseau plus complexe avec docker (Docker uniquement).
