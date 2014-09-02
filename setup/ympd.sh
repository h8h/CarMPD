# Setup Github:notandy:ympd
cd /home/$mpduser/ 

if [ -z "$TAG" ]; then
	TAG=v1.2.2
fi

pac_man gcc cmake

# Build create_ap
if [ ! -d ympd ]; then
	git clone -q https://github.com/notandy/ympd
	cd ympd 
	git checkout -q $TAG
	
	# Build
	mkdir build

	chown -R $mpduser:$mpduser ../ympd 
	
	cd build
	as_user	"cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr"
	as_user "make"
	make install 
	cd ..
	# Let the mpd user own the process
	sed -i '/^ExecStart/ s/$/ --user mpd/' contrib/ympd.service
	mv contrib/ympd.service /usr/lib/systemd/system
fi

systemctl enable ympd.service
systemctl start  ympd.service

cd $working_dir
