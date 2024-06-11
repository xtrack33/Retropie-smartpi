#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

# Set the version of the script
__version="4.8.6" # Script version

# Enable debugging if __debug is set to 1
[[ "$__debug" -eq 1 ]] && set -x # Turn on bash's debug mode if __debug equals 1

# Main RetroPie installation location
rootdir="/opt/retropie" # The root directory for RetroPie installation

# If __user is set, try and install for that user, else use SUDO_USER
if [[ -n "$__user" ]]; then
    user="$__user" # The user to install for if __user is set
    # Check if user exists, exit if not
    if ! id -u "$__user" &>/dev/null; then
        echo "User $__user does not exist" # User does not exist error message
        #exit 1
    fi
else
    user="$SUDO_USER" # Use SUDO_USER if __user not set
    [[ -z "$user" ]] && user="$(id -un)" # Use current user if SUDO_USER is not set
fi

# Define directories
home="$(eval echo ~$user)" # The home directory of the user
datadir="$home/RetroPie" # Data directory where RetroPie data will be stored
biosdir="$datadir/BIOS" # BIOS directory
romdir="$datadir/roms" # ROM directory
emudir="$rootdir/emulators" # Emulators directory
configdir="$rootdir/configs" # Configuration files directory

scriptdir="$(dirname "$0")" # Directory of the script
scriptdir="$(cd "$scriptdir" && pwd)" # Absolute path of the script directory

# Temporary and log directories
__logdir="$scriptdir/logs" # Log directory
__tmpdir="$scriptdir/tmp" # Temporary files directory
__builddir="$__tmpdir/build" # Build directory
__swapdir="$__tmpdir" # Swap directory

# Check if script is run with sudo
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Script must be run under sudo from the user you want to install for. Try 'sudo $0'" # Error message if not run as sudo
    #exit 1
fi

# Setup dialog backtitle
__backtitle="retropie.org.uk - RetroPie Setup. Installation folder: $rootdir for user $user" # Backtitle for dialogs

# Source other scripts
source "$scriptdir/scriptmodules/system.sh" # System functions
source "$scriptdir/scriptmodules/helpers.sh" # Helper functions
source "$scriptdir/scriptmodules/inifuncs.sh" # ini file functions
source "$scriptdir/scriptmodules/packages.sh" # Package functions

# Initialize environment and register modules
setup_env # Setup environment variables
rp_registerAllModules # Register all modules

# Ensure framebuffer mode is set
ensureFBMode 320 240 # Set framebuffer mode

# Main logic
rp_ret=0 # Default return code
if [[ $# -gt 0 ]]; then
    setupDirectories # Setup directories
    rp_callModule "$@" # Call module with arguments
    rp_ret=$? # Set return code based on module call
else
    rp_printUsageinfo # Print usage information if no arguments
fi

# Check for errors and print messages
if [[ "${#__ERRMSGS[@]}" -gt 0 ]]; then
    [[ "$rp_ret" -eq 0 ]] && rp_ret=1 # Set return code to 1 if there are error messages
    printMsgs "console" "Errors:\n${__ERRMSGS[@]}" # Print error messages
fi

# Print info messages if any
if [[ "${#__INFMSGS[@]}" -gt 0 ]]; then
    printMsgs "console" "Info:\n${__INFMSGS[@]}" # Print info messages
fi

final_ret=$rp_ret
echo "Script ended with code $final_ret"

