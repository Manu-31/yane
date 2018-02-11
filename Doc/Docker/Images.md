Les images avec docker
======================

Qu'est ce qu'une image ?
------------------------

Une image docker permet de gardez en mémoire l'état d'un système (fichiers, configurations,...). Une image peut être obtenue à partir d'un container sur lequel on a, par exemple installé des programmes. Si l'on supprimait ce container on perdrait toute notre progression. En revanche si on souhaite garder ce container dans son état actuel pour le partager, le distribuer, etc. docker nous fourni la commande `docker commit`.

On peut également mettre en place une image à partir d'un Dockerfile. Celui-ci va définir quels programmes seront installés, quels fichiers seront présent dans notre container dès sa mise en fonctionnement. Une fois le Dokerfile écrit les fichiers nécéssaire placés dans le répertoire de notre Dockerfile on peut lancer la création de notre image avec la commande `docker build --tag <NAME>:<VERSION>`.

Docker grâce à sa communauté fourni aussi toute sorte d'image disponible sur [DockerHub](http://hub.docker.com). Vous pouvez récupérer ces images grâce à la commande `docker pull <NAME>:<VERSION>`.
