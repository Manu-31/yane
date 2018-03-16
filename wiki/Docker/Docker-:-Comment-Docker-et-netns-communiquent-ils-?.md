Dans cette partie nous allons relier deux machines par un lien virtuel :

* Une machine Docker
* Une machine netns (pout network namespace)

La difficulté est que l'on utilise 2 technologies différentes (docker et netns). Docker cache beaucoup de chose à l'utilisateur. Il n'est pas conçu pour communiquer avec autre chose que des Dockers. Nous allons donc devoir créer le lien entre les deux machines manuellement car Docker ne nous fourni pas les outils pour le faire (ce qui est parfaitement normal).

## 1 - Créer les deux machines :

Nous allons commencer par créer le netns pour la stationA :

		# ip netns add stationA

Cette commande va initialiser un namespace de type `net` nommé `stationA`. Celui-ci est représenté par un fichier `/var/run/netns/stationA`.

**Explications :**

Un namespace isole 1 seul type de ressource parmi 7 (pid, net, user, mnt, ...). Cela signifie qu'un processus appartenant au namespace X de type network ne partage pas les mêmes ressources réseaux que le processus à un autre netns Y. 
La commande `ip netns` créer un namespace de type network. Cela signifie que tous les processus appartenant à celui-ci auront leurs ressources relatives au réseaux isolées de tous les processus ne lui appartenant pas. Ainsi, les changements produits par ces processus seront invisibles pour les autres namespaces. Au contraire deux processus appartenant au même namspace auront leurs ressources partagées.

**Exemple :** Nous allons observer un processus pour voir à quel netns il appartient. Pour observer les namespaces d'un processus on peut lister le répertoire `/proc/<PID>/ns` :

		# ls -l /proc/1227/ns
		total 0
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 cgroup -> cgroup:[4026531835]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 ipc -> ipc:[4026531839]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 mnt -> mnt:[4026531840]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 net -> net:[4026531993]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 pid -> pid:[4026531836]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 15:03 pid_for_children -> pid:[4026531836]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 user -> user:[4026531837]
		lrwxrwxrwx 1 gdm gdm 0 janv. 29 11:01 uts -> uts:[4026531838]

On peut par exemple observer que le processus 1227 appartient au netns numéro 4026531993. Si l'on veut voir tous les namespaces actifs il existe la commande `lsns` :

		# lsns
			NS TYPE   NPROCS   PID USER             COMMAND
		4026531835 cgroup    231     1 root             /sbin/init splash
		4026531836 pid       231     1 root             /sbin/init splash
		4026531837 user      231     1 root             /sbin/init splash
		4026531838 uts       231     1 root             /sbin/init splash
		4026531839 ipc       231     1 root             /sbin/init splash
		4026531840 mnt       223     1 root             /sbin/init splash
		4026531861 mnt         1    19 root             kdevtmpfs
		4026531993 net       230     1 root             /sbin/init splash
		4026532217 mnt         1   253 root             /lib/systemd/systemd-udevd
		4026532237 mnt         1   668 root             /usr/sbin/NetworkManager --no-daemon
		4026532240 mnt         1 16467 systemd-resolve  /lib/systemd/systemd-resolved
		4026532244 mnt         1  3484 systemd-timesync /lib/systemd/systemd-timesyncd
		4026532362 net         1  1236 rtkit            /usr/lib/rtkit/rtkit-daemon
		4026532416 mnt         1  1236 rtkit            /usr/lib/rtkit/rtkit-daemon
		4026532473 mnt         1  1682 colord           /usr/lib/colord/colord
		4026532474 mnt         1  2315 root             /usr/lib/fwupd/fwupd		

**Question :** Pourquoi ne voit-on pas le netns `stationA` que l'on vient de créer ? En fait `lsns` ne liste que les namespaces actifs. Cela signifie qu'aucun processus n'utilise notre namespace. Pour le moment.

Créons maintenant la machine docker, stationB :

		docker create -it --network none --name stationB --hostname stationB --cap-add NET_ADMIN alpine:latest   

**Rappel :** le réseau auquel appartient ce container est `none`. Cela signifie que docker ne lui attribut aucune configuration réseau (pas de couche IP, MAC, ...). Pour plus d'informations sur cette commande je vous invite à consulter la documentation de Docker.

## 2 - Booter les machines

Les netns n'ont pas besoin d'être booté. En revanche pour Docker :

		# docker start stationB

## 3 - Configurer le lien entre les deux machines

On arrive à la partie la plus chaude ! On va procéder de la façon suivante :

* Créer le lien : cela revient à créer une paire d'interfaces virtuelles.

* Attribuer une interface à chaque machine.

* Configurer les deux interfaces pour chaque machines.

* Tester notre lien.

**Créer le lien :**

		# ip link add veth0 type veth peer name veth1

Les interfaces ethernet virtuels (veth) fonctionnent comme des liens bidirectionnel. Tout ce qui rentre dans veth0 ressort par veth1 et inversement. On peut observer nos interfaces :

		# ip link show            
		1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
		    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
		.....
		30: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
		    link/ether e6:3e:93:53:65:91 brd ff:ff:ff:ff:ff:ff
		31: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
		    link/ether ca:ae:b2:e6:c5:39 brd ff:ff:ff:ff:ff:ff

**Attribuer une interface à une machine :**
Nos interfaces créées sont actuellement sur la machine hôte. Il faut maintenant passer chaque interface à une machine. Pour cela la commande `ip link` nous permet de transférer une interface à un netns particulier. Pour la stationA c'est donc évident :

		# ip link set veth0 netns stationA

Si on observe nos interfaces :

		# ip link show
		.....
		30: veth1@if31: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
		    link/ether e6:3e:93:53:65:91 brd ff:ff:ff:ff:ff:ff link-netnsid 0

L'interface veth0 a disparue de l'hôte. On peut vérifier que le netns stationA l'a bien reçu :

		# ip netns exec stationA ip link show
		1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
		    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
		31: veth0@if30: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
		    link/ether ca:ae:b2:e6:c5:39 brd ff:ff:ff:ff:ff:ff link-netnsid 0


Pour la stationB c'est plus hardu car il faut retrouver le netns utilisé par le conteneur Docker et le donner à la commande `ip`. Or on sait le faire ! J'ai expliqué comment retrouver un namespace associé à son processus. Pour cela on va d'abord retrouver le PID du conteneur. Ce qui nous permettra d'accéder à ses namespaces et notamment son netns afin de lui donner l'interface veth1.

		# docker inspect --format='{{.State.Pid}}' stationB
		1234

__Rappel :__ Les namespaces d'un processus se trouve en `/proc/<PID>/ns/`.

La commande `ip` ne peut manipuler que les netns qu'elle a créés ou plus précisément : uniquement les netns se trouvant dans le répertoire `/var/run/netns/`. Comme le netns du conteneur ne se trouve pas dans ce répertoire on va y créer un lien pointant vers le netns du conteneur :

		# ln -s /proc/1234/ns/net /var/run/netns/stationB

On peut enfin déplacer l'interface veth1 vers notre docker :

		# ip link set veth1 netns stationB

**Configurer les deux interfaces de chaque machines :**

* Sur la stationA :

		# ip netns exec stationA ip addr add 192.168.12.78/24 dev veth0
		# ip netns exec stationA ip link set dev veth0 up

* Sur la stationB :

```
# ip netns exec stationB ip addr add 192.168.12.48/24 dev veth1
# ip netns exec stationB ip link set dev veth1 up
ou bien 
# docker exec stationB ip addr add 192.168.12.48/24 dev veth1
# docker exec stationB ip link set veth1 up
```

**Tester notre réseau :**

Si tout s'est bien déroulé on obtient depuis la stationB :

```
# ping 192.168.12.78
PING 192.168.12.78 (192.168.12.78): 56 data bytes
64 bytes from 192.168.12.78: seq=0 ttl=64 time=0.088 ms
64 bytes from 192.168.12.78: seq=1 ttl=64 time=0.067 ms
64 bytes from 192.168.12.78: seq=2 ttl=64 time=0.077 ms
^C
--- 192.168.12.78 ping statistics ---
7 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.067/0.072/0.088 ms
```

## 4 - Compléments :


Je vous conseille ces liens si vous voulez plus d'informations sur les namespaces :

* Le man namespaces est très complet.
* Le man ip netns
* La page [wikipédia](https://en.wikipedia.org/wiki/Linux_namespaces).