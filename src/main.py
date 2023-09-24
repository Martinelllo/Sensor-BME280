#!/usr/bin/python3
import board
import busio
from adafruit_bme280 import basic as adafruit_bme280
import time
from datetime import datetime
import requests

device=2

def sendSensorValue(id, value):
   body = {
      "deviceId": device,
      "sensorId": id,
      "value": round(value, 1)
   }

   try:
      response = requests.post(url + '/sensor-value', json=body, headers=headers)
      print(response.text)
   except:
      print('request error')


if __name__ == "__main__":

   i2c = busio.I2C(board.SCL, board.SDA)
   bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

   # change this to match the location's pressure (hPa) at sea level
   # need to be configured for the real altitude. Check your next Weatherstation for the pressure
   #bme280.sea_level_pressure = 1013.25

   bme280.mode = adafruit_bme280.MODE_NORMAL
   time.sleep(1) # wait until gpiod starts

   INTERVAL = 1

   while True:

      print("Temperature: %0.1f C" % bme280.temperature)
      # print("Humidity: %0.1f %%" % bme280.humidity)
      print("relative Humidity: %0.1f %%" % bme280.relative_humidity)
      print("absolute Pressure: %0.1f hPa" % bme280.pressure)
      # print("Altitude = %0.2f meters" % bme280.altitude)
      print("-------------------------------------")


      url = "https://smarthome-api.hellmannweb.de" # server
      # url = "http://192.168.178.20" # server

      headers = {
         "Content-Type": "application/json; charset=utf-8",
      }

      # utcTimeStamp = datetime.utcnow().timestamp()
      # currentTime = datetime.now()

      # temperatureData = {
      #    "sensorId": 3,
      #    "value": round(bme280.temperature, 1)
      # }

      # humidityData  = {
      #    "sensorId": 4,
      #    "value": round(bme280.humidity, 1)
      # }

      # humidityData  = {
      #    "sensorId": 5,
      #    "value": round(bme280.pressure, 1)
      # }

      # try:
      #    response = requests.post(url + '/sensor-value', json=temperatureData, headers=headers)
      #    print(response.text)
      # except:
      #    print('request error')

      # try:
      #    response = requests.post(url + '/sensor-value', json=humidityData, headers=headers)
      #    print(response.text)
      # except:
      #    print('request error')

      # try:
      #    response = requests.post(url + '/sensor-value', json=humidityData, headers=headers)
      #    print(response.text)
      # except:
      #    print('request error')


      time.sleep(INTERVAL)  # Overall INTERVAL second polling.

   s.cancel()
   pi.stop()