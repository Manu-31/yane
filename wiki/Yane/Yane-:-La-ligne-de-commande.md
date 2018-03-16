La ligne de commande de yane a plusieurs objectifs qui sont : lancer une session, stopper une session, lister les sessions, et enfin donner accès aux consoles et/ou terminaux d'une session.

**Remarques :**
* Pour obtenir une aide concise vous pouvez utiliser l'option `-h` : 
   ```
   # yane -h
   ```
   Vous obtiendrez un message avec, notamment, la version de yane, les modules chargés, les options possibles et leurs    syntaxes.

* Yane doit impérativement être lancé avec les droits "root".

## Syntaxe

```
# yane [-f <cfg>] [-s <id>] [-c] [-v] [-w] [-k]  [-l]
```
`cfg` : fichier de configuration 

`id` : id/numéro de session

## Options

### Lister les sessions
Pour obtenir tous les id/numéros sessions en cours d'utilisation :  
```
# yane -l 
```
### Lancer une session

En supposant que votre répertoire courant possède un fichier yane.yml vous pouvez lancer une session avec :
```
# yane
```
Cela lancera une session dont l' id sera choisi par yane.

Pour lancer une session avec un id précis :  
```
# yane -s <SESSION_ID>
```
Pour afficher les logs lors du lancement de yane : 
```
# yane -v
``` 
### Arrêter une session

Pour stopper la seule session en cours : 
```
# yane -k
```
Pour stopper une session à partir de son id : 
```
# yane -s <SESSION_ID> -k
```
Pour afficher les logs lors de l'arrêt d'une session :
``` 
# yane -v -k 
# yane -v -s <SESSION_ID> -k
```
### Attacher un hôte

On suppose qu'il existe une unique session. Pour attacher un hôte au terminal courant : 
```
# yane -c <HOST_NAME>
```
Dans le cas ou il y a plusieurs sessions :
```
# yane -s <SESSION-ID> -c <HOST_NAME> 
```
