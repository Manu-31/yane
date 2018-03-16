yane utilise yaml pour décrire un réseau. La syntaxe est donc simple
et lisible. Le but de ce document est de la décrire

## Description générale

   On décrit un réseau avec les lignes suivantes :

```yaml
network :
  name: toto
  version: 1.0
```

   A priori c'est clair :-)

## Les hôtes

La liste des hôtes est introduite par la ligne suivante

```yaml
  hosts :
```

Puis chaque hôte est défini par une entrée telle que :

```yaml
    -
      name: m1
      mode: netns
      image: default
      files: as1/etc:/etc
```

   Les deux premiers champs sont obligatoires : le champ name donne bien sûr le nom de l'hôte, le mode précise l'outil de virtualisation qui est utilisé.

   Le champ image n'est valable que pour les docker (`mode:` docker implique `image:`). Il permet de préciser une variante du système. Une image par défaut peut être utilisée avec `image: default` (image Alpine).

   Le champ files permet de définir un ensemble de fichiers et/ou de répertoires qui seront copiés dans l'hôte avant son démarrage.

## Les liens

   Dans un réseau, des hôtes, c'est bien, mais avec des liens, c'est mieux ! Ils sont définis avec la syntaxe suivante

```yaml
  links :
```

   Puis chaque lien est décrit ainsi :

```yaml
    - host-a:v0:192.168.10.10/24!host-b:v0:192.168.10.4/24
```

   Avec la syntaxe suivante : sh:si[:sa]!dh:di[:da] où

- sh et dh sont les noms des hôtes (ou ponts) source et destination, respectivement ;
- si et di sont les interfaces de sh et dh, respectivement, à relier ;
- sa et da sont les adresses IPv4 à attribuer à si et di, respectivement.


   Les adresses sont facultatives.

   Notons que les liens peuvent également être décrits dans les ponts (voir la description des ponts pour cela)

## Les ponts

   Un pont permet de relier plusieurs interfaces. Ils sont mis en
oeuvre au travers des outils Linux de gestion des ponts. On pourra
donc utiliser toutes les fonctionnalités liées à ces outils.

   Un pont est décrit de la façon suivante

```yaml
  bridges :
    -
      name: jeff
      interfaces: host-a:v0:192.168.1.1/24!host-b:v0:192.168.1.2/24!host-c:v0:192.168.1.3/24
```

   La variable name est évidemment le nom du pont.

   interfaces permet de lister les hôtes reliées au pont. Les
interfaces correspondantes sur le pont sont créées
automatiquement. Cette variable est composée d'une liste, séparée par
des ! d'interfaces sous la forme h:i[:a] (avec la même syntaxe qu'une
variable de type link).

## Les consoles

Certaines de vos simulations peuvent atteindre plusieurs dizaines de machines. Par conséquent ouvrir 30 xterm différents peut être très fatiguant. Yane vous offre plusieurs possibilités pour afficher vos machines grâce à la syntaxe du fichier yane.yml.

### Syntaxe

Dans le fichier `yane.yml` vous pouvez décrire la vue que vous désirez de façon précise pour chaque hôte grace à la balise `consoles` :
```yaml
consoles:
  - all
```
Cette syntaxe permet d'obtenir un terminal pour chaque machine.
```Yaml
consoles:
  -
    host: __HOST-NAME__
    mode: xterm
```
Grâce au mode `xterm` vous pouvez choisir d'afficher qu'un nombre limité de terminaux.
```Yaml
consoles:
  -
    host: __HOST-NAME__
    mode: tmux
    session: __NAME__

```
Avec le mode `tmux` vous pouvez choisir de regrouper certain terminaux en session.

### host
Cette balise doit être suivi du nom d'un hôte décrit sous la balise `hosts`. Si ce nom ne correspond aucun hôte votre terminal ne s'affichera pas.

### mode
Cette balise doit être suivi du nom d'un mode de console. Voici une liste exhaustive :
```
tmux
xterm
```
Vous pouvez rajouter des modes de consoles pour cela voir la [doc programmeur](ManuelProgrammmaurTerminaux.md) sur les consoles.

### session
Cette balise n'est pertinente que pour les consoles de type `tmux`. En effet `tmux` utilise la notion de session pour regrouper différent panneaux. Vous pouvez grâce à cette balise définir des groupes de terminaux. Et ainsi trier vos terminaux pour un meilleur lisibilité.

**Par exemple :** vous pouvez réunir sous une même session `tmux` toutes les consoles des routeurs de votre réseau et sur une autre session toutes les machines d'extrémités. Pour cela il vous suffit de donner le même nom de session aux hôtes concernés.

### -all
Pour obtenir rapidement un terminal pour chaque machine vous pouvez utiliser le flag `all`. Par défaut yane va ouvrir une console `xterm` pour chaque hôte :
![flag -all](./consoles-all.png)


### Exemples

* 2 sessions tmux : `routers` et `users` :
```Yaml
consoles:
  -
    host: r1
    mode: tmux
    session: routers
  -
    host: r2
    mode: tmux
    session: routers
  -
    host: a
    mode: tmux
    session: users
  -
    host: b
    mode: tmux
    session: users
```

* vous pouvez mixer `xterm` et `tmux` :
```Yaml
consoles:
  -
    host: r1
    mode: xterm
  -
    host: r2
    mode: xterm
  -
    host: a
    mode: tmux
  -
    host: b
    mode: tmux
    session: users
```

* Un bon exemple de l'utilisation du mode tmux est l'exemple ospf-1.

### Pour aller plus loin

Il existe actuellement 2 modes de consoles : `tmux` et `xterm`. Vous pouvez obtenir plus d'aide sur le fonctionnement de ces programmes : [tmux](https://tmux.github.io), [xterm](https://wiki.archlinux.org/index.php/Xterm).

Si vous voulez ajouter d'autres modes de console je vous invite à regarder le [manuel console programmeur](ManuelProgrammmaurTerminaux.md).

## Les services
Un exemple d'utilisation de services peut être observé [ici](../examples/dnsmasq-1).
Dans yane les services permettent de fournir internet, dns, dhcp, aux différentes machines.
Dans sa version actuelle yane ne fourni qu'un seul type de services : `dnsmasq`. Celui-ci est cependant capable de fournir dns et dhcp à votre réseau yane.
Pour ajouter un service à votre réseau vous devez spécifier dans votre fichier `yane.yml` plusieurs paramètres (tous obligatoires) :
* name

  permet de donner un nom à votre service. Par exemple :
  ```Yaml
  name: my_dnsmasq_server
  ```

* type

  désigne le nom d'un module service. Pour le moment il n'existe que le module `dnsmasq`.
  Par exemple :
  ```Yaml
  type: dnsmasq
  ```

* config

  Votre service aura probablement besoin de fichiers de configuration. À vous de les fournir selon votre besoin puis d'indiquer leurs emplacements via ce paramètre.
  La syntaxe est la suivante :
  ```Yaml
  config: <src>!<dest>
  ```

Maintenant que votre service est spécifié vous devez encore paramétrer ses différentes connexions avec votre réseau yane.
Yane permet de relier vos machines à votre service uniquement via un bridge.
Cela vous oblige à fournir au moins un bridge pour vos services.

### Informations complémentaires

Quel que soit le service ajouté à votre réseau celui-ci agira comme une passerelle sur les hôtes relié à votre serveur. Celui-ci sera alors directement relié à votre machine et donc potentiellement à internet. Cette fonctionnalité va donc altérer vos paramètres `nat`.

**Important :**
Vous devez fournir une adresse IP au service si vous voulez que celui fonctionne :
```Yaml
bridges:
  interfaces: dhcpserver:v0:192.168.5.1/24! ...
```

### Exemple de syntaxe

```Yaml
services:
  -
    name: dhcpserver
    type: dnsmasq
    config: ./dnsmasq.conf!/etc/dnsmasq.conf

bridges:
  -
    name: br-int
    interfaces: m1:eth1!m2:eth1!m3:eth1!m4:eth1!r1:eth4!dhcpserver:v0:192.168.5.1/24


```