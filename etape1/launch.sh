#!/bin/bash
# Étape 1 : Nginx + PHP-FPM

echo "==> Nettoyage des anciens containers"
docker stop http script 2>/dev/null
docker rm http script 2>/dev/null

echo "==> Création du réseau tp3-net"
docker network create tp3-net 2>/dev/null || echo "Le réseau existe déjà"

echo "==> Création du répertoire src et fichier index.php"
mkdir -p src
cat > src/index.php << 'EOF'
<?php
phpinfo();
?>
EOF

echo "==> Création du répertoire config et fichier default.conf"
mkdir -p config
cat > config/default.conf << 'EOF'
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
EOF

echo "==> Lancement du container PHP-FPM"
docker run -d --name script --network tp3-net -v $(pwd)/src:/app php:8.2-fpm

echo "==> Lancement du container Nginx"
docker run -d --name http --network tp3-net -p 8080:80 \
  -v $(pwd)/src:/app \
  -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx

echo "==> Étape 1 terminée !"
echo "Visitez http://localhost:8080/ pour voir phpinfo()"
