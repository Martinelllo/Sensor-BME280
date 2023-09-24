#!/usr/bin/python3
import board
import busio
from adafruit_bme280 import basic as adafruit_bme280
import time
from datetime import datetime
import requests


def sendSensorValue(id, value, headers):
   body = {
      "sensorId": id,
      "value": round(value, 1)
   }
   try:
      response = requests.post(URL + '/sensor-value', json=body, headers=headers)
      print('Sensor wert erfolgreich gesendet. Id' + id)
   except:
      print('request error')


if __name__ == "__main__":

   URL = "https://smarthome-api.hellmannweb.de" # server
   # URL = "http://192.168.178.20"

   # DEVICE_NAME='SensorPi'
   # DEVICE_PASSWORD='awdawd123'

   headers = {"Content-Type": "application/json; charset=utf-8"}

   # body = {
   #    "deviceName": DEVICE_NAME,
   #    "devicePassword": DEVICE_PASSWORD,
   # }
   # try:
   #    response = requests.post(URL + '/device-auth', json=body, headers=headers)
   #    token = response.text
   #    print(token)
   #    headers = {
   #       "Content-Type": "application/json; charset=utf-8",
   #       "Authorization": "Bearer "+token,
   #    }
   # except:
   #    print('request error')
   #    exit('Unauthorized')

   INTERVAL = 60

   i2c = busio.I2C(board.SCL, board.SDA)
   bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

   # change this to match the location's pressure (hPa) at sea level
   # need to be configured for the real altitude. Check your next Weatherstation for the pressure
   #bme280.sea_level_pressure = 1013.25

   bme280.mode = adafruit_bme280.MODE_NORMAL
   time.sleep(1) # wait until gpiod starts

   while True:

      # print("Temperature: %0.1f C" % bme280.temperature)
      # # print("Humidity: %0.1f %%" % bme280.humidity)
      # print("relative Humidity: %0.1f %%" % bme280.relative_humidity)
      # print("absolute Pressure: %0.1f hPa" % bme280.pressure)
      # # print("Altitude = %0.2f meters" % bme280.altitude)
      # print("-------------------------------------")

      sendSensorValue(3, bme280.temperature, headers)
      sendSensorValue(4, bme280.relative_humidity, headers)
      sendSensorValue(5, bme280.pressure, headers)

      # utcTimeStamp = datetime.utcnow().timestamp()
      # currentTime = datetime.now()


      time.sleep(INTERVAL)  # Overall INTERVAL second polling.