Première utilisation de yane
============================


Dans ce tutoriel nous allons émuler le réseau suivant :

host-A	=============	host-B
Celui-ci est composé de 2 hôtes (A et B) reliés par un simple lien.

Vous pouvez récupérez le fichier yane.yml dans examples/basic/yane.yml


1 - Créer le réseau
-----------------
Pour spécifier notre réseau à yane, on utilise YAML.
Créons le fichier yane.yml dans lequel on entre les lignes suivantes :
```yaml
network:
  name: basic
  version: 1.0
  hosts:
    -
      name: host-a
      mode: namespace
    -  
      name: host-b
      mode: namespace
```
Expliquons un peu ! Tout d'abord le réseau doit avoir un nom et une version. Ensuite on défini nos hôtes par un nom et un mode dans la balise hosts, vous pouvez spécifier autant d'hôte que vous le voulez. Le `mode` fais référence à la technique de virtualisation utilisé pour cet hôte. Ici on a pris `namespace`, mon on aurais très bien pu prendre `docker`, etc...

**Attention**: le YAML n'utilise aucune tabulation pour son indentation.

2 - Créer le lien
---------------

Un lien est spécifié par de la façon suivante :`if1!if2`. Cela signifie qu'un lien relie deux interfaces (`ifx`). Les interfaces sont de la forme : `h:i[:a]`. *h* correspond au nom du premier hôte, *i* au nom de l'interface de cet hôte. Enfin on peut ajouter à chaque interface une adresse IPv4 `a`.
On peut alors ajouter à notre fichier les deux lignes suivantes :
```yaml
links:
  - host-a:v0:192.168.1.1/24!host-b:v0:192.168.1.2/24
```
3 - Lancez la simulation
----------------------

Afin d'interagir avec notre réseau. On peut afficher les consoles de chaque hôte en ajoutant ces lignes à yane.yml :
```yaml
consoles:
  - all
```
Si l'on souhaite seulement certaines consoles il suffit de les spécifier de la façon suivante :
```yaml
consoles:
  - host-A host-B
```
Enfin on peut lancez la simulation :
`# yane`

Si on préfère on peut utiliser le mode _verbose_ qui ajoute plus de description :
`# yane -v`

3-Tester notre simulation
-------------------------

Basculez sur la console de `host-a`. Nous allons essayer d'écouter notre interface :

	# tcpdump

Sur la console de `host-b`. Essayer d'envoyer des données à `host-a`, on peut par exemple faire un ping :

	# ping 192.168.1.1

Si tous s'est déroulé comme prévu vous devriez obtenir sur `host-a` :

	17:19:23.300866 IP 192.168.1.1 > r2d2: ICMP echo request, id 8751, seq 1, length 64
	17:19:23.300887 IP r2d2 > 192.168.1.1: ICMP echo reply, id 8751, seq 1, length 64
	17:19:24.337999 IP 192.168.1.1 > r2d2: ICMP echo request, id 8751, seq 2, length 64
	17:19:24.338028 IP r2d2 > 192.168.1.1: ICMP echo reply, id 8751, seq 2, length 64
	17:19:25.377837 IP 192.168.1.1 > r2d2: ICMP echo request, id 8751, seq 3, length 64
	17:19:25.377853 IP r2d2 > 192.168.1.1: ICMP echo reply, id 8751, seq 3, length 64
	17:19:26.417885 IP 192.168.1.1 > r2d2: ICMP echo request, id 8751, seq 4, length 64
	17:19:26.417924 IP r2d2 > 192.168.1.1: ICMP echo reply, id 8751, seq 4, length 64
	17:19:27.457972 IP 192.168.1.1 > r2d2: ICMP echo request, id 8751, seq 5, length 64
	17:19:27.458001 IP r2d2 > 192.168.1.1: ICMP echo reply, id 8751, seq 5, length 64

Maintenant vous ce vous désirez c'est de pouvoir gardez traces de tous les échanges protocolaires qui se sont déroulé entre nos hôtes.
Pour cela _yane_ peut "sniffer" chaque interfaces.
Pour sniffer toutes les interfaces de notre réseau :
```yaml
dumpif:
  - all
```
Si vous relancer la simulation vous allez voir cette ligne apparaître :

```
wireshark -i /tmp/nssi/16977/host-a/v0 -i /tmp/nssi/16977/host-b/v0 `
```
Ce qui signifie que vous pouvez lancer wireshark pour observer le trafic de vos interfaces.

4-Stopper la simulation
-----------------------

On peut arrêter la simulation en tapant (uniquement s'il n'y qu'une seule session) : `# yane -k`

Sinon il faut récupérer l'id de la session que l'on désire stopper : `# yane -l` puis `# yane -s <ID> -k`
