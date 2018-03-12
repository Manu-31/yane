# Les services
Un exemple d'utilisation de services peut être observé [ici](../examples/dnsmasq-1).
Dans yane les services permettent de fournir internet, dns, dhcp, aux différentes machines.
Dans sa version actuelle yane ne fourni qu'un seul type de service : `dnsmasq`. Celui-ci est cependant capable de fournir dns et dhcp à votre réseau yane.
Pour ajouter un service à votre réseau vous devez spécifier dans votre fichier `yane.yml` plusieurs paramètres (tous obligatoire) :
* name

  permet de donner un nom à votre service. Par exemple :
  ```Yaml
  name: my_dnsmasq_server
  ```

* type

  Les services dans yane désigne le nom d'un module service. Pour le moment il n'existe que le module `dnsmasq`.
  Par exemple :
  ```Yaml
  type: dnsmasq
  ```

* config

  Votre service aura probablement besoin de fichiers de configuration. A vous de les fournir selon votre besoin puis d'indiquer leur emplacement via ce paramètre.
  La syntaxe est la suivante :
  ```Yaml
  config: <src>!<dest>
  ```

Maintenant que votre service est spécifié vous devez encore paramétrer ses différentes connexions avec votre réseau yane.
Yane permet de relier vos machines à votre service uniquement via un bridge.
Cela vous oblige à fournir au moins un bridge pour vos services.

## Informations complémentaire

Quelque soit le service ajouté à votre réseau celui-ci agira comme une passerelle sur les hôtes relié à votre serveur. Celui-ci sera alors directement relié à votre machine et donc potentiellement à internet. Cette fonctionnalité va donc altérer vos paramètres `nat`.

**Important :**
Vous devez fournir une adresse IP au service si vous voulez que celui fonctionne :
```Yaml
bridges:
  interfaces: dhcpserver:v0:192.168.5.1/24! ...
```

## Exemple de syntaxe

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
