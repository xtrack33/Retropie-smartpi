#!/bin/bash

function add_share_samba() {
    local name="$1"
    local path="$2"

    if [[ -z "$name" || -z "$path" ]]; then
        echo "Nom ou chemin du partage manquant."
        return 1
    fi

    # Supprimer le partage s'il existe déjà
    sed -i "/^\[$name\]/,/^force user/d" /etc/samba/smb.conf

    # Ajouter le partage
    cat >> /etc/samba/smb.conf << _EOF_
[$name]
comment = $name
path = "$path"
writeable = yes
guest ok = yes
create mask = 0777
directory mask = 0777
force user = pi
force group = pi
_EOF_

    # Modifier les permissions du dossier partagé
    chmod -R 777 "$path"
}

# Chemin vers les répertoires RetroPie
romdir="/home/pi/RetroPie/roms/"
biosdir="/home/pi/RetroPie/BIOS/"

# Ajouter les partages Samba en lecture-écriture pour tout le monde
add_share_samba "roms" "$romdir"
add_share_samba "bios" "$biosdir"

# Redémarrer le service Samba
systemctl restart smbd.service

echo "Partages Samba configurés en lecture-écriture pour tout le monde."

# Créer un service pour appliquer automatiquement les configurations de Samba au démarrage
cat > /etc/systemd/system/samba-config.service << EOF
[Unit]
Description=Configuration Samba pour l'accès invité
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c '/usr/bin/bash -c "$0"'

[Install]
WantedBy=multi-user.target
EOF

# Activer le service au démarrage
systemctl enable samba-config.service

echo "Service de configuration Samba créé et activé."
