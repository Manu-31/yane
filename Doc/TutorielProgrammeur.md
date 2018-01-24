# Tutoriel du programmeur yane ;-)

## Comment fonctionne yane ?

yane est à l'heure actuelle simplement composé de quelques scripts en
bash, ... Un jour on fera peut-être mieux, mais pour le moment, ça
suffit !

### Structure générale

### Les modules

Oui, yane est modulaire ! Lors du lancement du programme, la fonction
`yaneLoadModules` charge l'ensemble des modules disponibles.

Chaque module `toto` est matérialisé par un fichier `yane_module_toto`
dans le répertoire pointé par `YANE_ROOT_DIR`

## Ajout d'un outil de virtualisation

Un des objectifs de yane est d'intégrer des outils de virtualisation
divers et variés. Cette section décrit la structure actuelle de yane
de ce point de vue.



