#!/bin/bash

# installing phidgets library

cd && sudo apt-get install libusb-1.0-0-dev
cd /tmp && wget http://www.phidgets.com/downloads/phidget21/libraries/linux/libphidget/libphidget_2.1.8.20170607.tar.gz -O libphidget.tar.gz
tar -zxvf libphidget.tar.gz
cd libphidget*
./configure
make
sudo make install
sudo cp udev/99-phidgets.rules /etc/udev/rules.d
cd
