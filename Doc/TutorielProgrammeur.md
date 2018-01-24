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

## Ajout d'un outil de virtualisation

Un des objectifs de yane est d'intégrer des outils de virtualisation
divers et variés. Cette section décrit la structure actuelle de yane
de ce point de vue.

Un outil de virtualisation est défini par le biais d'un module, tel
que décrit ci-dessus. Il doit implanter un certain nombre de
fonctions, listées ci-dessous en prenant comme base le nom de module
`toto`. Les fonctions suivantes doivent donc être implantées en bash
dans le fichier `$YANE_ROOT_DIR/yane_module_toto`

### Création d'un hôte

La fonction suivante doit créer une instance de machine virtuelle.

```createHost_toto nom variante```



