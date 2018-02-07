# Yet Another Network Emulator !?

### Yes !

Usage
=====

* To run a session

```
$ yane
```

* Kill the session

```
$ yane -k
```

Configuration
=============

A yaml file describes the network :


General structure
-----------------

A real mess !

* Loading the network
  This is done by a specific function (see later)

* Booting the network
  Creation of the multiple parts of the network (hosts, bridges, links, ...)

* Sessions
  Multiple sessions can be run simultaneously. A list of active sessions can be seen by
```
$ yane -l
```

  A specific session can be killed with
```
$ yane -s id -k
```

   The -s id option is not needed if a single session is running


Configuration
-------------

   A function has to build the network (ie data structures describing the network). For this, it needs to build the following variables

   bridgeInterfaces is an array (indexed by bridge names) of BridgeInterface

Data structure syntax
---------------------

#### BridgeInterface

   ! separated list of interface list

**example :**
```
   host-a:v0!host-b:v0!host-c:v0
```

#### Point to point link

   `i1!i2`

where
   `i1` is one interface
   `i2` is another interface

#### Interface
```
   h:i[:A]
```
where
   `h` is the host
   `i` os the interface name within the host
   `a` is an IPv4 address

**example :**
```
host-a:v0:192.168.10.2/24
```
