import os
import shutil

# Chemin vers le dossier des ROMs sur la clé USB
usb_roms_path = '/media/usb0/roms'  # Ajustez ce chemin en fonction de votre configuration

# Chemin vers le dossier des ROMs sur le système RetroPie
retropie_roms_path = os.path.expanduser('~/RetroPie/roms')

# Liste des dossiers de consoles à vérifier et éventuellement créer
consoles = [
    'amstradcpc', 'atari2600', 'atari7800', 'atarilynx', 'coleco', 'fds', 'gb',
    'gbc', 'mame-libretro', 'megadrive', 'n64', 'nes', 'ngpc', 'psx', 'segacd',
    'snes', 'zxspectrum', 'arcade', 'atari5200', 'atari800', 'channelf', 'fba',
    'gamegear', 'gba', 'genesis', 'mastersystem', 'msx', 'neogeo', 'ngp',
    'pcengine', 'sega32x', 'sg-1000', 'vectrex'
]

def copy_roms(usb_path, retropie_path, consoles):
    for console in consoles:
        source_path = os.path.join(usb_path, console)
        destination_path = os.path.join(retropie_path, console)

        # Vérifie si le dossier de la console existe sur la clé USB
        if os.path.exists(source_path):
            # Crée le dossier de la console dans RetroPie s'il n'existe pas
            os.makedirs(destination_path, exist_ok=True)
            
            # Copie les ROMs du dossier de la console
            for rom in os.listdir(source_path):
                source_rom = os.path.join(source_path, rom)
                destination_rom = os.path.join(destination_path, rom)
                
                # Copie le fichier si ce n'est pas déjà fait
                if not os.path.exists(destination_rom):
                    shutil.copy2(source_rom, destination_rom)
                    print(f'Copié: {source_rom} vers {destination_rom}')
                else:
                    print(f'Le fichier existe déjà: {destination_rom}')

# Exécute la fonction de copie
copy_roms(usb_roms_path, retropie_roms_path, consoles)