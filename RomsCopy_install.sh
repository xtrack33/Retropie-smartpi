#!/bin/bash

# Chemin vers le fichier de service systemd
SERVICE_FILE=/etc/systemd/system/romscopy.service

echo "Début de l'installation du service de copie des ROMs..."

# Vérifie si le script est exécuté avec les droits root
if [ "$(id -u)" != "0" ]; then
  echo "Erreur : Ce script doit être exécuté en tant que root." 1>&2
  exit 1
else
  echo "Exécution en tant que root confirmée."
fi

# Crée le fichier de service systemd pour RomsCopy.py
echo "Création du fichier de service systemd..."
cat > $SERVICE_FILE << EOF
[Unit]
Description=Copy ROMs Service
After=network.target

[Service]
Type=simple
User=pi
ExecStart=/usr/bin/python3 /home/pi/Retropie-smartpi/yumi-services/RomsCopy.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Vérifie que le fichier de service a bien été créé
if [ -f "$SERVICE_FILE" ]; then
    echo "Le fichier de service systemd a été créé avec succès."
else
    echo "Erreur : La création du fichier de service systemd a échoué."
    #exit 1
fi

# Recharge les unités systemd pour prendre en compte le nouveau fichier de service
echo "Rechargement des daemons systemd..."
systemctl daemon-reload

# Active le service pour qu'il démarre au boot
echo "Activation du service pour démarrage automatique..."
systemctl enable romscopy.service

# Démarre le service immédiatement
echo "Démarrage du service..."
systemctl start romscopy.service

# Vérifie que le service est actif et en cours d'exécution
if systemctl is-active --quiet romscopy.service; then
    echo "Le service de copie des ROMs a été installé et démarré avec succès."
else
    echo "Erreur : Le service n'a pas pu être démarré."
    #exit 1
fi
