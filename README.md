# Yet Another Network Emulator !?

Yes !

# Usage

## Basic usage

- Load and boot the network

   Creation of the multiple parts of the network (hosts, bridges,
links, ...)
```
$ yane [-v]
```
  `-v` to run yane in verbose mode.

- Sessions

   Multiple sessions can be run simultaneously. A list of active
sessions can be seen with :
```
$ yane -l
```
   A specific session can be killed with :
```
$ yane -s ID -k
```
  The `-s` id option is not needed if a single session is running


## Configuration and general structure

### Build your network :

  The network is described in a `yane.yml` file. This need to build different variables :

* host

  list of host name and mode

  ```yaml
  hosts:
    name: NAME
    mode: docker | netns
  ```

* BridgeInterface :

  bridgeInterfaces is an array (indexed by bridge names) of BridgeInterface

   ! separated list of interface list

   **Example :**
  ```yaml
  bridges:
    name: myBr
    mode: switched
    interfaces: host-a:v0!host-b:v0!host-c:v0
  ```
* Point to point link

   `i1!i2`

   where

   i1 is one interface

   i2 is another interface

   **Example :**
  ```yaml
  links:
    - host-a:v0:192.168.1.1/24!host-b:v0:192.168.1.2/24
  ```
* Interface

   As you can see above interfaces are always described with :
   ```
   h:i[:A]
   ```

  where

     `h` is the host

     `i` os the interface name within the host

     `a` is an IPv4 address

  **Example :**
  ```
  host-a:v0:192.168.10.2/24
  ```
