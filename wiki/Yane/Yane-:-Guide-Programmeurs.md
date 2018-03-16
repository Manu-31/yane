## Comment fonctionne yane ?

yane est à l'heure actuelle simplement composé de quelques scripts en
bash, ... Un jour on fera peut-être mieux, mais pour le moment, ça
suffit !

### Structure générale

Lors du lancement du programme, un fichier de description du réseau à
simuler est analysé. Il en résulte l'initialisation d'un certain
nombre de variables internes. Aucune commande externe n'est utilisée à
ce moment.

Selon les options utilisées, les commandes nécessaires sont ensuite
lancées. Ainsi, le comportement par défaut est de démmarer une
instance du réseau, les commandes de démarrage des outils de
virtualisation sont alors utilisées.

### Les modules

Oui, yane est modulaire ! Lors du lancement du programme, la fonction
`yaneLoadModules` charge l'ensemble des modules disponibles.

Chaque module `toto` est matérialisé par un fichier `yane_module_toto`
dans le répertoire pointé par `YANE_ROOT_DIR`.

Par défaut, au démarrage, `yane` donne la liste des modules chargés.

### Notion de session

Une session, c'est une instance d'un réseau en cours d'exécution. Pour
un réseau donné (décrit par un fichier de configuration), zéro, une ou
plusieurs instances peuvent s'exécuter simultanément.

yane permet, à un instant donné, d'agir sur une session unique. Elle
est définie par le contenu de la variable `SESSION_ID`. Cette variable
est initialisée automatiquement par yane ou peut être spécifiée par
l'option `-s <id>` si besoin.

La liste des sessions est fournie par l'option `-l`.

#### Nommage des éléments

Si une machine est décrite dans un fichier de configuration avec le
nom `toto`, alors lors de la création de la session `sid` l'instance
correspondante sera créée avec le nom `sid_toto`.

## Ajout d'un outil de virtualisation

Un des objectifs de yane est d'intégrer des outils de virtualisation
divers et variés. Cette section décrit la structure actuelle de yane
de ce point de vue.

Un outil de virtualisation est défini par le biais d'un module, tel
que décrit ci-dessus. Il doit implanter un certain nombre de
fonctions, listées ci-dessous en prenant comme base le nom de module
`toto`. Les fonctions suivantes doivent donc être implantées en bash
dans le fichier `$YANE_ROOT_DIR/yane_module_toto`

Pour mémoire, toutes les opérations décrites ici se font sur une
instance d'une machine. Dans la description d'un réseau, les machines
sont décrites par un nom (`host-a`, `host-b` par exemple). Lors de la
création d'une session (l'exécution d'une simulation), ce nom est
préfixé par l'identifiant de la session, de sorte à éviter les
confusions. De ce fait, le `nom` décrit dans les fonctions ci-dessous
sera de la forme `4832_host-a`, `4832_host-b`.

### Création d'un hôte

La fonction suivante doit créer une instance de machine virtuelle.

```createHost_toto nom```

Si aucune initialisation n'est nécessaire avant de booter une machine,
alors cette fonction est vide et ne fait rien, ...

### Démarrage d'un hôte

La fonction suivante doit démarrer une instance de machine virtuelle.

```bootHost_toto nom```

### Extinction d'un hôte

```shutdownHost_toto nom```

### Destruction d'un hôte

```deleteHost_toto nom```

### Ouverture d'un terminal

La fonction suivante doit renvoyer une chaîne de caractères contenant
la commande à lancer pour obtenir un terminal sur l'hôte dont le nom
est passé en paramètre.

```yaneConsoleCmd_netns nom```

La commande en question sera typiquement lancée dans une console
(par exemple un xterm) ouverte pour cela.

## Ajout d'autres types de terminaux

### Yane est modulaire, les consoles aussi.

En effet pour construire un nouveaux mode de console vous devez comprendre que chaque mode de console est en réalité un sous module du module `yane_module_console`.

### Nommage du module

Par conséquent le nouveau mode sera principalement codé dans le fichier `yane_module_console_modeName`.

Par exemple :

* [yane_module_consoles_tmux](../yane_module_consoles_tmux)
* [yane_module_consoles_xterm](../yane_module_consoles_xterm)

### Structure du sous-module

Chaque module doit contenir au minimum 2 fonctions :
* yaneOpenConsoleWindow_modeName

Cette fonction est appelé pour chaque terminal. Ainsi si vous souhaitez ouvrir 3 terminaux pour 3 machines différentes cette fonction sera appelée 3 fois.

Son rôle est donc d'ouvrir un terminal (xterm, gnome-terminal, konsole, terminator, ...) et d'y lancer la commande permettant d'ouvrir un shell sur la machine. Celle-ci est obtenue grâce à la fonction `yaneConsoleCmd_hostMode` des modules de virtualisations.

**Important :**  Le module [yane_module_console](../yane_module_console) ne doit pas être modifié car c'est lui qui appellera ces 2 fonctions.

Dans le cas de terminaux plus complexe comme tmux ou terminator qui permettent l'ouverture de plusieurs terminaux en une seule fenêtre, vous devrez probablement complexifier votre fonction. En effet vous devrez non seulement ouvrir un nouveau terminal mais aussi l'ouvrir au bon endroit. Le module [yane_module_consoles_tmux](yane_module_consoles_tmux) en est un exemple. Si vous avez besoin de définir des variables globales vous devrez alors les déclarer dans le fichier [yane](../yane).

Comme l'organisation des terminaux/consoles est définie dans le fichier `yane.yml` (voir [ici](ManuelUtilisateurTerminaux.md)) vous devrez modifier sa syntaxe si voulez ajouter des fonctionnalités. Pour cela le module [yane_module_yaml](../yane_module_yaml) devra être modifié.

* yaneKillConsoles_modeName

Cette fonction permet de supprimer les ressources spécifique de votre module. En effet la fonction `yaneKillConsoles` du module [yane_module_console](../yane_module_console) kill tous les processus dont le pid est dans le fichier `.yane_${SESSION_ID}_module_consoles.pid`. C'est pourquoi je vous conseille d'écrire le plus de pids possible dans ce fichier. Pour les autres ressources, fichiers, etc. vous devrez les libérez dans cette fonction. Vous pouvez aussi choisir de ne rien faire.

## Ajout d'autres services
### Yane est modulaire, les services aussi.

Un service dans yane est un module qui implémente certaines fonctions définies dans [yane_module_services](../yane_module_services).
Du point de vue du réseau yane **il doit être considéré comme un hôte**. Cependant, contrairement à un hôte il est directement connecté à la machine hôte (votre machine) via une interface virtuelle.

### Rappel

La mise en place d'un host suit 2 étapes :
* Sa création : `yaneCreateHost_`
* Sa mise en service (boot) : `yaneBootHost_`

Étant donné que le service est un hôte, un peu spécial, il doit lui aussi suivre ces étapes. Pas de panique cependant ! Yane peut s'en occuper seul. En effet vous pouvez réutiliser les fonctions des modules déjà présent pour créer l'hôte.

### Comprendre par l'exemple

Imaginons que vous vouliez développer un nouveau module de service destiné à fournir une source de trafic pour votre réseau yane. Vous choisissez comme source de trafic un système Ubuntu qui envoie des e-mails à un débit que vous avez spécifié dans un fichier de configuration. Pour créer votre nouveau module vous aller devoir suivre plusieurs étapes :

### 1. Choisir un `mode` de virtualisation :
  * **docker** (à privilégier pour les services) :

    Vous devrez fournir une image Docker avec le client mail de votre choix, plus tous les logiciels dont vous pourriez avoir besoin.
    Une fois l'image construite stable vous pouvez la placer dans le répertoire [`YANE_ROOT_DIR/images`](../images).  
  * netns

    Probablement pas le plus simple car votre service sera directement lancé dans votre machine (partage une partie des mêmes fichiers) ce qui rend l'exercice potentiellement dangereux pour celle-ci.
  * ...

  Pour la suite on va supposer que vous avez choisi Docker.

### 2. Rédaction du nouveau module

  Le nouveau module doit être nommé de cette manière : `yane_module_<MODULE_NAME>` et placé dans le répertoire [`YANE_ROOT_DIR`](../). Ce qui pourrait donner dans notre exemple `yane_module_postfix` (à vous de trouver un nom explicite). Le nom du module doit correspondre au champ type dans le fichier `yane.yml` :
  ```Yaml
  services:
    name: postfixServer
    type: postfix
    ...
  ```
  Une fois le fichier créé celui-ci doit fournir 4 fonctions. Celles-ci seront automatiquement appelé par yane via le module [yane_module_services](../yane_module_services).

  Les 4 fonctions sont :

  * `yaneCreateService_<TYPE>`

  Cette fonction doit créer le service à la manière d'un host. En effet cette fonction doit faire appel aux fonctions `yaneCreateHost_<MODE>`. Ce qui donnera dans notre exemple : `yaneCreateHost_docker`.

  Créer un service à la manière d'un hôte va permettre la **création automatique des liens** entre votre réseau et le service par yane, mais aussi de boot automatiquement le service. Un autre objectif de cette fonction est de **charger les fichiers de configuration** fourni par l'utilisateur dans le service.

  **Important :**
  Pour que yane considère votre service comme un hôte de son réseau vous devez, en plus de le créer via une fonction `yaneCreateHost_<TYPE>`, complétez les variables `hostName`, `hostMode` et `hostImage` (voir le module [yane_module_dnsmasq](../yane_module_dnsmasq)). Ici :
  ```Bash
  hostName[$serviceName]=$serviceName
  hostMode[$serviceName]="docker"
  hostImage[$serviceName]="postfix"
  ```

  * `yaneShutdownService_<TYPE>`

  Cette fonction sera appelée lors de l'arrêt de la session en cours.
  Dans cette fonction vous devrez faire appel aux fonctions `yaneShutdownHost_<MODE>`. Dans notre exemple : `yaneShutdownHost_docker`.
  Vous pouvez également stopper tous les processus lancés par/pour votre service.

  * `yaneDeleteService_<TYPE>`

  Cette fonction sera appelée lors de l'arrêt de la session en cours. Elle doit permettre de supprimer toutes les ressources lancées par votre service. Elle doit donc faire appel aux fonctions `yaneDeleteHost_<MODE>`. Dans notre exemple on fera seulement appel à `yaneDeleteHost_docker`.

  * `yaneRunService_<TYPE>`

  Cette dernière fonction est appelé juste après le boot des hôtes donc de votre service. Elle peut donc vous servir à lancer certaines applications sur votre services ou bien à le configurer. Elle est donc à compléter selon vos besoin. Dans le cas de dnsmasq par exemple c'est dans cette fonction que le module relie la machine hôte et le service puis modifie le NAT du service pour donner accès à internet au réseau yane.

### Structure des services dans yane0

Pour illustrer la structure des services dans yane rien de mieux qu'un schéma :
![Les services dans yane.](services.png)