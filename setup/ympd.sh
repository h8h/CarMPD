#!/bin/bash
# Setup Github:notandy:ympd
cd /home/$mpduser/

if [ -z "$TAG" ]; then
	TAG=v1.2.2
fi

pac_man cmake

# Build create_ap
if [ ! -d ympd ]; then
	git clone -q https://github.com/notandy/ympd
	chown -R $mpduser:$mpduser ympd
	cd ympd 
	git checkout -q $TAG
	
	# Build
	as_user "mkdir build"
	cd build
	as_user	"cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr"
	as_user "make"
	make install 
fi

cat > /usr/lib/systemd/system/ympd.service << EOF;
[Unit]
	Description=ympd server daemon
	Requires=network.target local-fs.target
[Service]
	Environment=MPD_HOST=localhost
	Environment=MPD_PORT=6600
	Environment=WEB_PORT=80
	EnvironmentFile=-/home/$mpduser/.config/ympd
	ExecStart=/usr/bin/ympd -h \$MPD_HOST -p \$MPD_PORT -w \$WEB_PORT
	Type=simple
	User=$mpduser
	Group=$mpduser
[Install]
	WantedBy=multi-user.target
EOF

systemctl enable ympd.service
systemctl start  ympd.service

cd
