# TP3 Docker – Conteneurisation Web 

Ce fichier décrit les différentes étapes du TP, les commandes utilisées et les tests de validité.


## Étape 0 – Préparation

**Objectif :** Préparer l'environnement Docker et organiser les fichiers pour le TP.

**Actions réalisées :**
- Suppression des containers existants pour éviter tout conflit :
```powershell
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)


- Création du répertoire principal docker-tp3 :

cd  C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\
mkdir  C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3
cd docker-tp3

- Création de sous-dossiers pour chaque étape (etape1, etape2, etape3) et organisation des fichiers (src, config, sql, php)

mkdir etape0
mkdir etape1
mkdir etape2
mkdir etape3

- Création dun fichier launch.sh vide dans chaque étape pour y mettre les commandes spécifiques à chaque étape

- Initialisation dun repository Git pour versionner le projet

git init
git add .
git commit -m "Initialisation du repository etape 0"


## Étape 1 – Préparation