# Setup Github:oblique:create_ap 
cd /home/$MPD_USER
DEV=$1

if [ -z "$DEV" ]; then
    # no ap-supported network device
    exit
fi

begin_section Accesspoint

log_exec pac_man make dnsmasq hostapd haveged

# Build create_ap
if [ ! -d create_ap ]; then
    log_exec git clone -q https://github.com/oblique/create_ap
    chown -R $MPD_USER:$MPD_USER create_ap
fi

cd create_ap
make install

input_box "Accesspoint - SSID" \
"Name your Accesspoint (SSID)" \
"CarMPD" \
SSID

if [ -z "$SSID" ]; then
    # user hit ESC/cancel
    exit
fi

while ! [[ "${#PASSPHRASE}" -ge 8 && "${#PASSPHRASE}" -le 63 ]]; do
    SAMPLE_KEY=`pwgen 12 1`
    input_box "Passphrase" \
    "Enter wpa security key for your new $SSID - SSID" \
    $SAMPLE_KEY \
    PASSPHRASE

    if [ -z "$PASSPHRASE" ]; then
        # user hit ESC/cancel
        exit
    fi

done

CREATEAP_ENV_FILE=$CONFIG_FOLDER/create_ap.env

cat > $CREATEAP_ENV_FILE << EOF;
# Accesspoint configuration file
# Remember to restart the service if you change something
# systemctl restart create_ap.service
# Have a nice ♪ day :)
DEV=$DEV
SSID=$SSID
PASSPHRASE=$PASSPHRASE
GATEWAY=10.0.0.1
EOF

cat > /usr/lib/systemd/system/create_ap.service << EOF;
[Unit]
    Description=CarMPD AP Service
    After=network.target

[Service]
    Type=simple
    EnvironmentFile=$CREATEAP_ENV_FILE
    ExecStart=/usr/bin/create_ap -n -g \$GATEWAY \$DEV \$SSID \$PASSPHRASE
    KillSignal=SIGINT
    Restart=on-failure
    RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable create_ap.service
log_exec systemctl start  create_ap.service

check_status create_ap

end_section Accesspoint

cd $WORKING_DIR
