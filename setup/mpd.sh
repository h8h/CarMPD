# Setup MPD 
pac_man mpd mpc udevil

systemctl enable "devmon@$MPD_USER.service"
systemctl start  "devmon@$MPD_USER.service"

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
systemctl start  mpd.service

mpc update

cd $WORKING_DIR
