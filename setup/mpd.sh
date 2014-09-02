# Setup MPD 

mkdir /var/lib/mpd/music
echo "/mnt/music /var/lib/mpd/music none bind" >> /etc/fstab

chown -R $mpduser:$mpduser /var/lib/mpd

chmod u+x -R /mnt/music

mount -a

cp conf/mpd.conf /etc/mpd.conf

systemctl enable mpd.service
systemctl start  mpd.service
