#!/bin/bash
# Setup Github:oblique:create_ap 

echo $mpduser

cd /home/$mpduser/

git clone https://github.com/oblique/create_ap

chown -R $mpduser:$mpduser create_ap

input_box "Accesspoint - SSID" \
"Name your accesspoint (SSID)" \
"carMPD" \
SSID

if [ -z "$SSID" ]; then
	AP="carMPD"
fi

cat > /usr/lib/systemd/system/create_ap.service << EOF;
[Unit]
	Description=carMPD AP Service
	After=network.target

[Service]
	Type=simple
	ExecStart=/usr/bin/create_ap -n -g 10.0.0.1 $wlan_dev $SSID
	KillSignal=SIGINT
	Restart=on-failure
	RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable create_ap.service
systemctl start create_ap.service

cd