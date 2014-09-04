# Setup MPD 
log_exec echo "--------- BEGIN MPD installation process ---------"
log_exec pac_man mpd mpc udevil

systemctl enable "devmon@$MPD_USER.service"
log_exec systemctl start  "devmon@$MPD_USER.service"

cd /home/$MPD_USER
mkdir --parents music/{internal,media}
mkdir --parents .config/mpd/playlists
chown -R $MPD_USER:$MPD_USER .config/mpd

echo "/run/media/$MPD_USER /home/$MPD_USER/music/media none bind" >> /etc/fstab
mount -a

# Change mpd user
sed -i "s/\${MPDUSR}/$MPD_USER/g" $WORKING_DIR/conf/mpd.conf

cp $WORKING_DIR/conf/mpd.conf .config/mpd/mpd.conf

systemctl enable mpd.service
log_exec systemctl start  mpd.service

log_exec mpc update

log_exec echo "--------- END MPD installation process ---------"
cd $WORKING_DIR
