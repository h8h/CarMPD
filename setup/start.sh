#!/bin/bash
# This is the entry point for install carMPD.
#####################################################

source setup/functions.sh # load the functions

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Did you leave out sudo?"
    exit
fi

# First of all install `dialog` to ask the user questions even if stdin has been redirected,
# e.g. if we piped a bootstrapping install script to bash to get started.
# Furthermore install the mpd server.
pac_man dialog

message_box "Welcome" \
"Hello and thanks for using carMPD\n
Let's go!"

# Creates the mpd main user and its storage root to place all config files
useradd --user-group --create-home --groups power,audio $MPD_USER

if [ ! -d "/home/$MPD_USER/" ]; then
    message_box "Error creating new user" \
"The user $MPD_USER couldn't be created"
    exit
fi

# Setup the general carMPD configs folder
mkdir --parents .config/carMPD

# Install MPD
. setup/mpd.sh

get_systemd_status mpd

# Install Accesspoint 
ask_box "Accesspoint" \
"Should I install a wireless accesspoint for you?\n\n
Yes? Please plug-in your dongle and enter <Yes>" \
AP

if [ $AP -eq 0 ]; then
    pac_man pwgen iw

    get_supported_devices supported_devs

    if [ -z "$supported_devs" ]; then
        message_box "Can't install Accesspoint" \
        "Sorry, your dongle doesn't support AP."
    else
        input_radio "Select a network device" \
        "Please select a network device\n
you would like to use as an Accesspoint" \
        "$supported_devs" \
        SELECTED_DEV

        . setup/accesspoint.sh $SELECTED_DEV
        get_systemd_status create_ap
    fi
fi

# Install MPD Web GUI
ask_box "Web GUI" \
"Should I install ympd for you?\n\n
ympd is a standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS" \
WEB_GUI

if [ $WEB_GUI -eq 0 ]; then
    . setup/ympd.sh
    get_systemd_status ympd
fi
