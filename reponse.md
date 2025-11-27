# TP Docker – Conteneurisation Web (docker-tp3)

## Étape 0 – Préparation

**Objectif :** Préparer l'environnement Docker et organiser les fichiers pour le TP.

**Actions réalisées :**

* Suppression des containers existants pour éviter tout conflit :

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

* Création du répertoire principal `docker-tp3` et des sous-dossiers pour chaque étape (`etape1`, `etape2`, `etape3`) :


mkdir C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3
cd C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3
mkdir etape1 etape2 etape3


* Création d’un fichier `launch.sh` dans chaque répertoire d’étape pour y mettre les commandes spécifiques à cette étape
* Initialisation du repository Git :

git init
git add .
git commit -m "Initialisation du repository etape 0"



## Étape 1 – Nginx + PHP-FPM

**L'objectif est de :** Lancer un serveur HTTP avec Nginx et un container PHP-FPM pour exécuter `index.php`.

**Commandes et actions réalisées :**

* Création d’un réseau Docker dédié :

docker network create tp3-net

* Lancement du container PHP-FPM (`script`) :

docker run -d --name script --network tp3-net `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape1\src:/app" `
  php:8.2-fpm

* Lancement du container Nginx (`http`) avec montage du fichier de configuration et du répertoire des fichiers PHP :

docker run -d --name http --network tp3-net -p 8080:80 `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape1\src:/app" `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape1\config:/etc/nginx/conf.d:ro" nginx

* Modification du fichier `default.conf` pour faire communiquer Nginx et PHP-FPM via `fastcgi_pass script:9000`.

**Test :**

* Dans le navigateur : `http://localhost:8080/index.php`.
* La page affiche la même chose que sur l'image du TP

## Étape 2 – Ajout de MariaDB + test CRUD

**L'objectif est d':** Ajouter un container MariaDB et tester des requêtes CRUD via PHP.

**Commandes et actions réalisées :**

* Construction de l’image PHP-FPM avec extension `mysqli` :

docker build -t php-mysqli C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\php

* Lancement du container MariaDB (`data`) :

docker run -d --name data --network tp3-net `
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\sql:/docker-entrypoint-initdb.d" `
  mariadb:10.11

* Lancement du container PHP-FPM (`script`) :

docker run -d --name script --network tp3-net `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\src:/app" `
  php-mysqli

* Lancement du container Nginx (`http`) :

docker run -d --name http --network tp3-net -p 8080:80 `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\src:/app" `
  -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\config:/etc/nginx/conf.d:ro" nginx


**Test :**

* `http://localhost:8080/index.php` → doit afficher la même chose que dans le TP.
* `http://localhost:8080/test.php` → compteur incrémenté à chaque rafraîchissement (j'ai eu un problème d'affichage).

**Automation :**

* `launch.sh` dans `etape2` contient toutes ces commandes avec des commentaires.

---

## Étape 3 – Docker Compose

**L'objectif est de :** Convertir l’étape 2 en configuration Docker Compose pour simplifier le lancement des services.

**Actions réalisées :**

* Création du fichier `etape3/docker-compose.yml` :

dans le fichier docker-compose.yml :
version: '3.8'

services:
  data:
    image: mariadb:10.11
    container_name: data
    environment:
      MARIADB_RANDOM_ROOT_PASSWORD: "yes"
    volumes:
      - ../etape2/sql:/docker-entrypoint-initdb.d
    networks:
      - tp3-net

  script:
    build:
      context: ../etape2/php
      dockerfile: Dockerfile
    container_name: script
    volumes:
      - ../etape2/src:/app
    networks:
      - tp3-net
    depends_on:
      - data

  http:
    image: nginx
    container_name: http
    ports:
      - "8080:80"
    volumes:
      - ../etape2/src:/app
      - ../etape2/config:/etc/nginx/conf.d:ro
    networks:
      - tp3-net
    depends_on:
      - script

networks:
  tp3-net:
    driver: bridge


* Création du `launch.sh` dans `etape3` pour lancer tous les services proprement :


**Test :**

* Lancer : docker-compose up -d
* Vérifier dans le navigateur :

  * http://localhost:8080/index.php 
  * http://localhost:8080/test.php



**Monter toutes le projet dans Github**

* Commandes :
    * Aller dans la racine du projet :
    cd C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3
    * Ajouter tous les fichiers :
    git add .
    * Créer un commit avec un message :
    git commit -m "Ajout complet du projet docker-tp3 avec toutes les étapes et fichiers reponse.md"
    * Ajouter le remote Github :
    git remote add origin https://github.com/polariisd/docker-tp3.git
    * Pousser la branche principale/maitre vers Github :
    git push -u origin master
    * Vérifier que tout le projet soit dans Github :

