#!/usr/bin/env python
import time
import mpd

client = mpd.MPDClient()
client.connect("localhost", 6600)
#client.timeout = 5 
print(client.mpd_version)
try:
    client.ping()
except mpd.ConnectionError:
    client.connect("localhost", 6600)

print('Go go')
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")
client.seekcur("+10")

client.close()
client.disconnect() 
