# Les services

Dans yane les services permettent de fournir internet, dns, dhcp, aux différentes machines.
Dans sa version actuelle yane ne fourni qu'un seul type de service : `dnsmasq`. Celui-ci est cependant capable de fournir dns et dhcp à votre réseau yane.
Pour ajouter un service à votre réseau vous devez spécifier dans votre fichier `yane.yml` plusieur paramètres (tous obligatoire) : 
* name
`name` permet de donner un nom à votre service. Par exemple `my_dnsmasq_server`.
* type
Les services dans yane sont virtualisé avec docker (uniquement). Le type désigne en réalité le nom de l'image docker qui permet de lancer le service correpondant.
C'est pourquoi vous devez être certain que votre système possède une image docker capable de virtualiser votre service.
Par exemple pour un service dnsmasq le champ `type` sera `dnsmasq`. ;-)
* config
Votre service aura probablement besoin de fichiers de configuration. A vous de les fournir selon votre besoin puis d'indiquer leur emplacement via ce paramètre.

Maintenant que votre service est spécifié vous devez encore paramétrer ses différente connexions avec votre réseau yane. 
Yane permet de relier vos machines à votre service uniquement via un bridge (pas de simple liens).
Cela vous oblige à fournir au moin un bridge pour vos services. 
## Exemple de syntaxe

```Yaml
services:
  -
    name: dhcpserver
    type: dnsmasq
    config: ./dnsmasq.conf

bridges:
  -
    name: br-internet

```
