Une session est une instance de yane. Cela signifie qu'un réseau peut être émulé plusieurs fois en même temps. Chaque session est représentée par un indentifiant unique. Cet identifiant permet de différencier des hôtes qui auraient le même nom mais qui ne seraient pas dans la même session.
Grâce aux sessions vous pouvez travailler sur deux réseaux identiques mais y simuler deux utilisations différentes. Les sessions ont pour but de pouvoir confronter des modèles ou de simplement de parallèliser vos expériences. 

## Comment utiliser les sessions ?

Supposons le réseau suivant : [`yane.yml`](https://github.com/SylvainDaste/yane/blob/master/examples/tuto-1/yane.yml).
Lorsque que l'on lance yane avec la commande `# yane`, l'identifiant de session sera choisi par yane. Ce choix n'est pas aléatoire. C'est en réalité le Pid du processus résultant de la commande `# yane`. Cela impose par défaut l'unicité de l'identifiant.

Cependant pour diverses raisons (esthétiques, pratiques) vous pourriez avoir besoin de définir l'identifiant vous même. Cela est réalisable grâce à l'option `-s`. Par exemple`yane -s 1234` va créer une session avec 1234 comme identifiant. Attention vous devez fournir un identifiant unique !

L'option `-s` devrait toujours être présente si vous manipulez plusieurs sessions en parallèle.
Ainsi utiliser 10 fois de suite la simple commande `# yane` lancera 10 sessions du même réseau.

Nous souhaitons maintenant avoir accès à la console `host-a` de la session 1234. L'option `-c <HOST_NAME>` permet l'ouverture d'une console sur un hôte. Il nous suffit alors de la combiner avec l'option `-s <SESSION_ID>`: `# yane -s 1234 -c host-a`.

## Fonctionnement des sessions

L'identifiant de session est stocké dans la variable SESSION_ID. Cette variable est globale. Elle est donc accessible dans tous les modules, toutes les fonctions de yane. Cette variable est définie dans le fichier [yane](https://github.com/SylvainDaste/yane/blob/55d5fc0c7cc6bee119800693a1961c50378b9e3a/yane#L750-L785)