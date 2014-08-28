#!/bin/bash
#########################################################
# This script is intended to be run like this:
#
# curl https://.../bootstrap.sh | sudo bash
#
#########################################################

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Did you leave out sudo?"
	exit
fi

# Go to root's home directory.
cd

# Clone the carMPD repository if it doesn't exist.
if [ ! -d carMPD ]; then
	echo Downloading carMPD . . .
	pacman -Sy --noconfirm --quiet git
	git clone -q https://github.com/h8h/carMPD
	cd carMPD
fi

# Start setup script.
setup/start.sh