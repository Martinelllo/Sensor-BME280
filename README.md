# segment-display

## Install

add the host adress and user to the Makefile variable.
run `make install-ssh` to install yout public key on the host
run `make sync` to transfere all files
run `make remote` to get the host console
run
```bash
$ sudo apt-get update
$ sudo apt-get install build-essential python-dev python-openssl git-core
```
run `sudo apt-get install pigpio`
run `sudo systemctl start pigpiod`
run `sudo systemctl enable pigpiod`
run `pip install pigpio`
run `exit()`
run `make service-up` to install the autostart service

## guide

https://www.laub-home.de/wiki/Raspberry_Pi_BME280_Luftdruck_Sensor