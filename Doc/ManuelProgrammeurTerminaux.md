# Les terminaux

Avant de vous lancer dans l'écriture d'un nouveaux mode de console pour yane je vous invite à lire le [tutoriel programmeur](TutorielProgrammeur.md).

## Yane est modulaire, les consoles aussi.

En effet pour construire un nouveaux mode de console vous devez comprendre que chaque mode de console est en réalité un sous module du module `yane_module_console`.

### Nommage du module

Par conséquent le nouveau mode sera principalement codé dans le fichier `yane_module_console_modeName`.

Par exemple :

* [yane_module_consoles_tmux](../yane_module_consoles_tmux)
* [yane_module_consoles_xterm](../yane_module_consoles_xterm)

### Structure du sous-module

Chaque module doit contenir au minimum 2 fonctions :
* yaneOpenConsoleWindow_modeName

Cette fonction est appelé pour chaque terminal. Ainsi si vous souhaiter ouvrir 3 terminaux pour 3 machines différentes cette fonction sera appelé 3 fois.

Son rôle est donc d'ouvrir un terminal (xterm, gnome-terminal, konsole, terminator, ...) et d'y lancer la commande permettant d'ouvrir un shell sur la machine. Celle-ci est obtenu grâce à la fonction `yaneConsoleCmd_hostMode` des modules de virtualisations.

**Important :**  Le module [yane_module_console](../yane_module_console) ne doit pas être modifié car c'est lui qui appellera ces 2 fonctions.

Dans le cas de terminaux plus complexe comme tmux ou terminator qui permettent l'ouverture de plusieurs terminaux en une seule fenêtre vous devrez probablement complexifier votre fonction. En effet vous devrez non seulement ouvrir un nouveau terminal mais aussi l'ouvrir au bon endroit. Le module [yane_module_consoles_tmux](yane_module_consoles_tmux) en est un exemple. Si vous avez besoin de définir des variables global vous devrez alors les déclarer dans le fichier [yane](../yane).

Comme l'organisation des terminaux/consoles est définie dans le fichier `yane.yml` (voir [ici](ManuelUtilisateurTerminaux.md)) vous devrez modifier sa syntaxe si voulez ajouter des fonctionnalités. Pour cela le module [yane_module_yaml](../yane_module_yaml) devra être modifier.

* yaneKillConsoles_modeName

Cette fonction permet de supprimer les ressources spécifique de votre module. En effet la fonction `yaneKillConsoles` du module [yane_module_console](../yane_module_console) kill tous les processus dont le pid est dans le fichier `.yane_${SESSION_ID}_module_consoles.pid`. C'est pour quoi je vous conseil d'écrire le plus de pids possible dans ce fichier. Pour les autres ressources fichiers, etc. vous devrez les libérez dans cette fonction. Vous pouvez aussi choisir de ne rien faire.
