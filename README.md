CarMPD
=============

**Not Ready To Use, its still under heavy development**

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
curl https://github.com/h8h/carMPD/bootstrap.sh | sudo bash
```
After some questions, you're ready to fill your raspberry pi with your favourite songs and start listening. Have fun!