#!/bin/bash
# This is the entry point for install carMPD.
#####################################################

source setup/functions.sh # load the functions

# First of all install `dialog` to ask the user questions even if stdin has been redirected,
# e.g. if we piped a bootstrapping install script to bash to get started.
# Furthermore install the mpd server.
pac_man dialog mpd

message_box "CarMPD Installation" \
			"Hello and thanks for using carMPD\n
			Let's go!"

ask_box "Accesspoint" \
		"Would you like to use a wireless accesspoint?\n\n
		Yes? Please plug-in your dongle and enter 'yes'" \
		AP

if [ "$AP" ]; then
	# Check if the dongle supports AP
	pac_man iw
	ap_support=`iw list | grep "\* AP$"`
	if [ -z "$ap_support" ]; then
		message_box "Can't install Accesspoint" \
		"Sorry, your dongle doesn't support AP."
	else
		. setup/accesspoint.sh
		. setup/ympd.sh
	fi
fi