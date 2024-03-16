#!/usr/bin/env bash

mode="es"
user=pi
script="/opt/retropie/configs/all/autostart.sh"
mkdir -p "/home/pi/.config/autostart"
ln -sf "/usr/local/share/applications/retropie.desktop" "/home/pi/.config/autostart/"

# delete old startup script
rm -f /etc/profile.d/10-emulationstation.sh

cat >/etc/profile.d/10-retropie.sh <<_EOF_
# launch our autostart apps (if we are on the correct tty and not in X)
if [ "\`tty\`" = "/dev/tty1" ] && [ -z "\$DISPLAY" ] && [ "\$USER" = "$user" ]; then
    bash "$script"
fi
_EOF_

touch "$script"
# delete any previous entries for emulationstation / kodi in autostart.sh
sed -i '/#auto/d' "$script"
# make sure there is a newline
sed -i '$a\' "$script"
echo "emulationstation #auto" >>"$script"
chown $user:$user "$script"


