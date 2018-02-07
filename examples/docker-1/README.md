docker-1
========

Cet exemple est la représentation du réseau suivant :

![Réseau simple de machines docker](../../Doc/Docker/reseau_simple_1.jpg "Réseau simple de machine docker")

Toutes les machines sont des containers de docker. Pour plus d'info sur cet exemple : Doc/Docker

**Attention :** N'oubliez pas que yane n'ajoutera pas toutes les routes de votre réseau.

**Attention :** Dans la version 1.3 à la ligne 16
```yaml
image: ubuntu:v1.0
```
ne fonctionne que si vous avez build l'image ubuntu avec le dokerfile `/YANE/images/ubuntu/Dockerfile` avec `# docker build --tag ubuntu:v1.0 .`
