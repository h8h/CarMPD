CarMPD
======

**Not Ready To Use! It's still under heavy development**

Build up a headless out-of-the-box mpd server with a webclient (accessible via wireless lan) and a hardware control panel onto your raspberry pi.

Features
--------
* Out-of-the-box, just fire up one line and you have all the features
* AccessPoint, if you have an AP-supported wireless dongle, you can control mpd over the air
* Control mpd with some pushbuttons (GPIO)
* Easily upload your songs (not implemented yet)

Installation
------------
Connect to your raspberry pi (i.e via ssh) and fire up the following line
```
curl https://raw.githubusercontent.com/h8h/carMPD/master/bootstrap.sh | sudo bash
```
After some questions, you're ready to fill your raspberry pi with your favourite songs and start listening. Have fun!

Operating System Image
----------------------
You need (*Arch Linux*)[http://www.raspberrypi.org/downloads/] as Operating System image. I use it because its a lightweight linux distribution and it boots fast. 

For all raspbian fans I will provide a setup branch for raspbian soon. 

Why MPD?!
---------
Well yeah, why not using (Mopidy)[http://www.mopidy.com/]? I have not much experience in using Mopidy but I think Spotify, SoundCloud or Google Play Music is useless in a car without access to the internet.

Bugs or improvement suggestions?
--------------------------------
Simply open an issue.