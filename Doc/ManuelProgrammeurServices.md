# Les services

Avant tout je vous invite à lire le tutoriel programeur pour yane [ici](./TutorielProgrammeur.md).

## Yane est modulaire, les services aussi.

Un service dans yane est un module qui implémente certaines fonctions définie dans [yane_module_services](../yane_module_services).

### Nommage du module

Votre module doit être nommé de la façon suivante : `yane_module_<TYPE>` où `TYPE` correspond au type de votre service.

### Structure du module

Le module doit fournir 4 fonctions :

* `yaneCreateService_<TYPE>`
  Cette fonction doit créer le service à la manière d'un host. En effet je vous conseil de créer un service en utilisant les fonctions `createHost_<MODE>`. Créer un service à la manière d'un hôte va permettre la création automatique des liens entre votre réseau et le service par yane.
* `yaneShutdownService_<TYPE>`
* `yaneDeleteService_<TYPE>`
* `yaneConnectService_<TYPE>`
