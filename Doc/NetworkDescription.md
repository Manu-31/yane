# Description d'un réseau

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

Puis chaque hôte est défini par une entrée  telle que :

```yaml
    -
      name: m1
      mode: namespace
      image: default
      files: as1/etc:/etc
```

   Les deux premiers champs sont obligatoires : le champ name donne bien sûr le nom de l'hôte, le mode précise l'outil de virtualisation qui est utilisé.

   Le champ image (facultatif) permet de préciser une variante du système. Chaque mode définit une image par défaut, qui sera utilisée si ce champ n'est pas défini.

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

- sh et dh sont les noms des hôtes source et destination, respectivement ;
- si et di sont les interfaces de sh et dh, respectivement, à relier ;
- sa et da sont les adresses IPv4 à attribuer à si et di, respectivement.


   Les adresses sont facultatives.
   
## Les ponts

## Les consoles
