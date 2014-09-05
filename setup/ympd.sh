# Setup Github:notandy:ympd
cd /home/$MPD_USER 

if [ -z "$TAG" ]; then
    TAG=v1.2.2
fi

begin_section YMPD

log_exec pac_man gcc cmake

# Build create_ap
if [ ! -d ympd ]; then
    git clone -q https://github.com/notandy/ympd
fi

cd ympd
git checkout -q $TAG

# Build
mkdir build
chown -R $MPD_USER:$MPD_USER ../ympd 

cd build
log_exec as_user "cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr"
log_exec as_user "make"
make install 
cd ..

YMPD_ENV_FILE=$CONFIG_FOLDER/ympd.env
YMPD_SERVICE=contrib/ympd.service

if [ -e "$YMPD_SERVICE" ]; then
    cat > $YMPD_ENV_FILE << EOF;
# YMPD configuration file
# Remember to restart the service if you change something
# systemctl restart ympd.service
# Have a nice ♪ day :)
MPD_HOST=localhost
MPD_PORT=6600
WEB_PORT=80
EOF

    # Let the MPDUSER user own the process
    sed -i "/^ExecStart/ s/$/ --user $MPD_USER/" $YMPD_SERVICE
    
    # Change the config file location
    sed -i "s|^EnvironmentFile=.*$|EnvironmentFile=$YMPD_ENV_FILE|" $YMPD_SERVICE

    mv $YMPD_SERVICE /usr/lib/systemd/system

    systemctl enable ympd.service
    log_exec systemctl start  ympd.service
    check_status ympd
fi

end_section YMPD

cd $WORKING_DIR
