
# launch.sh - Lancer l'étape 3 avec Docker Compose
# Pour éviter les conflits, j'ai supprimer tous les containers de l'étape 2


# 1. Supprimer d'anciens containers si présents

docker stop http script data 
docker rm http script data 


# 2. Après je suis allé dans le dossier étape 3 où j'ai créer le fichier docker-compose.yml et j'ai lancer les services avec Docker Compose

cd etape3
docker-compose up -d


# 3. Vérifier l'état des containers et que tout marche bien

docker ps
http://localhost:8080/index.php  
http://localhost:8080/test.php
