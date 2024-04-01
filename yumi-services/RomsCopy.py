import os
import shutil
import logging

# Configuration du logging
log_filename = 'romscopy.log'
logging.basicConfig(filename=log_filename, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

# Début du script
logging.info('Démarrage du script de copie des ROMs.')

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
    # Vérifie si le chemin USB existe pour confirmer la présence de la clé USB
    if os.path.exists(usb_path):
        logging.info(f'Clé USB détectée à {usb_path}.')
    else:
        logging.warning('Clé USB non détectée. Vérifiez le chemin et assurez-vous que la clé USB est connectée.')
        return

    for console in consoles:
        source_path = os.path.join(usb_path, console)
        destination_path = os.path.join(retropie_path, console)

        if os.path.exists(source_path):
            if not os.path.exists(destination_path):
                os.makedirs(destination_path, exist_ok=True)
                logging.info(f'Dossier créé : {destination_path}')
            else:
                logging.info(f'Dossier déjà existant : {destination_path}')
                
            for rom in os.listdir(source_path):
                source_rom = os.path.join(source_path, rom)
                destination_rom = os.path.join(destination_path, rom)
                
                if not os.path.exists(destination_rom):
                    shutil.copy2(source_rom, destination_rom)
                    logging.info(f'Copié: {source_rom} vers {destination_rom}')
                else:
                    logging.info(f'Le fichier existe déjà et n\'a pas été recopié: {destination_rom}')

    logging.info('Processus de copie terminé. Si vous avez fini, vous pouvez déconnecter la clé USB en toute sécurité.')

# Exécute la fonction de copie
copy_roms(usb_roms_path, retropie_roms_path, consoles)
