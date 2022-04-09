#!/usr/bin/python

# Quote the script of the following project
# https://github.com/adafruit/Adafruit_Python_DHT.git

import datetime
import time
import Adafruit_DHT
import sys

# Basic parameters
nowtime = datetime.datetime.now()
strtime = nowtime.strftime('%H:%M ')

# Specify one of the following
# - Adafruit_DHT.DHT11.
# - Adafruit_DHT.DHT22.
# - Adafruit_DHT.AM2302.
sensor = Adafruit_DHT.DHT22

# Spacify the P8_11 pin
#pin = 'P8_11'
# Spacify the GPIO23 pin
pin = 23

# Perform temperature and humidity processing
# Timeout 15 seconds
humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

# Determine if the process was successful
# 1 = Output temperature / humidity processing
# 0 = Output an error statement
if humidity is None and temperature is None:
    while True:
        humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
        if humidity is not None and temperature is not None:
            sys.stdout.write(strtime)
            print('{0:0.1f} {1:0.1f}'.format(temperature, humidity))
            break