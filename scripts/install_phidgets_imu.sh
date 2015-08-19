#!/bin/bash

sudo apt-get install ros-indigo-phidgets* ros-indigo-imu-filter* -y

sudo cp /opt/ros/indigo/share/phidgets_api/udev/99* /etc/udev/rules.d/
