#!/usr/bin/env python
import time
import os
import mpd 
import RPi.GPIO as GPIO

def next_button(id):
	"""
		Handles the two-state pullup button
		Short push - Next song
		Long  push - Seek current song 
	"""
	# TODO - Silly mutex, i will improve it
	global btn_next
	if btn_next:
		return
	btn_next = True

	# Switches the light on
	GPIO.output(24,GPIO.HIGH)

	time.sleep(0.2)
	
	# Is button still pushed - start seeking
	if not GPIO.input(id):
		while not GPIO.input(id):
			client.seekcur("+10")
			time.sleep(1)
	else:
		client.next()

	# Turns the led off
	GPIO.output(24,GPIO.LOW)

	# Release silly mutex
	btn_next = False

def prev_button(id):
	"""
		Handles the two-state pullup prev_button
		Short push - Next song
		Long  push - Poweroff Pi
	"""
	# TODO - Silly mutex, i will improve it
	global btn_prev
	if btn_prev:
		return
	btn_prev = True

	# Switches the led on
	GPIO.output(26,GPIO.HIGH)

	# Counter how long the button should be pushed 
	# to poweroff Pi
	times=10

	time.sleep(0.2)
	
	# Is button still pushed - start countdown
	if not GPIO.input(id):
		while not GPIO.input(id):
			times -= 1
			time.sleep(0.2)
		if times <= 0:
			GPIO.output(24,GPIO.HIGH)
			GPIO.output(26,GPIO.HIGH)
			os.system("/usr/bin/poweroff")
			return

	# Previous song
	client.previous()

	# Turns the led off
	GPIO.output(26,GPIO.LOW)

	# Release silly mutex
	btn_prev = False

# Set up the Pi
GPIO.setmode(GPIO.BOARD)
GPIO.setup(16, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(18, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(24, GPIO.OUT)
GPIO.setup(26, GPIO.OUT)

#Register Events
GPIO.add_event_detect(16, GPIO.FALLING, callback = next_button, bouncetime = 200)
GPIO.add_event_detect(18, GPIO.FALLING, callback = prev_button, bouncetime = 200)

# Turns the led off
GPIO.output(26,GPIO.LOW)
GPIO.output(24,GPIO.LOW)

# Inits the silly mutex
btn_next = False
btn_prev = False 

# Setup mpd client
client = mpd.MPDClient()
client.connect("localhost", 6600)

try:
	while True:
		try:
			client.ping()
		except mpd.ConnectionError:
			client.connect("localhost", 6600)
			time.sleep(55)

except KeyboardInterrupt:
	pass

GPIO.cleanup()
client.close()
client.disconnect()
