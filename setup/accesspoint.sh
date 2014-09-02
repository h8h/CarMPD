#!/bin/bash
# Setup Github:oblique:create_ap 
cd /home/$mpduser/
wlan_dev=$1

if [ -z "wlan_dev" ]; then
	# no ap-supported network device
	exit
fi

# Build create_ap
if [ ! -d create_ap ]; then
	git clone -q https://github.com/oblique/create_ap
	chown -R $mpduser:$mpduser create_ap
	cd create_ap
	make install
fi

input_box "Accesspoint - SSID" \
"Name your Accesspoint (SSID)" \
"carMPD" \
SSID

if [ -z "$SSID" ]; then
	# user hit ESC/cancel
	exit
fi

pass_phrase=""

while ! [[ "${#pass_phrase}" -ge 8 && "${#pass_phrase}" -le 63 ]]; do
	sample_key=`pwgen 12 1`
	input_box "Passphrase" \
	"Enter wpa security key for your new $SSID - SSID" \
	$sample_key \
	pass_phrase

	if [ -z "$pass_phrase" ]; then
		# user hit ESC/cancel
		exit
	fi

done

pac_man dnsmasq hostapd haveged

cat > /usr/lib/systemd/system/create_ap.service << EOF;
[Unit]
	Description=carMPD AP Service
	After=network.target

[Service]
	Type=simple
	ExecStart=/usr/bin/create_ap -n -g 10.0.0.1 $wlan_dev $SSID $pass_phrase
	KillSignal=SIGINT
	Restart=on-failure
	RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable create_ap.service
systemctl start  create_ap.service

echo "WD = $WD"
cd $WD
