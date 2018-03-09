# Les services


## Syntaxe

```Yaml
services:
  -
    name: dhcpserver
    type: dnsmasq
    config: dnsmasq.conf
    option: -v -t

bridges:
  -
    name: br-internet

```
