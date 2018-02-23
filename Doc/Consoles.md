# Les consoles

## Syntaxe

Dans le fichier `yane.yml` vous pouvez décrire la vue que vous désirez de façon précise pour chaque hote grace à la balise `consoles` :
```yaml
consoles:
  - [all]
    host: <host_name>
    mode: <tmux | xterm>
    session: <NAME>
  -
    host: ....
```
## host
Cette balise doit être suivi du nom d'un hôte décrit sous la balise `hosts`. Si ce nom ne correspond  aucun hôte attendez vous a des erreurs.

## mode
Cette balise doit être suivi du nom d'un mode de console. Voici une liste exhaustive :
```
tmux
xterm
```

## session
Cette balise n'est pertinente que pour les consoles de type `tmux`. En effet `tmux` utilise la notion de session pour regrouper différent panneaux. Vous pouvez grâce à cette balise définir des groupes consoles.

**Par exemple :** vous pouvez réunir sous une même session `tmux` toutes les consoles des routeurs de votre réseau et sur une autre session toutes les machines d'extrémités. Pour cela il vous suffit de donner le même nom de session aux hôtes concernés.

## -all
Décrire le choix pour chaque hôte peut être fastidieux. Pour remédier à cela vous pouvez utiliser le flag `all` :
```yaml
consoles:
  - all
```
Par défaut yane va ouvrir une console `xterm` pour chaque hôte :
![flag -all](./consoles-all.png)


## Exemples

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

## Pour aller plus loin

Il existe actuellement 2 modes de consoles : `tmux` et `xterm`. Vous pouvez obtenir plus d'aide sur le fonctionnement de ces programmes : [tmux](https://tmux.github.io), [xterm](https://wiki.archlinux.org/index.php/Xterm).

Si vous voulez ajouter d'autre mode de console je vous invite à regarder le manuel console programmeur
