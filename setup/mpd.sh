# Setup MPD 
begin_section MPD

log_exec pac_man mpd mpc udevil

systemctl enable "devmon@$MPD_USER.service"
log_exec systemctl start  "devmon@$MPD_USER.service"

cd /home/$MPD_USER

mkdir playlists
mkdir --parents music/{internal,media}

echo "/run/media/$MPD_USER /home/$MPD_USER/music/media none bind" >> /etc/fstab
mount -a

# Change mpd user
sed -i "s/\${MPDUSR}/$MPD_USER/g" $WORKING_DIR/conf/mpd.conf
cp $WORKING_DIR/conf/mpd.conf $CONFIG_FOLDER/mpd.conf

# Append the mpd config file to the mpd process
sed -i "/^ExecStart/ s|$| $CONFIG_FOLDER/mpd.conf|" /usr/lib/systemd/system/mpd.service

systemctl          enable mpd.service
log_exec systemctl start  mpd.service

log_exec mpc update

end_section MPD

cd $WORKING_DIR
