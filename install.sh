#!/bin/bash

# Updating the package list and upgrading the existing packages
echo "Updating and upgrading the system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Installing necessary dependencies
echo "Installing dependencies..."
sudo apt-get install git dialog unzip xmlstarlet libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-net-2.0-0 libsdl2-ttf-2.0-0 libsdl2-dev libusb-1.0-0-dev libavformat-dev libavdevice-dev pulseaudio samba xorg openbox alsa-utils menu libglib2.0-bin python3-xdg at-spi2-core dbus-x11 xmlstarlet joystick triggerhappy -y && echo "Dependencies installed successfully." || echo "Failed to install dependencies."

# Making the installation scripts executable
#echo "Making installation scripts executable..."
#sudo chmod +x retropie_setup.sh SambaRetropie.sh retropie_packages.sh autostartES.sh

# Function to execute a script with arguments and check its success
execute_script() {
    script=$1
    shift # Remove the first argument, the script name, and keep the rest as parameters for the script
    echo "Executing $script with arguments $@..."
    if sudo ./$script "$@"; then
        echo "$script executed successfully with arguments $@."
    else
        echo "Failed to execute $script with arguments $@."
        #exit 1
    fi
}

# Executing installation and setup scripts with parameters
execute_script retropie_packages.sh setup basic_install
execute_script retropie_packages.sh bluetooth depends
execute_script retropie_packages.sh usbromservice
execute_script retropie_packages.sh samba depends
execute_script retropie_packages.sh samba install_shares
execute_script autostartES.sh

# Changing permissions of the RetroPie directory
echo "Changing permissions of the RetroPie directory..."
if sudo chmod 777 -R /opt/retropie/; then
    echo "Permissions changed successfully."
else
    echo "Failed to change permissions."
fi

# Ensuring the autostart script is executable
echo "Ensuring the autostart script is executable..."
if sudo chmod +x /opt/retropie/configs/all/autostart.sh; then
    echo "Autostart script is now executable."
else
    echo "Failed to make autostart script executable."
fi

echo "Modifying /etc/sudoers to allow sudo group execute commands without a password..."
if sudo sed -i 's/^%sudo\s*ALL=(ALL:ALL)\s*ALL$/%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers; then
    echo "Successfully modified /etc/sudoers."
else
    echo "Failed to modify /etc/sudoers. Please check permissions and try again."
    #exit 1
fi

echo "Retropie Installation and configuration completed."
