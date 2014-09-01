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
pac_man dialog mpd

message_box "CarMPD Installation" \
"Hello and thanks for using carMPD\n
Let's go!"

# Creates the mpd main user and its storage root to place all config files
useradd --user-group --create-home $mpduser

if [ ! -d "/home/$mpduser/" ]; then
	message_box "Error creating new user" \
"The user mpduser wasn't created"
	exit
fi



ask_box "Accesspoint" \
"Would you like to use a wireless accesspoint?\n\n
Yes? Please plug-in your dongle and enter <Yes>" \
AP

if [ $AP -eq 0 ]; then
	# Check if the dongle supports AP
    pac_man iw

    devs=`iw dev | sed -n "s/^\t*Interface[[:space:]]\(w.*\)/\1/p"`
    supported_devs=""
	
	for dev in `echo $devs`; do
		wiphy=`iw $dev info | sed -n "s/^\t*wiphy[[:space:]]\([0-9]*\)$/\1/p"`
		ap_support=`iw phy\#$wiphy info | grep "\* AP$"`
		
		if [ -n "$ap_support" ]; then
			supported_devs="$supported_devs$dev\n"
		fi
	done

	#if [ -z "$ap_support" ]; then
	#	message_box "Can't install Accesspoint" \
	#	"Sorry, your dongle doesn't support AP."
	#else
	. setup/accesspoint.sh
	#. setup/ympd.sh
	#fi
fi
