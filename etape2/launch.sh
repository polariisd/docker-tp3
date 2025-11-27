
# 1. Supprimer les anciens containers si ils existent

docker stop http script data 2>/dev/null
docker rm http script data 2>/dev/null


# 2. Créer le réseau Docker pour les containers

docker network create tp3-net 2>/dev/null


# 3. Construire l'image PHP-FPM avec mysqli
# Le Dockerfile est dans etape2/php

docker build -t php-mysqli etape2/php


# 4. Lancer le container MariaDB (DATA)
# Le dossier etape2/sql contient create.sql pour initialiser la base

docker run -d --name data --network tp3-net -e MARIADB_RANDOM_ROOT_PASSWORD=yes -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\sql:/docker-entrypoint-initdb.d" mariadb:10.11


# 5. Lancer le container PHP-FPM (SCRIPT)
# Les fichiers PHP (index.php, test.php) sont dans etape2/src

docker run -d --name script --network tp3-net -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\src:/app" php-mysqli


# 6. Lancer le container Nginx (HTTP)
# Nginx servira les fichiers PHP via le container SCRIPT

docker run -d --name http --network tp3-net -p 8080:80 -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\src:/app" -v "C:\Users\stylo\OneDrive\Documents\Cours\EFREI\B3\Conteneurisation\docker-tp3\etape2\config:/etc/nginx/conf.d:ro" nginx


# 7. Afficher les containers actifs

docker ps

# 8. Problème rencontré :

# Lors du lancement du container, j'ai rencontré une erreur car le fichier default.conf existait deja j'ai donc stopper et supprimer le container et j'ai ensuite relancé la commande, et le problème était résolu
