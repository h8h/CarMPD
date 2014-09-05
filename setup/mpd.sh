# Setup MPD 
begin_section MPD

log_exec pac_man mpd mpc udevil

systemctl enable "devmon@$MPD_USER.service"
log_exec systemctl start  "devmon@$MPD_USER.service"

cd /home/$MPD_USER

mkdir playlists
mkdir --parents music/{internal,media}

MOUNTPOINT_DEVMON="/run/media/$MPD_USER /home/$MPD_USER/music/media none bind"

if [ -z "`grep "$MOUNTPOINT_DEVMON" /etc/fstab`" ]; then
	echo "$MOUNTPOINT_DEVMON" >> /etc/fstab
fi

mount -a

# Change mpd user
sed -i "s|\${MPDUSR}|$MPD_USER|g" $WORKING_DIR/conf/mpd.conf
sed -i "s|\${CONFIG_FOLDER}|$CONFIG_FOLDER|g" $WORKING_DIR/conf/mpd.conf

cp $WORKING_DIR/conf/mpd.conf $CONFIG_FOLDER/mpd.conf

chown $MPD_USER:$MPD_USER $CONFIG_FOLDER/mpd.conf

# Append the mpd config file to the mpd process if it doesn't exist 
if [ -z "`grep "$CONFIG_FOLDER/mpd.conf" /usr/lib/systemd/system/mpd.service`" ]; then
	sed -i "/^ExecStart/ s|$| $CONFIG_FOLDER/mpd.conf|" /usr/lib/systemd/system/mpd.service
fi

systemctl          enable mpd.service
log_exec systemctl start  mpd.service

log_exec mpc update

# Is MPD running?
check_status mpd

end_section MPD

cd $WORKING_DIR
