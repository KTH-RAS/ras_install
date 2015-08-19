#!/bin/bash

# install ros

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update
sudo apt-get install ros-indigo-desktop -y

sudo rosdep init
rosdep update

# setup environment
source /opt/ros/indigo/setup.bash
echo "export EDITOR=emacs" >> ~/.bashrc

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim -y

# install ros packages and other dependencies
sudo apt-get install ros-indigo-rqt-graph ros-indigo-rqt-gui ros-indigo-rqt-plot ros-indigo-kobuki-soft ros-indigo-kobuki-keyop ros-indigo-roscpp-tutorials ros-indigo-rosserial-arduino ros-indigo-rosserial-server ros-indigo-openni2-launch ros-indigo-openni2-camera ros-indigo-rgbd-launch ros-indigo-cmake-modules -y

sudo apt-get install libboost-random1.55-dev openjdk-7-jre ipython -y


# pip wstool and git
sudo apt-get install git python-pip -y

sudo pip install wstool


# create catkin ws

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src

catkin_init_workspace
wstool init

cd ~/catkin_ws
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

# merge rosinstall files
cd ~/catkin_ws/src
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/vm.rosinstall
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/arduino.rosinstall
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/ras_utils.rosinstall

wstool merge vm.rosinstall
wstool merge arduino.rosinstall
wstool merge ras_utils.rosinstall

wstool update

cd ~/catkin_ws
catkin_make

# compile arduino libraries and copy to sketchbook folder
mkdir -p ~/Arduino/libraries

source ~/catkin_ws/devel/setup.bash
cd ~/catkin_ws
rosrun rosserial_arduino make_libraries.py ~/Arduino/libraries

cp -a ~/catkin_ws/src/ras_arduino_inos/libraries/* ~/Arduino/libraries/

# install IMU
sudo apt-get install ros-indigo-phidgets* ros-indigo-imu-filter* -y
sudo cp /opt/ros/indigo/share/phidgets_api/udev/99* /etc/udev/rules.d/

# install arduino IDE
cd ~/Downloads/
wget ftp://130.237.218.63/arduino-1.6.5-linux64.tar.xz

tar -xJf arduino*tar.xz

cd /usr/local/bin
sudo ln -s ~/Downloads/arduino-1.6.5/arduino .

# add user to dialout group
sudo adduser ras dialout
sudo adduser ras audio
