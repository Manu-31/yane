# Tutoriel du programmeur yane ;-)

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

La liste des sessions est fournie par l'option ` -l`.

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
confusions. De ce fait, le `nom` décrit dans les fonctions ci dessous
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
