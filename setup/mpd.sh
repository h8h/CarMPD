# Setup MPD 
cd /home/$mpduser

mkdir music
echo "/mnt/music /home/$mpduser/music none bind" >> /etc/fstab

chmod u+x -R /mnt/music

mount -a

mkdir --parents .config/mpd/
chown -R $mpduser:$mpduser .config/mpd

# Change mpd user
sed -i "s/\${MPDUSR}/$mpduser/g" $working_dir/conf/mpd.conf

cp $working_dir/conf/mpd.conf .config/mpd/mpd.conf

systemctl enable mpd.service
systemctl start  mpd.service

cd $working_dir
