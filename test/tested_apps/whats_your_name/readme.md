# Exemple d'une petite application testée

## Description

`whats_your_name` demande à l'utilisateur son prénom et répond en lui disant bonjour.

## Test de cette application


Si [l'alias de lancement a été créé](#create-alias), faire simplement :

* ouvrir une fenêtre de Terminal à ce document,
* jouer `clitests`

Sinon, jouer :

* ouvrir un terminal à ce dossier,
* jouer la commande `path/to/NewCliTest/run_tests` (ou `path/to/...` est le chemin d'accès au script)

<a name="create-alias"></a>

## Création de l'alias de lancement

L'alias de lancement permet de lancer les tests simplement avec la commande `clitests`.

Dans une fenêtre de Terminal, taper :

~~~bash
ln -s /path/to/NewCliTest/run_tests /usr/local/bin/clitests
~~~
