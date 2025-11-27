# Étape 1 : Nginx + PHP-FPM

# Nettoyage des anciens containers

docker stop http script 2>/dev/null
docker rm http script 2>/dev/null

# Création du réseau tp3-net

docker network create tp3-net 

# Création du répertoire src dans etape1 et ajout de index.php

cd etape1
mkdir src
# Ajouter manuellement index.php dans le dossier 

# Création du répertoire config et fichier default.conf
mkdir config
# Créer manuellement le fichier default.conf dans le dossier config
#Contenu du fichier :
 server {
    listen 80;
    server_name localhost;

    root /app;

    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        root           /app;
        fastcgi_pass   script:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}

# Lancement du container PHP-FPM
docker run -d --name script --network tp3-net -v $(pwd)/src:/app php:8.2-fpm

# Lancement du container Nginx
docker run -d --name http --network tp3-net -p 8080:80 \
  -v $(pwd)/src:/app \
  -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx


# Aller sur http://localhost:8080/ pour voir si tout fonctionne bien
